import 'dart:async';

import 'package:zonaoggi/home/HomeModel.dart';
import 'package:zonaoggi/utils/Request.dart';
import 'package:zonaoggi/utils/ResponseError.dart';

class HomeManager {
  Future<List<DayModel>> getDays({Function(List<DayModel>) onSuccess, Function(ResponseError) onError}){
    Completer completer = Completer<List<DayModel>>();

    Request.get(
      route: "/zone",
      onResponse: (response) {
        if(response.statusCode == 200){
          List<DayModel> days = (response.body as List ?? []).map((e) => DayModel.fromJson(e)).toList();
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