import 'package:flutter/material.dart';
import 'package:novinpay/app_state.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/dual_list_tile.dart';

class Wallet extends StatefulWidget {
  Wallet({this.onTap});

  final VoidCallback onTap;

  @override
  State<StatefulWidget> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  void initState() {
    super.initState();

    appState.wallet.addListener(_onBalanceChanged);
    _getBalance();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: ClipRRect(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: colors.ternaryColor,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              PositionedDirectional(
                bottom: -48,
                end: -48,
                child: Opacity(
                  opacity: 0.5,
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white,
                    size: 96,
                  ),
                ),
              ),
              DualListTile(
                start: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اعتبار کیف پول شما',
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      toRials(appState.wallet.balance ?? 0),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                end: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                          color: colors.primaryColor.shade900, width: 2.0)),
                  child: Icon(
                    Icons.add,
                    color: colors.primaryColor.shade900,
                    size: 28.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    appState.wallet.removeListener(_onBalanceChanged);
    super.dispose();
  }

  void _getBalance() async {
    nh.wallet.getBalance();
  }

  void _onBalanceChanged() {
    if (mounted) {
      setState(() {});
    }
  }
}
