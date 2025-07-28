import '../networking/constants/api_constants.dart';

class ErrorModel {
  final int status;
  final String message;
  final String? data;

  ErrorModel({required this.status, required this.message,this.data});
  factory ErrorModel.fromJson(Map jsonData) {
    return ErrorModel(
      message: jsonData[ApiKey.message],
      status: jsonData[ApiKey.status],
      data: jsonData[ApiKey.data],
    );
  }
}