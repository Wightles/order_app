import 'dart:io';

class ApiConfig {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5213';
    } else if (Platform.isIOS) {
      return 'http://localhost:5213';
    } else {
      return 'http://localhost:5213';
    }
  }
}