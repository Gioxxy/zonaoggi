import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zonaoggi/home/HomeModel.dart';

class Day extends StatelessWidget {

  DayModel day;
  bool selected;
  Function onTap;

  Day({@required this.day, @required this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        width: 120,
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 6,
          color: selected ? Colors.white : Colors.grey[900],
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: (){
              onTap?.call();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(DateFormat("d MMM", "it_IT").format(day.date), style: TextStyle(color: selected ? Colors.black : Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),)
              ),
            ),
          )
        ),
      ),
    );
  }
}
