import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';

class ProfileData extends ChangeNotifier {
  String _firstName;
  String _lastName;
  String _email;
  String _nationalNumber;
  String _birthDate;
  LatLng _location;
  int _birthCityId;
  int _addressCityId;
  String _address;
  int _score;
  int _image = 0;

  String get firstName => _firstName;
  set firstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  String get lastName => _lastName;
  set lastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  String get fullName {
    final parts = <String>[];
    if (_firstName != null && _firstName.isNotEmpty) {
      parts.add(_firstName);
    }

    if (_lastName != null && _lastName.isNotEmpty) {
      parts.add(_lastName);
    }

    return parts.join(' ');
  }

  String get nationalNumber => _nationalNumber;
  set nationalNumber(String value) {
    _nationalNumber = value;
    notifyListeners();
  }

  String get email => _email;
  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String get birthDate => _birthDate;
  set birthDate(String value) {
    _birthDate = value;
    notifyListeners();
  }

  LatLng get location => _location;
  set location(LatLng value) {
    _location = value;
    notifyListeners();
  }

  int get birthCityId => _birthCityId;
  set birthCityId(int value) {
    _birthCityId = value;
    notifyListeners();
  }

  int get addressCityId => _addressCityId;
  set addressCityId(int value) {
    _addressCityId = value;
    notifyListeners();
  }

  String get address => _address;
  set address(String value) {
    _address = value;
    notifyListeners();
  }

  int get score => _score;
  set score(int value) {
    _score = value;
    notifyListeners();
  }

  int get image => _image;
  set image(int value) {
    _image = value;
    notifyListeners();
  }
}
