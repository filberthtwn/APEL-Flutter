import 'package:flutter/cupertino.dart';

class DefaultResp {
  final int statusCode;
  final String message;
  Map<String, dynamic> data;

  DefaultResp({
    @required this.statusCode,
    @required this.message,
    @required this.data,
  });

  factory DefaultResp.fromJson(Map<String, dynamic> json) {
    return DefaultResp(
      statusCode: json['status_code'],
      message: json['status_message'],
      data: json['result'],
    );
  }
}
