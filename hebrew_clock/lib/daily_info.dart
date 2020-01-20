import 'package:flutter/material.dart';

import 'dart:async';

import 'package:digital_clock/handler/zmanim.dart';
import 'package:digital_clock/handler/clock_style.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:kosher_dart/hebrewcalendar/jewish_calendar.dart';
import 'package:digital_clock/handler/app_localizations.dart';

class DailyInfo extends StatefulWidget {
  final ClockModel clockModel;

  DailyInfo(this.clockModel); //  final double latitude;

//  final double longitude;
//  final String location;

//  DailyInfo({this.latitude = 31.771959, this.longitude = 35.217018, this.location});

  @override
  State createState() => _DailyInfoState();
}

class _DailyInfoState extends State<DailyInfo> {

  //interval (in sec) between switch three line of information
  final int switchInterval = 10;

  Timer infoTimer;
  Timer updateTimer;

  double latitude = 31.771959;
  double longitude = 35.217018;
  String location = 'Tel-Aviv Israel';

  int _firstIndex = 0;
  int _secondIndex = 1;
  int _thirdIndex = 2;

  JewishCalendar jewishCalendar;
  List<Widget> _listInfo = List();
  List<GlobalKey> _listKey = List();

  Zmanim _zmanim;

  @override
  void initState() {
    _locationDecoder();
    jewishCalendar = JewishCalendar();
    jewishCalendar.setInIsrael(location.toString().toLowerCase().contains('israel'));
    _zmanim = Zmanim(jewishCalendar, longitude: longitude, latitude: latitude, location: location);
    DateTime now = DateTime.now();
    Future.delayed(Duration.zero, () => _buildListInfo());
    infoTimer = Timer(Duration(seconds: switchInterval), _switchInfo);
    Duration newDay = Duration(days: 1) -
        Duration(hours: now.hour) -
        Duration(minutes: now.minute) -
        Duration(seconds: now.second);
    updateTimer = Timer(newDay, _updateInfo);
    super.initState();
  }

  @override
  void dispose() {
    infoTimer?.cancel();
    updateTimer?.cancel();
    super.dispose();
  }

  //convert location string from ClockModel to latitude, longitude and location name
  void _locationDecoder() {
    double _latitude;
    double _longitude;
    String _location;
    try {
      List<String> split = widget.clockModel.location.toString().split(',');
      _latitude = double.parse(split[0]);
      _longitude = double.parse(split[1]);
      _location = split[2];
      latitude = _latitude;
      longitude = _longitude;
      location = _location;
    } catch (e) {
      print('Location Format Error: correct is: Latitude,Longitude,Country');
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildListInfo();
    return _listInfo.isNotEmpty
        ? AnimatedSwitcher(
            duration: Duration(milliseconds: 150),
            child: Column(
              key: _listKey[(_thirdIndex / 3).round()],
              children: <Widget>[
                _listInfo[_firstIndex],
                _listInfo[_secondIndex],
                _listInfo[_thirdIndex],
              ],
            ),
          )
        : Container();
  }

  void _buildListInfo() {
    _listInfo.clear();
    _listKey.clear();
    _locationDecoder();
    _zmanim = Zmanim(jewishCalendar, longitude: longitude, latitude: latitude, location: location);
    _listInfo.add(_buildRowInfo(_getTranslate('weekly_parsha'), _zmanim.getWeeklyParsha(), 0));
    _listInfo.add(_buildRowInfo(_getTranslate('shabbat_beginning'), _zmanim.shabbatStart(), 1));
    _listInfo.add(_buildRowInfo(_getTranslate('shabbat_end'), _zmanim.shabbatEnd(), 2));
    if (_zmanim.omerDay() != '')
      _listInfo.add(_buildRowInfo(_getTranslate('omer_day'), _zmanim.omerDay(), 16));
    _listInfo.add(_buildRowInfo(_getTranslate('daf_yomi'), _zmanim.getDafYomi(), 3));
    _listInfo.add(_buildRowInfo(_getTranslate('alot_hashachar'), _zmanim.getAlotHashachar(), 4));
    _listInfo.add(_buildRowInfo(_getTranslate('tallith_time'), _zmanim.getTallithTime(), 5));
    _listInfo.add(_buildRowInfo(_getTranslate('sunrise'), _zmanim.getSunrise(), 6));
    _listInfo
        .add(_buildRowInfo(_getTranslate('sof_zman_shma_mga'), _zmanim.getSofZmanShmaMGA(), 7));
    _listInfo
        .add(_buildRowInfo(_getTranslate('sof_zman_shma_gra'), _zmanim.getSofZmanShmaGRA(), 8));
    _listInfo
        .add(_buildRowInfo(_getTranslate('sof_zman_tfila_mga'), _zmanim.getSofZmanTfilaMGA(), 9));
    _listInfo.add(
        _buildRowInfo(_getTranslate('get_sofzman_tfila_gra'), _zmanim.getSofZmanTfilaGRA(), 10));
    _listInfo.add(_buildRowInfo(_getTranslate('midday'), _zmanim.midnight(false), 11));
    _listInfo.add(_buildRowInfo(_getTranslate('plag_mamincha'), _zmanim.getPlagHamincha(), 12));
    _listInfo.add(_buildRowInfo(_getTranslate('sunset'), _zmanim.getSunset(), 13));
    _listInfo.add(_buildRowInfo(_getTranslate('threeStar'), _zmanim.getThreeStar(), 14));
    _listInfo.add(_buildRowInfo(_getTranslate('midnight'), _zmanim.midnight(true), 15));
    if (_listInfo.length % 3 != 0) _listInfo.add(Container());
    if (_listInfo.length % 3 != 0) _listInfo.add(Container());
    if (_listInfo.length % 3 != 0) _listInfo.add(Container());
    for (int i = 0; i <= _listInfo.length / 3; i++) _listKey.add(GlobalKey());
  }

  //create row for info
  Widget _buildRowInfo(String title, String info, int index) {
    final double textSize = 10;
    return DefaultTextStyle(
      style: ClockStyle.getContentTextStyle(textSize, context),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 6,
          ),
          Expanded(
            child: Text(
              title,
              softWrap: true,
            ),
          ),
          Text(info),
          SizedBox(
            width: 6,
          ),
        ],
      ),
    );
  }

  //Refreshing three lines of information
  void _switchInfo() {
    infoTimer = Timer(Duration(seconds: switchInterval), _switchInfo);
    setState(() {
      _firstIndex = _firstIndex + 3 < _listInfo.length ? _firstIndex + 3 : 0;
      _secondIndex = _firstIndex + 1 < _listInfo.length ? _firstIndex + 1 : 0;
      _thirdIndex = _secondIndex + 1 < _listInfo.length ? _secondIndex + 1 : 0;
    });
  }

  //Get test from json file for the correct language (Hebrew or English)
  String _getTranslate(String str) {
    return AppLocalizations.of(context).translate(str);
  }

  //update one time every new day
  void _updateInfo() {
    setState(() {
      jewishCalendar.setDate(DateTime.now());
      _buildListInfo();
      updateTimer = Timer(Duration(days: 1), _updateInfo);
    });
  }
}
