import 'dart:convert';
import 'dart:typed_data';

import 'package:novinpay/repository/response.dart';

class GetBannersResponse extends ResponseBase {
  GetBannersResponse({
    @required this.directories,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory GetBannersResponse.fromJson(Map<String, dynamic> json) {
    final directories = <Directory>[];
    if (json['directories'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['directories'])
          .map((e) => Directory.fromJson(e))
          .toList();
      directories.addAll(tmp);
    }

    return GetBannersResponse(
      directories: directories,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['directories'] = directories.map((e) => e.toJson()).toList();
    return data;
  }

  final List<Directory> directories;
}

class Directory {
  Directory({
    @required this.directoryName,
    @required this.banners,
  });

  factory Directory.fromJson(Map<String, dynamic> json) {
    final banners = <Banner>[];
    if (json['banners'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['banners'])
          .map((e) => Banner.fromJson(e))
          .toList();
      banners.addAll(tmp);
    }

    return Directory(
      directoryName: json['directoryName'],
      banners: banners,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['directoryName'] = directoryName;
    data['banners'] = banners.map((e) => e.toJson()).toList();
    return data;
  }

  final String directoryName;
  final List<Banner> banners;
}

class Banner {
  Banner({@required this.image, @required this.filename});

  Banner.fromJson(Map<String, dynamic> json)
      : this(
            image: base64.decode(json['base64Image']),
            filename: json['fileName']);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['base64Image'] = image;
    data['fileName'] = filename;
    return data;
  }

  final Uint8List image;
  final String filename;
}
