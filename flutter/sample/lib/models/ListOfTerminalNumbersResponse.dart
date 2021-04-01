import 'package:novinpay/repository/response.dart';

class ListOfTerminalNumbersResponse extends ResponseBase {
  ListOfTerminalNumbersResponse({
    @required this.listOfTerminals,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory ListOfTerminalNumbersResponse.fromJson(Map<String, dynamic> json) {
    var listOfTerminals = <ListOfTerminals>[];
    if (json.containsKey('listOfTerminals')) {
      final dc = List<Map<String, dynamic>>.from(json['listOfTerminals']);
      listOfTerminals = dc.map((e) => ListOfTerminals.fromJson(e)).toList();
    }
    return ListOfTerminalNumbersResponse(
      listOfTerminals: listOfTerminals,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['listOfTerminals'] = listOfTerminals.map((v) => v.toJson()).toList();
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  final List<ListOfTerminals> listOfTerminals;
}

class ListOfTerminals {
  ListOfTerminals({
    @required this.accountShabaCode,
    @required this.bank,
    @required this.city,
    @required this.customerName,
    @required this.guild,
    @required this.guildCode,
    @required this.merchantId,
    @required this.mobile,
    @required this.phoneNumber,
    @required this.portType,
    @required this.shaparakAddressText,
    @required this.posType,
    @required this.terminalId,
    @required this.state,
    @required this.workTitle,
  });

  ListOfTerminals.fromJson(Map<String, dynamic> json)
      : this(
          accountShabaCode: json['accountShabaCode'],
          bank: json['bank'],
          city: json['city'],
          customerName: json['customerName'],
          guild: json['guild'],
          guildCode: json['guildCode'],
          merchantId: json['merchantId'],
          mobile: json['mobile'],
          phoneNumber: json['phoneNumber'],
          portType: json['portType'],
          shaparakAddressText: json['shaparakAddressText'],
          posType: json['posType'],
          terminalId: json['terminalId'],
          state: json['state'],
          workTitle: json['workTitle'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountShabaCode'] = accountShabaCode;
    data['bank'] = bank;
    data['city'] = city;
    data['customerName'] = customerName;
    data['guild'] = guild;
    data['guildCode'] = guildCode;
    data['merchantId'] = merchantId;
    data['mobile'] = mobile;
    data['phoneNumber'] = phoneNumber;
    data['portType'] = portType;
    data['shaparakAddressText'] = shaparakAddressText;
    data['posType'] = posType;
    data['terminalId'] = terminalId;
    data['state'] = state;
    data['workTitle'] = workTitle;
    return data;
  }

  final String accountShabaCode;
  final String bank;
  final String city;
  final String customerName;
  final String guild;
  final String guildCode;
  final String merchantId;
  final String mobile;
  final String phoneNumber;
  final String portType;
  final String shaparakAddressText;
  final String posType;
  final String terminalId;
  final String state;
  final String workTitle;
}
