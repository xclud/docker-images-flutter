import 'package:novinpay/repository/response.dart';

class GetInvitationLinkResponse extends ResponseBase {
  GetInvitationLinkResponse({
    @required this.text,
    @required this.invitationModel,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  GetInvitationLinkResponse.fromJson(Map<String, dynamic> json)
      : this(
            text: json['text'],
            invitationModel: InvitationModel.fromJson(json['invitationModel']),
            status: json['status'],
            description: json['description'],
            mobileNumber: json['mobileNumber'],
            errorMessage: json['errorMessage']);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['text'] = text;
    data['invitationModel'] = invitationModel;
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    return data;
  }

  final String text;
  final InvitationModel invitationModel;
}

class InvitationModel {
  InvitationModel({
    @required this.slogan,
    @required this.supportTel,
    @required this.recommender,
    @required this.iosInvitationLink,
    @required this.androidInvitationLink,
    @required this.header,
  });

  factory InvitationModel.fromJson(Map<String, dynamic> json) {
    final supportTel = <String>[];
    final obj = json['supportTel'];

    if (obj != null) {
      if (obj is String) {
        final tmp = obj.split(',').map((e) => e.trim()).toList();
        supportTel.addAll(tmp);
      } else if (obj is Iterable) {
        final tmp = List<String>.from(obj).toList();
        supportTel.addAll(tmp);
      }
    }
    return InvitationModel(
      header: json['header'],
      slogan: json['slogan'],
      recommender: json['recommender'],
      iosInvitationLink: json['iosInvitationLink'],
      androidInvitationLink: json['androidInvitationLink'],
      supportTel: supportTel,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['header'] = header;
    data['slogan'] = slogan;
    data['iosInvitationLink'] = iosInvitationLink;
    data['recommender'] = recommender;
    data['androidInvitationLink'] = androidInvitationLink;
    data['supportTel'] = supportTel;

    return data;
  }

  final String header;
  final String slogan;
  final String recommender;
  final String iosInvitationLink;
  final String androidInvitationLink;
  final List<String> supportTel;
}
