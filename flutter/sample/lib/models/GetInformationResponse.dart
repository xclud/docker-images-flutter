import 'package:novinpay/repository/response.dart';

class GetInformationBodyResponse extends ResponseBase {
  GetInformationBodyResponse({
    @required this.branchs,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  GetInformationBodyResponse.fromJson(Map<String, dynamic> json)
      : this(
          branchs: List.from(json['branchs'])
              .map((v) => Branch.fromJson(v))
              .toList(),
          status: json['status'],
          mobileNumber: json['mobileNumber'],
          description: json['description'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['status'] = status;
    data['description'] = description;
    data['branchs'] = branchs.map((v) => v.toJson()).toList();

    return data;
  }

  List<Branch> branchs;
}

class Branch {
  Branch({@required this.code, @required this.name});

  Branch.fromJson(Map<String, dynamic> json)
      : this(
          code: int.tryParse(json['branchCode'] ?? '') ?? 0,
          name: json['branchName'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['branchCode'] = code;
    data['branchName'] = name;
    return data;
  }

  final int code;
  final String name;
}
