// To parse this JSON data, do
//
//     final TokenModel = TokenModelFromJson(jsonString);

import 'dart:convert';

TokenModel TokenModelFromJson(String str) => TokenModel.fromJson(json.decode(str));

String TokenModelToJson(TokenModel data) => json.encode(data.toJson());

class TokenModel {
  TokenModel({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
  });

  String? accessToken;
  String? tokenType;
  int? expiresIn;

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "token_type": tokenType,
    "expires_in": expiresIn,
  };
}
