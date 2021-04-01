import 'dart:convert';

import 'package:novinpay/repository/response.dart';

class RequestTokenResponse extends ResponseBase {
  RequestTokenResponse({
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  RequestTokenResponse.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;

    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class GetListOfGuildsResponse extends ResponseBase {
  GetListOfGuildsResponse({
    @required this.guilds,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory GetListOfGuildsResponse.fromJson(Map<String, dynamic> json) {
    final guilds = <Guild>[];
    if (json['guilds'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['guilds'])
          .map((e) => Guild.fromJson(e))
          .toList();

      guilds.addAll(tmp);
    }

    return GetListOfGuildsResponse(
      guilds: guilds,
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
    data['errorMessage'] = errorMessage;

    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  List<Guild> guilds;
}

class Guild {
  Guild({
    @required this.id,
    @required this.bussiness,
    @required this.code,
    @required this.supplementaryCode,
    @required this.title,
    @required this.type,
    @required this.typeId,
    @required this.isActive,
  });

  Guild.fromJson(Map<String, dynamic> json)
      : this(
          id: json['guildId'],
          bussiness: json['bussinessTitle'],
          code: json['guildCode'],
          supplementaryCode: json['guildSupplementaryCode'],
          title: json['guildTitle'],
          type: json['guildType'],
          typeId: json['guildTypeId'],
          isActive: json['isActive'],
        );
  final int id;
  final String bussiness;
  final String code;
  final String supplementaryCode;
  final String title;
  final bool isActive;
  final int typeId;
  final String type;
}
