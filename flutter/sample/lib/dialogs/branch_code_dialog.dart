import 'package:flutter/material.dart';
import 'package:novinpay/models/GetInformationResponse.dart';
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:persian/persian.dart';

class BranchCodeDialog extends StatefulWidget {
  @override
  _BranchCodeDialogState createState() => _BranchCodeDialogState();
}

class _BranchCodeDialogState extends State<BranchCodeDialog> {
  List<Branch> branches = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getBranchCodes();
    });
    super.initState();
  }

  void _getBranchCodes() async {
    final response = await Loading.run(context, nh.boomMarket.getInformation());
    if (!showError(context, response)) {
      return;
    }
    branches.addAll(response.content.branchs);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: branches.length,
        itemBuilder: (context, index) {
          return BranchItem(branch: branches[index]);
        });
  }
}

class BranchItem extends StatelessWidget {
  BranchItem({@required this.branch});

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(branch);
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('شعبه'),
                    Text('کد'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(branch.name),
                    Text(branch.code?.toString()?.withPersianNumbers()),
                  ],
                ),
              ),
              Center(
                  child: Image.asset(
                'assets/logo.png',
                height: 16,
              ))
            ],
          ),
          Container(
            margin: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
            height: 1,
            color: Colors.black26,
          )
        ],
      ),
    );
  }
}
