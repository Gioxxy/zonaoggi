import 'dart:async';

import 'package:zonaoggi/home/HomeModel.dart';
import 'package:zonaoggi/utils/Request.dart';
import 'package:zonaoggi/utils/ResponseError.dart';

class HomeManager {
  Future<List<Day>> getDays({Function(List<Day>) onSuccess, Function(ResponseError) onError}){
    Completer completer = Completer<List<Day>>();

    Request.get(
      route: "zone",
      onResponse: (response) {
        if(response.statusCode == 200){
          List<Day> days = (response.body as List ?? List()).map((e) => Day.fromJson(e)).toList();
          onSuccess?.call(days);
          completer.complete(days);
        } else {
          ResponseError error = ResponseError.serviceConstructor(
              ResponseErrorType.sys, "Errore", "Errore richiesta");
          onError?.call(error);
          completer.completeError(error);
        }
      }
    );

    return completer.future;
  }
}