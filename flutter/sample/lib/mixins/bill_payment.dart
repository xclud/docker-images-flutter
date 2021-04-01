import 'package:flutter/material.dart';
import 'package:novinpay/bill_info.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/models/shaparak.dart';
import 'package:novinpay/pages/overview_page.dart';
import 'package:novinpay/pay_info.dart';
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/bill/pay_helpers.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:persian/persian.dart';

mixin BillPaymentMixin<T extends StatefulWidget> on State<T> {
  Future<PayBillResult> payBill({
    @required String title,
    @required BillInfo billInfo,
    @required String acceptorId,
    @required String acceptorName,
    BillType type,
  }) async {
    if (billInfo.amount == 0) {
      ToastUtils.showCustomToast(context, 'بدهی برای پرداخت وجود ندارد.',
          Image.asset('assets/ok.png'));
      return PayBillResult.zeroAmount();
    }

    final payInfo = await showPaymentBottomSheet(
      context: context,
      title: (title == null || title.isEmpty) ? Text('قبض') : Text(title),
      amount: billInfo.amount,
      acceptorName: acceptorName,
      transactionType: TransactionType.bill,
      acceptorId: acceptorId,
      enableWallet: false,
      children: [
        DualListTile(
          start: Text('شناسه قبض'),
          end: Text(billInfo.billId.toString().withPersianNumbers()),
        ),
        DualListTile(
          start: Text('شناسه پرداخت'),
          end: Text(billInfo.paymentId.toString().withPersianNumbers()),
        ),
      ],
    );

    if (payInfo == null) {
      return PayBillResult.userCanceled();
    }

    if (payInfo.type == PaymentType.normal) {
      final data = await Loading.run(
        context,
        nh.billPayment.billPayment(
          cardInfo: payInfo.cardInfo,
          billInfo: billInfo,
        ),
      );

      if (data.isError) {
        if (!data.isExpired) {
          ToastUtils.showCustomToast(
              context, data.error, Image.asset('assets/error.png'));
        }
        return PayBillResult.networkError();
      }

      if (data.content.status != true) {
        showFailedTransaction(context, data.content.description,
            data.content.stan, data.content.rrn, 'پرداخت قبض', billInfo.amount);
        return PayBillResult.serverError(data.content.description);
      }
      nh.mru.addMru(
        type: MruType.sourceCard,
        title: Utils.getBankName(payInfo.cardInfo.pan),
        value: removeDash(payInfo.cardInfo.pan),
        expDate: payInfo.cardInfo.expire,
      );
      if (type == BillType.elec) {
        nh.electricBill.registerPayment(
            billId: int.tryParse(billInfo.billId ?? ''),
            paymentId: int.tryParse(billInfo.paymentId ?? ''),
            bankCode: getBankCode(payInfo.cardInfo.pan),
            refCode: int.tryParse(data.content.rrn ?? ''),
            amount: billInfo.amount);
      }
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OverViewPage(
              title: title ?? 'پرداخت قبض',
              cardNumber: payInfo.cardInfo.pan,
              stan: data.content.stan,
              rrn: data.content.rrn,
              description:
                  'پرداخت قبض با شناسه پرداخت ${billInfo.paymentId}\nشناسه قبض: ${billInfo.billId}',
              amount: billInfo.amount,
              isShaparak: true),
        ),
      );
    } else if (payInfo.type == PaymentType.wallet) {
      final balanceData = await Loading.run(context, nh.wallet.getBalance());

      if (balanceData.isError) {
        if (!balanceData.isExpired) {
          ToastUtils.showCustomToast(
              context, balanceData.error, Image.asset('assets/error.png'));
        }
        return PayBillResult.networkError();
      }
      if (balanceData.content.status != true) {
        ToastUtils.showCustomToast(context, balanceData.content.description,
            Image.asset('assets/error.png'));
        return PayBillResult.serverError(balanceData.content.description);
      }

      final data = await Loading.run(
        context,
        nh.wallet.billPayment(
          billId: billInfo.billId,
          paymentId: billInfo.paymentId,
          billAmount: billInfo.amount,
          balance: balanceData.content.balance,
        ),
      );

      if (data.isError) {
        if (!data.isExpired) {
          ToastUtils.showCustomToast(
              context, data.error, Image.asset('assets/error.png'));
        }
        return PayBillResult.networkError();
      }
      if (data.content.status != true) {
        showFailedTransaction(
          context,
          data.content.description,
          null,
          data.content.rrn,
          'پرداخت قبض',
          billInfo.amount,
        );

        return PayBillResult.serverError(data.content.description);
      }
      if (type == BillType.elec) {
        nh.electricBill.registerPayment(
            billId: int.tryParse(billInfo.billId ?? ''),
            paymentId: int.tryParse(billInfo.paymentId ?? ''),
            bankCode: getBankCode(payInfo.cardInfo.pan),
            refCode: int.tryParse(data.content.rrn ?? ''),
            amount: billInfo.amount);
      }

      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OverViewPage(
              title: title ?? 'پرداخت قبض',
              cardNumber: null,
              stan: null,
              rrn: data.content.rrn,
              description:
                  'پرداخت قبض با شناسه پرداخت ${billInfo.paymentId}\nشناسه قبض: ${billInfo.billId}',
              amount: billInfo.amount,
              isShaparak: false),
        ),
      );
    }

    return PayBillResult.successfull();
  }
}
enum BillType { elec, phone, mobile, service, carFine }
