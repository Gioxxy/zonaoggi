import 'dart:async';

import 'package:zonaoggi/home/HomeModel.dart';
import 'package:zonaoggi/regionDetails/RestrictionsModel.dart';
import 'package:zonaoggi/utils/Request.dart';
import 'package:zonaoggi/utils/ResponseError.dart';

class RegionDetailManager {
  Future<RegionDetailModel> getRestrictions({Function(RegionDetailModel) onSuccess, Function(ResponseError) onError}){
    Completer completer = Completer<RegionDetailModel>();

    Request.get(
        route: "/restrictions",
        onResponse: (response) {
          if(response.statusCode == 200){
            RegionDetailModel model = RegionDetailModel.fromJson(response.body);
            onSuccess?.call(model);
            completer.complete(model);
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