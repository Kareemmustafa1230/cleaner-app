class ApiConstants {
  static const String baserUrl = "https://clean.deiyar.com/api/";
  static const String login = "login";
  static const String logout = "logout";
  static const String apartmentSearch = "chalets";
  static const String updatePassword = "password";
  static const String updateProfile = "profile";
  static const String inventory = "inventory";
  static const String chaletsInfo = "chalets/info";
  static const String uploadCleaning = "cleaning/upload";
  static const String uploadDamage = "damages/upload";



  //static const String uploadImage = "driver/upload-image-before-register";
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