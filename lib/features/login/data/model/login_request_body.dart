import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_request_body.g.dart';

@JsonSerializable()
class LoginRequestBody{
 final String? phone;
 final String? email;
 final String password;

 LoginRequestBody({ this.phone,required this.password,this.email});

 Map<String, dynamic> toJson() => _$LoginRequestBodyToJson(this);

}