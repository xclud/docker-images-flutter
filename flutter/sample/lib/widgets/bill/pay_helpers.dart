enum PayBillReason {
  unknown,
  zero_amount,
  user_canceled,
  network_error,
  server_error,
  successfull,
}

class PayBillResult {
  PayBillResult.serverError(this.error) : reason = PayBillReason.server_error;

  PayBillResult.networkError()
      : reason = PayBillReason.network_error,
        error = null;

  PayBillResult.zeroAmount()
      : reason = PayBillReason.zero_amount,
        error = null;

  PayBillResult.userCanceled()
      : reason = PayBillReason.user_canceled,
        error = null;

  PayBillResult.successfull()
      : reason = PayBillReason.successfull,
        error = null;
  final PayBillReason reason;
  final String error;
}
