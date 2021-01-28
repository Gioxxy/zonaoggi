import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zonaoggi/home/widgets/Day.dart';
import 'package:zonaoggi/regionDetails/RegionDetailsPage.dart';
import 'package:zonaoggi/utils/ADManager.dart';
import 'package:zonaoggi/utils/AppColors.dart';

import 'HomeManager.dart';
import 'HomeModel.dart';
import 'widgets/Region.dart';

class HomePage extends StatefulWidget {

  HomeManager manager = HomeManager();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<void>> _req;
  int _selectedDayIndex;
  BannerAd _bannerAd;
  int pinnedRegionId;
  double _listOpacity = 1;

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          _bannerAd..show();
        }
      });
  }

  List<DayModel> _managePinnedRegion(List<DayModel> days, SharedPreferences sharedPreferences){
    pinnedRegionId = sharedPreferences.getInt('pinnedRegionId');
    if(pinnedRegionId != null) {
      for(DayModel day in days) {
        final RegionModel pinnedRegion = day.regions.removeAt(day.regions.indexWhere((region) => region.id == pinnedRegionId));
        day.regions.insert(0, pinnedRegion);
      }
    }
    return days;
  }

  _selectTodayDate(List<DayModel> days){
    if(_selectedDayIndex == null)
      _selectedDayIndex = days.indexWhere((day) => day.date.day == DateTime.now().day && day.date.month == DateTime.now().month && day.date.year == DateTime.now().year);
      if (_selectedDayIndex == -1) {
        _selectedDayIndex = 0;
      }
  }

  _onDayDidTap(int dayIndex){
    setState(() {
      _selectedDayIndex = dayIndex;
    });
  }

  _onRegionDidTap(RegionModel region){
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegionDetailPage(region)));
  }

  _onPinDidTap(RegionModel region, List<DayModel> days) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _listOpacity = 0;
    });

    _req = Future.wait([
      widget.manager.getDays(),
      SharedPreferences.getInstance(),
      Future.delayed(Duration(milliseconds: 300))
    ])
      ..then((value) {
        setState(() {
          if(region.id == pinnedRegionId){
            prefs.setInt('pinnedRegionId', null);
            pinnedRegionId = null;
          } else {
            prefs.setInt('pinnedRegionId', region.id);
            pinnedRegionId = region.id;
          }
          _listOpacity = 1;
        });
      });

  }

  @override
  Future<void> initState() {
    super.initState();
    _req = Future.wait([
      widget.manager.getDays(),
      SharedPreferences.getInstance()
    ]);

    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = buildBannerAd()..load();

  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        _req = Future.wait([
          widget.manager.getDays(),
          SharedPreferences.getInstance()
        ])
        ..then((value) { setState(() {}); });
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text("ZONAOGGI", style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w900),),
              ),

              Flexible(
                fit: FlexFit.tight,
                child: FutureBuilder<List<void>>(
                  future: _req,
                  builder: (context, snapshot) {
                    if(!snapshot.hasData || snapshot.data.length < 2)
                      return Center(child: CircularProgressIndicator());

                    List<DayModel> days = _managePinnedRegion(snapshot.data[0] as List<DayModel>, snapshot.data[1] as SharedPreferences);
                    _selectTodayDate(days);

                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        Container(
                          height: 70,
                          child: ListView.builder(
                            controller: ScrollController(initialScrollOffset: (130 * _selectedDayIndex).toDouble()),
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            itemCount: days.length,
                            itemBuilder: (context, index){
                              return Day(
                                day: days[index],
                                selected: _selectedDayIndex == index,
                                onTap: (){
                                  _onDayDidTap(index);
                                },
                              );
                            },
                          ),
                        ),

                        Flexible(
                          fit: FlexFit.loose,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 200),
                            opacity: _listOpacity,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.only(top: 20, bottom: 50, right: 10, left: 10),
                              itemCount: days[_selectedDayIndex].regions.length,
                              itemBuilder: (context, index){
                                return Region(
                                  region: days[_selectedDayIndex].regions[index],
                                  isPinned: pinnedRegionId == days[_selectedDayIndex].regions[index].id,
                                  onTap: (){
                                    _onRegionDidTap(days[_selectedDayIndex].regions[index]);
                                  },
                                  onTapPin: () {
                                    _onPinDidTap(days[_selectedDayIndex].regions[index], days);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
