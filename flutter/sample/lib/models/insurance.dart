import 'dart:convert';

import 'package:novinpay/repository/response.dart';

class CreateOrderResponse extends ResponseBase {
  CreateOrderResponse({
    @required this.orderId,
    @required this.paymentToken,
    @required this.totalPrice,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  CreateOrderResponse.fromJson(Map<String, dynamic> json)
      : this(
          orderId: json['orderId'],
          paymentToken: json['paymentToken'],
          totalPrice: json['totalPrice'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['orderId'] = orderId;
    data['paymentToken'] = paymentToken;
    data['totalPrice'] = totalPrice;

    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  final int orderId;
  final String paymentToken;
  final int totalPrice;
}

class InsurancePaymentResponse extends ResponseBase {
  InsurancePaymentResponse({
    @required this.rrn,
    @required this.stan,
    @required this.traceNumber,
    @required this.order,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  InsurancePaymentResponse.fromJson(Map<String, dynamic> json)
      : this(
          rrn: json['rrn'],
          stan: json['stan'],
          traceNumber: json['traceNumber'],
          order: json['order'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['rrn'] = rrn;
    data['stan'] = stan;
    data['traceNumber'] = traceNumber;
    data['order'] = order;
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  final String rrn;
  final String stan;
  final String traceNumber;
  final int order;
}

class PlanAgeResponse extends ResponseBase {
  PlanAgeResponse({
    @required this.plans,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory PlanAgeResponse.fromJson(Map<String, dynamic> json) {
    final plans = <PlanItem>[];
    if (json['planList'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['planList'])
          .map((e) => PlanItem.fromJson(e))
          .toList();
      plans.addAll(tmp);
    }

    return PlanAgeResponse(
        plans: plans,
        status: json['status'],
        mobileNumber: json['mobileNumber'],
        description: json['description'],
        errorMessage: json['errorMessage']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['planList'] = plans.map((v) => v.toJson()).toList();
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  final List<PlanItem> plans;
}

class PlanItem {
  PlanItem({
    @required this.id,
    @required this.name,
    @required this.company,
    @required this.type,
    @required this.benefits,
    @required this.parameters,
  });

  factory PlanItem.fromJson(Map<String, dynamic> json) {
    final benefits = <Benefits>[];
    if (json['benefits'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['benefits'])
          .map((e) => Benefits.fromJson(e))
          .toList();
      benefits.addAll(tmp);
    }
    final parameters = <Parameters>[];
    if (json['parameters'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['parameters'])
          .map((e) => Parameters.fromJson(e))
          .toList();
      parameters.addAll(tmp);
    }

    return PlanItem(
      benefits: benefits,
      parameters: parameters,
      id: json['id'],
      name: json['name'],
      company: Company.fromJson(json['company']),
      type: Type.fromJson(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['name'] = name;
    data['company'] = company.toJson();
    data['type'] = type.toJson();
    data['benefits'] = benefits.map((v) => v.toJson()).toList();
    data['parameters'] = parameters.map((v) => v.toJson()).toList();

    return data;
  }

  final int id;
  final String name;
  final Company company;
  final Type type;
  final List<Benefits> benefits;
  final List<Parameters> parameters;
}

class Company {
  Company({@required this.id, @required this.name});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  final int id;
  final String name;
}

class Type {
  Type({
    @required this.id,
    @required this.name,
    @required this.description,
  });

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    return data;
  }

  final int id;
  final String name;
  final String description;
}

class Benefits {
  Benefits({
    @required this.benefit,
    @required this.value,
    @required this.comments,
  });

  factory Benefits.fromJson(Map<String, dynamic> json) {
    return Benefits(
      benefit: json['benefit'],
      value: json['value'],
      comments: json['comments'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['benefit'] = benefit;
    data['value'] = value;
    data['comments'] = comments;
    return data;
  }

  final String benefit;
  final String value;
  final String comments;
}

class Parameters {
  Parameters({
    @required this.orderingId,
    @required this.name,
    @required this.valueFrom,
    @required this.valueTo,
    @required this.price,
  });

  factory Parameters.fromJson(Map<String, dynamic> json) {
    return Parameters(
      orderingId: json['orderingId'],
      name: json['name'],
      valueFrom: json['valueFrom'],
      valueTo: json['valueTo'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['orderingId'] = orderingId;
    data['name'] = name;
    data['valueFrom'] = valueFrom;
    data['valueTo'] = valueTo;
    data['price'] = price;
    return data;
  }

  final int orderingId;
  final String name;
  final String valueFrom;
  final String valueTo;
  final int price;
}

class PlanDetailResponse extends ResponseBase {
  PlanDetailResponse({
    @required this.planDetailModel,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory PlanDetailResponse.fromJson(Map<String, dynamic> json) {
    return PlanDetailResponse(
      planDetailModel: json['planDetailModel'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
      status: json['status'],
    );
  }

  final PlanDetailModel planDetailModel;
}

class PlanDetailModel {
  PlanDetailModel({
    @required this.id,
    @required this.name,
    @required this.company,
    @required this.type,
    @required this.benefits,
    @required this.parameters,
  });

  factory PlanDetailModel.fromJson(Map<String, dynamic> json) {
    final benefits = <Benefits>[];
    if (json['benefits'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['benefits'])
          .map((e) => Benefits.fromJson(e))
          .toList();
      benefits.addAll(tmp);
    }
    final parameters = <Parameters>[];
    if (json['parameters'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['parameters'])
          .map((e) => Parameters.fromJson(e))
          .toList();
      parameters.addAll(tmp);
    }

    return PlanDetailModel(
      benefits: benefits,
      parameters: parameters,
      id: json['id'],
      name: json['name'],
      company: Company.fromJson(json['company']),
      type: Type.fromJson(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['company'] = company.toJson();
    data['type'] = type.toJson();
    data['benefits'] = benefits.map((v) => v.toJson()).toList();
    data['parameters'] = parameters.map((v) => v.toJson()).toList();

    return data;
  }

  final int id;
  final String name;
  final Company company;
  final Type type;
  final List<Benefits> benefits;
  final List<Parameters> parameters;
}
