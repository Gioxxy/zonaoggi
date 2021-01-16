import 'dart:io';

class AdManager {

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7514303138983564~2203256236";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7514303138983564/4563301041";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}