import 'package:flutter/material.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import 'package:zonaoggi/utils/ItalyMapData.dart';

class ItalyMap extends StatefulWidget {
  ItalyMap({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ItalyMapState createState() => _ItalyMapState();
}

class _ItalyMapState extends State<ItalyMap> {
  Map<String, String> _pressedProvince;

  @override
  Widget build(BuildContext context) {
    /// Calculate the center point of the SVG map,
    /// use parent widget for width/heigth.
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double navBarHeight = Theme.of(context).platform == TargetPlatform.android ? 56.0 : 44.0;
    double safeZoneHeight = MediaQuery.of(context).padding.bottom;

    double scaleFactor = 0.5;

    double x = (width / 2.0) - (1075.0706 / 2.0);
    double y = (height / 2.0) - (1396.1437 / 2.0);
    Offset offset = Offset(x, y);

    return Transform.scale(
      scale: 0.2,
      child: Stack(children: _buildMap()));
  }

  List<Widget> _buildMap() {
    return ItalyMapData.map((region) => _buildProvince(region)).toList();
  }

  Widget _buildProvince(Map<String, String> region) {
    return ClipPath(
        child: Stack(children: <Widget>[
          CustomPaint(painter: PathPainter(region)),
          Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () => _provincePressed(region),
                  child: Container(
                      color: Colors.red)))
        ]),
        clipper: PathClipper(region));
  }

  void _provincePressed(Map<String, String> province) {
    setState(() {
      _pressedProvince = province;
    });
  }
}

class PathPainter extends CustomPainter {
  final Map<String, String> _region;
  PathPainter(this._region);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = parseSvgPath(_region["path"]);
    canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.black
          ..strokeWidth = 2.0);
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(PathPainter oldDelegate) => false;
}

class PathClipper extends CustomClipper<Path> {
  final Map<String, String> _region;
  PathClipper(this._region);

  @override
  Path getClip(Size size) {
    return parseSvgPath(_region["path"]);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}