import 'package:flutter/material.dart';
import 'package:zonaoggi/home/HomePage.dart';
import 'package:zonaoggi/utils/AppColors.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('it_IT', null).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZONAOGGI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppColors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "Montserrat"
      ),
      home: HomePage(),
    );
  }
}
