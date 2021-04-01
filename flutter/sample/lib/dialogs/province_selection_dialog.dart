import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:novinpay/iran.dart';
import 'package:novinpay/widgets/general/general.dart';

class ProvinceSelectionDialog extends StatefulWidget {
  ProvinceSelectionDialog({@required this.scrollController});

  final ScrollController scrollController;

  @override
  _ProvinceSelectionDialogState createState() =>
      _ProvinceSelectionDialogState();
}

class _ProvinceSelectionDialogState extends State<ProvinceSelectionDialog> {
  String _query;
  final _controller = TextEditingController();

  Widget _buildChild() {
    var p = provinces;
    if (_query != null && _query.isNotEmpty) {
      p = provinces.where((element) => element.name.contains(_query)).toList();
    }
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: p.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.of(context).pop(p[index]);
          },
          title: Text(p[index].name),
        );
      },
      shrinkWrap: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          Flexible(child: _buildChild()),
        ],
      ),
    );
  }

  void _onSearch(String value) {
    setState(() {
      _query = value;
    });
  }
}
