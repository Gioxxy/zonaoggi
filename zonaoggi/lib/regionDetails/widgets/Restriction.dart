import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zonaoggi/regionDetails/RestrictionsModel.dart';
import 'package:zonaoggi/utils/FontAwesomeIconsHelper.dart';

class Restriction extends StatelessWidget {

  RestrictionModel model;
  Color iconColor;

  Restriction(this.model, {this.iconColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 25,
              child: Center(child: FaIcon(FontAwesomeIconsHelper.fromName(model.icon), color: iconColor,))
          ),
          SizedBox(width: 20,),
          Flexible(child: Text(model.desc, style: TextStyle(color: Colors.white, fontSize: 18),)),
        ],
      ),
    );
  }
}
