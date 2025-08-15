class ApiConstants {
  static const String baserUrl = "https://clean.deiyar.com/api/";
  static const String login = "login";
  static const String register = "driver/register";
  static const String sendOtp = "driver/verify-otp";
  static const String reverifyOtp = "driver/reverify-otp";
  static const String enterPhone = "driver/forgot-password";
  static const String resetPassword = "driver/reset-password";
  //static const String uploadImage = "driver/upload-image-before-register";
  static const String profileImage = "driver/upload/profile-image";
  static const String carImage = "driver/upload/car-image";
  static const String idCard = "driver/upload/id-card";
  static const String license = "driver/upload/license";
  static const String wallet = "driver/wallet";
  static const String walletTransactions = "driver/wallet/transactions";
  static const String walletWithdraw = "driver/wallet/withdraw";
  static const String walletDeposit = "driver/wallet/deposit";
  static const String getBookings = "driver/bookings";
  static const String confirmBooking = "driver/bookings/{id}/confirm";
  static const String rejectBooking = "driver/bookings/{id}/reject";
  static const String notifications = "/notifications";
  static const String markRead = "/notifications/mark-all-read";
  static const String unreadCount = "/notifications/unread-count";




  static  bool valid = false;
}

class ApiKey {
  static String id = "id";
  static String userData = "userData";
  static String name = "name";
  static String type = "type";
  static String phone = "phone";
  static String whatsPhone = "whatsPhone";
  static String authorization = "Authorization";
  static String status = "status";
  static String message = "message";
  static String data = "data";
  static String img = "img";
  static String password = "password";
  static String language = "language";
  static String imagePath = "imagePath";
  static String themeMode = "themeMode";
  static String fcm = "fcm";
  static String address = "address";
  static String email = "email";



}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}