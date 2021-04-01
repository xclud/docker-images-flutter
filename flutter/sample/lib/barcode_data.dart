class BarcodeData {
  BarcodeData(this.format, this.code);

  BarcodeData.fromJson(Map<String, dynamic> json)
      : this(json['format'], json['code']);
  final String format;
  final String code;

  @override
  String toString() {
    return '{"format": "$format", "code": "$code"}';
  }
}
