import 'package:flutter/material.dart';

class StorageSelectionDialog extends StatefulWidget {
  @override
  _StorageSelectionDialogState createState() => _StorageSelectionDialogState();
}

class _StorageSelectionDialogState extends State<StorageSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return StorageList();
  }
}

class StorageList extends StatefulWidget {
  @override
  _StorageListState createState() => _StorageListState();
}

class _StorageListState extends State<StorageList> {
  List<Storage> _listOfStorage;

  @override
  void initState() {
    super.initState();
    _listOfStorage = _getStorageList();
  }

  List<Storage> _getStorageList() {
    List<Storage> storageList = [];
    storageList.add(Storage(id: 1, name: 'کارت ها'));
    storageList.add(Storage(id: 2, name: 'موبایل ها'));
    storageList.add(Storage(id: 3, name: 'حساب ها'));
    storageList.add(Storage(id: 4, name: 'شباها'));
    storageList.add(Storage(id: 5, name: 'خلافی ها'));
    storageList.add(Storage(id: 6, name: 'تسهیلات'));
    storageList.add(Storage(id: 7, name: 'تلفن های ثابت'));
    return storageList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _listOfStorage.length,
        itemBuilder: (context, index) {
          return StorageItem(storage: _listOfStorage[index]);
        });
  }
}

class StorageItem extends StatelessWidget {
  StorageItem({@required this.storage});

  final Storage storage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(storage);
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 14.0, bottom: 14.0, left: 10.0, right: 10.0),
              child: Text(storage.name),
            ),
            Container(
              height: 1,
              color: Colors.grey.shade300,
            )
          ],
        ),
      ),
    );
  }
}

class Storage {
  Storage({@required this.id, @required this.name});

  int id;
  String name;
}
