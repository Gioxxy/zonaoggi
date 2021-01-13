import 'dart:convert';

import 'package:http/http.dart';

class Logger {
  static bool shouldLog = true;

  static void logResponse({String request, String body = "{}", Response response}){
    if(shouldLog)
      print("\n\nREQ: " + request + "\nBODY: " + body + "\nRES: [" + response.statusCode.toString() + "] " + utf8.decode(response.bodyBytes) + "\n\n");
  }

  static void log(String log){
    if(shouldLog)
      print("\n\n"+ log +"\n\n");
  }
}