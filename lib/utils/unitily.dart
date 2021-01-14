import 'dart:io';

/// This is a utility class for application
class Util {
  /// This method checks the internet connection and returns a bool value
  ///
  /// Returns true if internet connection is present.
  static Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }
}
