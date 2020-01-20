// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/handler/app_localizations.dart';
import 'package:digital_clock/handler/clock_style.dart';
import 'package:digital_clock/weather.dart';
import 'package:digital_clock/weather_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:digital_clock/time.dart';
import 'package:digital_clock/wallpaper.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class HebrewClock extends StatefulWidget {
  const HebrewClock(this.model);

  final ClockModel model;

  @override
  _HebrewClockState createState() => _HebrewClockState();
}

class _HebrewClockState extends State<HebrewClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    //initialization to legal location format
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HebrewClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ClockStyle.isLightMod = Theme.of(context).brightness == Brightness.light;
    return MaterialApp(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('he', 'IL'),
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Wallpaper(),
            WeatherAnimation(widget.model),
            Time(widget.model),
            Weather(widget.model),
          ],
        ),
      ),
    );
  }
}
