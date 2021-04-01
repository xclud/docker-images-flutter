import 'package:flutter/material.dart';
import 'package:novinpay/iran.dart';
import 'package:novinpay/widgets/general/general.dart';

class CitySelectionDialog extends StatefulWidget {
  CitySelectionDialog({
    @required this.scrollController,
    @required this.province,
  });

  final Province province;
  final ScrollController scrollController;

  @override
  _CitySelectionDialogState createState() => _CitySelectionDialogState();
}

class _CitySelectionDialogState extends State<CitySelectionDialog> {
  String _query;
  final _controller = TextEditingController();

  Widget _buildChild() {
    var cities = widget.province.cities;
    var c = cities;
    if (_query != null && _query.isNotEmpty) {
      c = cities.where((element) => element.name.contains(_query)).toList();
    }
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: c.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.of(context).pop(c[index]);
          },
          title: Text(c[index].name),
        );
      },
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
          Expanded(child: _buildChild()),
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
