import 'package:flutter/material.dart';

import 'AppColors.dart';
import 'ResponseError.dart';


class MessageAlert{
  static show(BuildContext context, {@required String title, @required String message, String confirmActionTitle, String cancelActionTitle, Function onDidTapConfirm, Function onDidTapCancel}){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          content: Text(message, style: TextStyle(color: Colors.white),),
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
          actionsPadding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
          titlePadding: EdgeInsets.only(top: 40, left: 25, right: 25),
          actions: <Widget>[
            cancelActionTitle == null ? Container():
            FlatButton(
              textColor: Colors.white,
              onPressed: (){
                Navigator.of(context, rootNavigator: true).pop('dialog');
                onDidTapCancel?.call();
              },
              child: Text(cancelActionTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
            ),
            SizedBox(width: 10,),
            FlatButton(
              textColor: Colors.greenAccent,
              onPressed: (){
                Navigator.of(context, rootNavigator: true).pop('dialog');
                onDidTapConfirm?.call();
              },
              child: Text(confirmActionTitle ?? "Ok", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
            ),
          ],
        );
      }
    );
  }
}

extension ErrorAlert on MessageAlert {

  static show(BuildContext context, {@required ResponseError error, Function onDidTapConfirm}){
    MessageAlert.show(context, title: error.message, message: error.description, onDidTapConfirm: onDidTapConfirm);
  }
}