// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequestBody _$LoginRequestBodyFromJson(Map<String, dynamic> json) =>
    LoginRequestBody(
      phone: json['phone'] as String?,
      password: json['password'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$LoginRequestBodyToJson(LoginRequestBody instance) =>
    <String, dynamic>{
      if (instance.phone case final value?) 'phone': value,
      if (instance.email case final value?) 'email': value,
      'password': instance.password,
    };
