import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zonaoggi/home/HomeModel.dart';
import 'package:zonaoggi/regionDetails/RegionDetailsManager.dart';
import 'package:zonaoggi/regionDetails/RestrictionsModel.dart';
import 'package:zonaoggi/utils/AppColors.dart';
import 'package:zonaoggi/utils/widgets/BackButton.dart';

import 'widgets/Restriction.dart';

class RegionDetailPage extends StatefulWidget {

  RegionModel region;
  RegionDetailManager manager = RegionDetailManager();

  RegionDetailPage(this.region);

  @override
  _RegionDetailPageState createState() => _RegionDetailPageState();
}

class _RegionDetailPageState extends State<RegionDetailPage> {

  Future<RegionDetailModel> _req;

  _onBackButtonDidTap(){
    Navigator.pop(context);
  }

  _onSelfDeclarationDidTap(String link) async {
    await launch(link);
  }

  @override
  void initState() {
    super.initState();
    _req = widget.manager.getRestrictions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20, left: 80, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.region.name, style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w900),),
                          Text("ZONA " + widget.region.zoneName.toUpperCase(), style: TextStyle(fontSize: 25, color: widget.region.color, fontWeight: FontWeight.w600),)
                        ],
                      ),
                    ),
                  ),

                  FutureBuilder<RegionDetailModel>(
                    future: _req,
                    builder: (context, snapshot){
                      if(!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());

                      RegionDetailModel model = snapshot.data;
                      List<RestrictionModel> restrictions = model.restrictions.firstWhere((e) => e.zoneName == widget.region.zoneName).restrictions;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: RaisedButton.icon(
                              label: Text("AUTODICHIARAZIONE", style: TextStyle(fontWeight: FontWeight.bold),),
                              icon: Icon(Icons.download_rounded),
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              onPressed: (){
                                _onSelfDeclarationDidTap(model.selfDeclaration);
                              },
                            ),
                          ),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(top: 20, bottom: 100),
                            itemCount: restrictions.length,
                            itemBuilder: (context, index){
                              return Restriction(restrictions[index], iconColor: widget.region.color,);
                            },
                          ),
                        ],
                      );
                    },
                  )


                ],
              ),
            ),


            ZOBackButton(
              onTap: (){
                _onBackButtonDidTap();
              }
            )
          ],
        ),
      ),
    );
  }
}
