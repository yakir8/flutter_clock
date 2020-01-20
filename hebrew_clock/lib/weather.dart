import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'package:flutter_clock_helper/model.dart';
import 'package:digital_clock/handler/clock_style.dart';
import 'package:digital_clock/handler/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Weather extends StatefulWidget {
  final ClockModel clockModel;

  Weather(this.clockModel);

  @override
  State createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  Widget _buildWeatherInfo() {
    return Row(
      children: <Widget>[
        _getWeatherIcon(),
        SizedBox(width: 5),
        Expanded(child: Center(child: _getWeatherCondition())),
        Column(
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Text(
              widget.clockModel.highString,
              style: ClockStyle.getContentTextStyle(10, context),
            ),
            Text(
              widget.clockModel.lowString,
              style: ClockStyle.getContentTextStyle(10, context),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
        SizedBox(
          width: 5,
        )
      ],
    );
  }

  Widget _getWeatherIcon() {
    switch (widget.clockModel.weatherCondition) {
      case WeatherCondition.cloudy:
        return Icon(
          Icons.cloud,
          size: 15,
          color: ClockStyle.getFrontColors(context),
        );
        break;
      case WeatherCondition.foggy:
        return Icon(
          Icons.blur_on,
          size: 15,
          color: ClockStyle.getFrontColors(context),
        );
        break;
      case WeatherCondition.rainy:
        return Icon(
          FontAwesomeIcons.cloudRain,
          size: 15,
          color: ClockStyle.getFrontColors(context),
        );
        break;
      case WeatherCondition.snowy:
        return Icon(
          FontAwesomeIcons.snowflake,
          size: 15,
          color: ClockStyle.getFrontColors(context),
        );
        break;
      case WeatherCondition.sunny:
        return Icon(
          Icons.wb_sunny,
          size: 15,
          color: ClockStyle.getFrontColors(context),
        );
        break;
      case WeatherCondition.thunderstorm:
        return Icon(
          FontAwesomeIcons.pooStorm,
          size: 15,
          color: ClockStyle.getFrontColors(context),
        );
        break;
      case WeatherCondition.windy:
        return Icon(
          FontAwesomeIcons.wind,
          size: 15,
          color: ClockStyle.getFrontColors(context),
        );
        break;
    }
    return Icon(
      Icons.wb_sunny,
      size: 15,
      color: ClockStyle.getFrontColors(context),
    );
  }

  Widget _getWeatherCondition() {
    switch (widget.clockModel.weatherCondition) {
      case WeatherCondition.cloudy:
        return Text(
          _getTranslate('cloudy'),
          style: ClockStyle.getContentTextStyle(10, context),
        );
        break;
      case WeatherCondition.foggy:
        return Text(
          _getTranslate('foggy'),
          style: ClockStyle.getContentTextStyle(10, context),
        );
        break;
      case WeatherCondition.rainy:
        return Text(
          _getTranslate('rainy'),
          style: ClockStyle.getContentTextStyle(10, context),
        );
        break;
      case WeatherCondition.snowy:
        return Text(
          _getTranslate('snowy'),
          style: ClockStyle.getContentTextStyle(10, context),
        );
        break;
      case WeatherCondition.sunny:
        return Text(
          _getTranslate('sunny'),
          style: ClockStyle.getContentTextStyle(10, context),
        );
        break;
      case WeatherCondition.thunderstorm:
        return Text(
          _getTranslate('thunderstorm'),
          style: ClockStyle.getContentTextStyle(10, context),
        );
        break;
      case WeatherCondition.windy:
        return Text(
          _getTranslate('windy'),
          style: ClockStyle.getContentTextStyle(10, context),
        );
        break;
    }
    return Text(
      _getTranslate('snowy'),
      style: ClockStyle.getContentTextStyle(10, context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
            alignment: _isHebrewFormat() ? Alignment.bottomRight : Alignment.bottomLeft,
            child: Container(
              width:
                  widget.clockModel.weatherCondition == WeatherCondition.thunderstorm ? 130 : 105,
              height: 35,
              child: _buildWeatherInfo(),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  borderRadius: _isHebrewFormat()
                      ? BorderRadius.only(topLeft: Radius.circular(5.0))
                      : BorderRadius.only(topRight: Radius.circular(5.0)),
                  color: ClockStyle.isLightMod
                      ? Color.fromRGBO(128, 128, 128, 0.3)
                      : Color.fromRGBO(0, 0, 0, 0.7)),
            ))
      ],
    );
  }

  bool _isHebrewFormat() => ui.window.locale.languageCode == 'he';

  String _getTranslate(String str) {
    return AppLocalizations.of(context).translate(str);
  }
}
