import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xpath_parse/xpath_selector.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../HomeModel.dart';

class ItalyMap extends StatelessWidget {

  List<RegionModel> regions;

  ItalyMap({this.regions});

  Future<String> getMap() async {
    var path = XPath.source(await rootBundle.loadString("assets/images/map.svg"));
    for (RegionModel region in regions) {
      var el = path.query("//path[@title='${region.name.replaceFirst("'", "")}']").elements().first;
      el.attributes.addAll({"fill": "#"+region.color.value.toRadixString(16)});
      /*debugPrint("""
          @SvgPath('${el.attributes["d"]}')
          static Path get ${region.name} => _\$MapSvgData_${region.name};
          """);*/
    }
    return path.query("//svg").get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getMap(),
      builder: (context, snapshot){
        if(!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return Center(child: SvgPicture.string(snapshot.data.toString()));
      }
    );
  }
}
