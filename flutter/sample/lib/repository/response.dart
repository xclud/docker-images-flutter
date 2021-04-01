import 'dart:convert';

import 'package:flutter/foundation.dart';

export 'package:flutter/foundation.dart';

class Response<T extends ResponseBase> {
  const Response(this.statusCode, {this.content, this.error});

  const Response.error({T content}) : this(-1, error: 'CONNECTION_ERROR');

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['content'] = content?.toString();
    data['error'] = error;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  /// The HTTP status code for this response.
  final int statusCode;

  /// Content returned from server.
  final T content;

  final String error;

  bool get isError => statusCode != 200;

  bool get isExpired => statusCode == 423;

  bool hasErrors() => isError || content.status != true;
}

abstract class ResponseBase {
  ResponseBase({
    @required this.status,
    @required this.description,
    @required this.mobileNumber,
    @required this.errorMessage,
  });

  final bool status;
  final String description;
  final String mobileNumber;
  final String errorMessage;
}
