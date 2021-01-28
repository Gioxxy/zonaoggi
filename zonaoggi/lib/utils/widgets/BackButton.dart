import 'package:flutter/material.dart';

class ZOBackButton extends StatelessWidget {

  Function onTap;

  ZOBackButton({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: MaterialButton(
          onPressed: onTap,
          shape: CircleBorder(),
          color: Colors.white,
          padding: EdgeInsets.all(10),
          elevation: 10,
          child: Icon(Icons.arrow_back_rounded, color: Colors.black,),
        ),
      ),
    );
  }
}