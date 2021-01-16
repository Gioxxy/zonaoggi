import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zonaoggi/home/HomeModel.dart';

class RegionWidget extends StatelessWidget {

  Region region;
  bool isPinned;
  Function onTapPin;

  RegionWidget({Key key, @required this.region, this.isPinned = false, this.onTapPin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 150,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [

            Padding(
              padding: const EdgeInsets.only(left: 30, right: 10),
              child: Material(
                color: region.color,
                borderRadius: BorderRadius.circular(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 80, right: 10, top: 10, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(region.name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),),
                            Text("ZONA " + region.zoneName.toUpperCase(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),)
                          ],
                        ),
                      ),

                      IconButton(
                        icon: Icon(isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined, color: Colors.black,),
                        onPressed: (){
                          onTapPin?.call();
                        }
                      ),

                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 2, top: 2),
                    child: SvgPicture.asset("assets/images/" + region.image, width: 85, fit: BoxFit.contain, color: Colors.black45,),
                  ),
                  SvgPicture.asset("assets/images/" + region.image, width: 85, fit: BoxFit.contain, color: Colors.white,),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
