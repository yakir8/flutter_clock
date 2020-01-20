import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'package:intl/intl.dart';
import 'package:digital_clock/daily_info.dart';
import 'package:digital_clock/blink_colon.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:digital_clock/handler/clock_style.dart';
import 'package:kosher_dart/hebrewcalendar/jewish_date.dart';
import 'package:digital_clock/handler/app_localizations.dart';
import 'package:kosher_dart/hebrewcalendar/hebrew_date_formatter.dart';

/// This Widget display date, time and daily info.

class Time extends StatefulWidget {
  final ClockModel model;

  Time(this.model);

  @override
  State createState() => _TimeState();
}

class _TimeState extends State<Time> {
  final String dateFormat = ui.window.locale.languageCode == 'he' ? "dd MMMM, yyy" : "dd MMMM, yyy";

  Widget _buildTime() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        Text(_isHebrewFormat() ? _getMinute() : _getHour(),
            style: ClockStyle.getClockTextStyle(70, context)),
        BlinkColon(),
        Text(_isHebrewFormat() ? _getHour() : _getMinute(),
            style: ClockStyle.getClockTextStyle(70, context)),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }

  // Display Gregorian & Jewish Date
  Widget _buildDate() {
    final double textSize = 10;
    HebrewDateFormatter hebrewDateFormatter = HebrewDateFormatter();
    JewishDate jewishDate = JewishDate();
    hebrewDateFormatter.setHebrewFormat(_isHebrewFormat());
    hebrewDateFormatter.setUseGershGershayim(true);
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        Text(
          _getTranslate('day_prefx') +
              DateFormat("EEE", ui.window.locale.languageCode).format(DateTime.now()),
          style: ClockStyle.getContentTextStyle(textSize, context),
        ),
        SizedBox(width: 5),
        Column(
          children: <Widget>[
            Text(DateFormat(dateFormat, ui.window.locale.languageCode).format(DateTime.now()),
                style: ClockStyle.getContentTextStyle(textSize, context)),
            Row(
              children: <Widget>[
                Text(
                  hebrewDateFormatter.format(jewishDate),
                  style: ClockStyle.getContentTextStyle(textSize, context),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }

  // Get hour string in 24h or 12h format
  String _getHour() {
    return DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(DateTime.now());
  }

  // Get minute string
  String _getMinute() {
    return DateFormat('mm').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 220,
        height: 165,
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xff23ADCC), width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: ClockStyle.isLightMod
                ? Color.fromRGBO(128, 128, 128, 0.3)
                : Color.fromRGBO(0, 0, 0, 0.7)),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            _buildDate(),
            _buildTime(),
            DailyInfo(widget.model)
          ],
        ),
      ),
    );
  }

  bool _isHebrewFormat() => ui.window.locale.languageCode == 'he';

  String _getTranslate(String str) {
    return AppLocalizations.of(context).translate(str);
  }
}
