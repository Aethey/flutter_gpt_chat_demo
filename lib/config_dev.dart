class AppConfig {
  // api
  static const String baseUrl = 'https://api.example.com';
  static const int receiveTimeout = 15; // seconds
  static const int connectTimeout = 30; // seconds
  // db
  static const String hiveBaseBoxName = 'chat_box';
//   route
  static String root = "/";
  static String pageToRedirectTo = "/pageToRedirectTo";
//   model
  static String commonModel = "gpt-4o-mini";
  static String highModel = "gpt-4o-mini";
  static int schemaVersion = 1;
}
