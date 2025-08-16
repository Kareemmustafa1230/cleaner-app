import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  String? message;
  @JsonKey(name:'access_token')
  String? accessToken;
  int? status;
  Data? data;

  LoginResponse({this.message, this.accessToken, this.status, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>  _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}


@JsonSerializable()
class Data {
  int? id;
  String? name;
  String? phone;
  String? email;
  @JsonKey(name:'national_id')
  String? nationalId;
  String? address;
  @JsonKey(name:'hire_date')
  String? hireDate;
  String? status;
  String? image;

  Data(
      {this.id,
        this.name,
        this.phone,
        this.email,
        this.nationalId,
        this.address,
        this.hireDate,
        this.status,
        this.image});

     factory Data.fromJson(Map<String, dynamic> json) =>  _$DataFromJson(json);
      Map<String, dynamic> toJson() => _$DataToJson(this);
}