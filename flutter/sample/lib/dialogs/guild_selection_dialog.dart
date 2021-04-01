import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/iran.dart';
import 'package:novinpay/models/novinpay.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/widgets/general/general.dart';

class GuildSelectionDialog extends StatefulWidget {
  GuildSelectionDialog(this.province, this.city);

  final Province province;
  final City city;

  @override
  _GuildSelectionDialogState createState() => _GuildSelectionDialogState();
}

class _GuildSelectionDialogState extends State<GuildSelectionDialog> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Response<GetListOfGuildsResponse> _data;
  final _controller = TextEditingController();
  String _query;

  Widget _buildList() {
    var guilds = _data.content.guilds;

    if (_query != null && _query.isNotEmpty) {
      guilds =
          guilds.where((element) => element.title.contains(_query)).toList();
    }

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: guilds.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.of(context).pop(guilds[index]);
          },
          title: Text(guilds[index].title),
        );
      },
    );
  }

  Widget _buildMessage(String message) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 24, end: 24),
      child: Text(
        message ?? '',
        style: colors
            .regularStyle(context)
            .copyWith(color: colors.greyColor.shade900),
        textAlign: TextAlign.center,
        softWrap: true,
      ),
    );
  }

  Widget _buildChild() {
    if (_data == null) {
      return _buildMessage(strings.noItemsFound);
    }

    if (_data.isError) {
      return _buildMessage(strings.connectionError);
    }

    if (_data.content.status != true) {
      return _buildMessage(
          _data.content.description ?? strings.connectionError);
    }

    return _buildList();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: _onRefresh,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              onChanged: (String value) => _onSearch(value),
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'جست و جو',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Space(),
            Expanded(child: _buildChild()),
          ],
        ),
      ),
    );
  }

  void _onSearch(String value) {
    setState(() {
      _query = value;
    });
  }

  Future<void> _onRefresh() async {
    final data = await nh.novinPay.application.getListOfGuilds();

    setState(() {
      _data = data;
    });
  }
}
