import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../utils/Logger.dart';

class Response {
  int statusCode;
  dynamic body;

  Response(this.statusCode, this.body);
}

class Request {
  
  static  String _server = "https://www.trustmyads.com";

  static Future<Response> get({String route = "", Map<String, String> params, Function(Response) onResponse}) async {

    if(route[0] != "/"){
      route = "/" + route;
    }
    route += ".json";

    String req = _server + route;

    if(params != null && params.length > 0){
      String inlineParams = "";
      params.forEach((key, value) => inlineParams += "&" + key + "=" + value);

      req = req + "?" + inlineParams.substring(1);
    }

    Logger.log("SEND REQ " + req);
    final res = await http.get(Uri.encodeFull(req), headers: {'Content-Type': 'application/json'});
    Logger.logResponse(request: req, response: res);

    Response response = Response(res.statusCode, json.decode(utf8.decode(res.bodyBytes)));

    if(onResponse != null)
      onResponse(response);

    return response;
  }

  static Future<Response> getURL({String url = "", Map<String, String> params, Function(Response) onResponse}) async {

    if(params != null && params.length > 0){
      String inlineParams = "";
      params.forEach((key, value) => inlineParams += "&" + key + "=" + value);

      url = url + "?" + inlineParams.substring(1);
    }

    Logger.log("SEND REQ " + url + " headers:");
    final res = await http.get(Uri.encodeFull(url), headers: {'Content-Type': 'application/json'});
    Logger.logResponse(request: url, response: res);

    Response response = Response(res.statusCode, json.decode(utf8.decode(res.bodyBytes)));

    if(onResponse != null)
      onResponse(response);

    return response;
  }

  static Future<Response> post({String route = "", Map<String, String> params, Map<String, dynamic> body, Function(Response) onResponse}) async {

    Logger.log("BODY " + body.toString());

    if(route[0] != "/"){
      route = "/" + route;
    }
    route += ".json";

    String req = _server + route;

    if(params != null && params.length > 0){
      String inlineParams = "";
      params.forEach((key, value) => inlineParams += "&" + key + "=" + value);

      req = req + "?" + inlineParams.substring(1);
    }

    Logger.log("SEND REQ " + req);
    final res = await http.post(Uri.encodeFull(req), headers: {'Content-Type': 'application/json'}, body: json.encode(body));
    Logger.logResponse(request: req, body: json.encode(body), response: res);

    Response response = Response(res.statusCode, json.decode(utf8.decode(res.bodyBytes)));

    onResponse?.call(response);

    return response;
  }

  static Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }
}