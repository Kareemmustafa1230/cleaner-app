import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_request_body.g.dart';

@JsonSerializable()
class LoginRequestBody{
 final String? phone;
 final String? email;
 final String password;

 LoginRequestBody({ this.phone,required this.password,this.email});

 Map<String, dynamic> toJson() {
   final Map<String, dynamic> data = <String, dynamic>{
     'password': password,
   };
   
   // إضافة phone فقط إذا كان موجوداً
   if (phone != null && phone!.isNotEmpty) {
     data['phone'] = phone;
   }
   
   // إضافة email فقط إذا كان موجوداً
   if (email != null && email!.isNotEmpty) {
     data['email'] = email;
   }
   
   return data;
 }
}