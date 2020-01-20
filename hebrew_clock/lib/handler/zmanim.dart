import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'package:intl/intl.dart';
import 'package:kosher_dart/complex_zmanim_calendar.dart';
import 'package:digital_clock/handler/app_localizations.dart';
import 'package:kosher_dart/hebrewcalendar/jewish_calendar.dart';
import 'package:kosher_dart/hebrewcalendar/hebrew_date_formatter.dart';
import 'package:kosher_dart/util/geo_Location.dart';

class Zmanim {
  final double latitude;
  final double longitude;
  final String location;
  final JewishCalendar jewishCalendar;
  HebrewDateFormatter hebrewDateFormatter;
  ComplexZmanimCalendar complexZmanimCalendar;

  Zmanim(this.jewishCalendar,
      {@required this.longitude, @required this.latitude, @required this.location}) {
    hebrewDateFormatter = HebrewDateFormatter();
    hebrewDateFormatter.setHebrewFormat(_isHebrewFormat());
    hebrewDateFormatter.setUseGershGershayim(true);
    hebrewDateFormatter.setUseLongHebrewYears(false);
    hebrewDateFormatter.setLongWeekFormat(true);
    GeoLocation geoLocation =
        GeoLocation.setLocation("My Location", latitude, longitude, DateTime.now());
    complexZmanimCalendar = ComplexZmanimCalendar.intGeoLocation(geoLocation);
    complexZmanimCalendar.setCalendar(DateTime.now());
  }

  String shabbatEnd() {
    DateTime calendar = DateTime.parse(DateTime.now().toIso8601String());
    GeoLocation geoLocation =
        GeoLocation.setLocation("Jerusalem", latitude, longitude, calendar, 0.0);
    ComplexZmanimCalendar complexZmanimCalendar = ComplexZmanimCalendar.intGeoLocation(geoLocation);
    while (calendar.weekday != DateTime.friday) {
      calendar = calendar.add(Duration(days: 1));
    }
    complexZmanimCalendar.setCalendar(calendar);
    DateTime shabbatTime =
        complexZmanimCalendar.getBainHasmashosRT13Point5MinutesBefore7Point083Degrees();
    shabbatTime = shabbatTime.add(Duration(minutes: 22));
    return _dateTimeToString(shabbatTime);
  }

  String shabbatStart() {
    DateTime calendar = DateTime.parse(DateTime.now().toIso8601String());
    GeoLocation geoLocation =
        GeoLocation.setLocation("Jerusalem", latitude, longitude, calendar, 0.0);
    ComplexZmanimCalendar complexZmanimCalendar = ComplexZmanimCalendar.intGeoLocation(geoLocation);
    while (calendar.weekday != DateTime.friday) {
      calendar = calendar.add(Duration(days: 1));
    }
    complexZmanimCalendar.setCalendar(calendar);
    DateTime shabbatTime = complexZmanimCalendar.getSunset();
    return _dateTimeToString(shabbatTime);
  }

  String getWeeklyParsha() {
    JewishCalendar jewishCalendar = JewishCalendar();
    DateTime c = DateTime.parse(DateTime.now().toIso8601String());
    jewishCalendar.setInIsrael(location.toString().toLowerCase().contains('israel'));
    for (int i = 0; i <= 7; i++) {
      if (jewishCalendar.getParshaIndex() != -1 && i != 0) {
        return hebrewDateFormatter.formatParsha(jewishCalendar);
      }
      c = c.add(Duration(days: 1));
      jewishCalendar.setDate(c);
    }
    return '';
  }

  String omerDay() => hebrewDateFormatter.formatOmer(jewishCalendar);

  String getDafYomi() {
    if (_isHebrewFormat())
      return hebrewDateFormatter.formatDafYomiBavli(jewishCalendar.getDafYomiBavli());
    return "${jewishCalendar.getDafYomiBavli().getMasechtaTransliterated()} - ${jewishCalendar.getDafYomiBavli().getDaf()}";
  }

  String getAlotHashachar() => _changeTime(complexZmanimCalendar.getAlos72(), 1);

  String getTallithTime() => _changeTime(complexZmanimCalendar.getMisheyakir10Point2Degrees(), 3);

  String getSofZmanShmaMGA() => _changeTime(complexZmanimCalendar.getSofZmanShmaMGA(), 0);

  String getSofZmanTfilaMGA() => _changeTime(complexZmanimCalendar.getSofZmanTfilaMGA(), 0);

  String getSunrise() => (_changeTime(complexZmanimCalendar.getSunrise(), 0));

  String getSofZmanShmaGRA() => _changeTime(complexZmanimCalendar.getSofZmanShmaGRA(), 0);

  String getSofZmanTfilaGRA() => _changeTime(complexZmanimCalendar.getSofZmanTfilaGRA(), 0);

  String midnight(bool isNight) =>
      _changeTime(complexZmanimCalendar.getFixedLocalChatzos(), isNight ? 718 : -2);

  String getPlagHamincha() => _changeTime(complexZmanimCalendar.getPlagHamincha(), -1);

  String getSunset() => _changeTime(complexZmanimCalendar.getSunset(), 0);

  String getThreeStar() => _changeTime(
      complexZmanimCalendar.getBainHasmashosRT13Point5MinutesBefore7Point083Degrees(), 1);

  String _dateTimeToString(DateTime dateTime) => DateFormat('HH:mm').format(dateTime);

  String _changeTime(DateTime time, int minute) {
    time = time.add(Duration(minutes: minute));
    return DateFormat('HH:mm').format(time);
  }

  bool _isHebrewFormat() {
    String languageCode = ui.window.locale.languageCode;
    bool isSupported = AppLocalizations.supportedLanguage.contains(languageCode);
    if (isSupported) return ui.window.locale.languageCode == 'he';
    return true;
  }
}
