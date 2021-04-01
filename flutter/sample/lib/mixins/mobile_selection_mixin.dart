import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:permission_handler/permission_handler.dart';

mixin MobileNumberSelectionMixin<T extends StatefulWidget>
    on MruSelectionMixin<T> {
  void _getContact() async {
    if (!await Permission.contacts.isGranted) {
      await Permission.contacts.request();
    }

    if (!await Permission.contacts.isGranted) {
      return;
    }

    final contact = await ContactsService.openDeviceContactPicker();

    if (contact == null) {
      return;
    }

    final phones = contact.phones.toList();
    if (phones.isEmpty) {
      return;
    }

    final m = phones[0].value;

    final item = MruItem(id: -1, title: contact.displayName, value: m);

    Navigator.of(context).pop(item);
  }

  Future<MruItem> showMobileSelectionDialog(
          {Widget title = const Text('موبایل های من')}) =>
      showMruSelectionDialog(
        mru: MruType.mobile,
        title: isWeb
            ? title
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null) title,
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                    child: FlatButton(
                      onPressed: _getContact,
                      child: Row(
                        children: [
                          Text(
                            'انتخاب از مخاطبین',
                            style: colors
                                .boldStyle(context)
                                .copyWith(color: colors.ternaryColor),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.contact_phone_outlined,
                            color: colors.ternaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      );
}
