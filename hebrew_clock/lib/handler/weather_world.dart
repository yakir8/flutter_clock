import 'package:digital_clock/handler/cloud_layer.dart';
import 'package:digital_clock/handler/gradient_node.dart';
import 'package:digital_clock/handler/weather_motion.dart';
import 'package:flutter/material.dart';

import 'package:spritewidget/spritewidget.dart';

enum WeatherType { sunny, rainy, snowy, cloudy, foggy, windy, thunderstorm }

// The WeatherWorld is our root node for our sprite tree. The size of the tree
// will be scaled to fit into our SpriteWidget container.
class WeatherWorld extends NodeWithSize {
// The image map hold all of our image assets.
  final ImageMap images;

// The sprite sheet contains an image and a set of rectangles defining the individual sprites.
  final SpriteSheet sprites;

  WeatherWorld(this.images, this.sprites) : super(const Size(2048.0, 2048.0)) {
    // Start by adding a background.
    _background = GradientNode(
      this.size,
      Colors.transparent,
      Colors.transparent,
    );
    addChild(_background);

    // Then three layers of clouds, that will be scrolled in parallax.
    _cloudsSharp = CloudLayer(
        image: images['assets/images/clouds-0.png'], rotated: false, dark: false, loopTime: 20.0);
    addChild(_cloudsSharp);
    _cloudsSharp.active = false;

    _cloudsDark = CloudLayer(
        image: images['assets/images/clouds-1.png'], rotated: true, dark: true, loopTime: 40.0);
    addChild(_cloudsDark);
    _cloudsDark.active = false;

    _cloudsSoft = CloudLayer(
        image: images['assets/images/clouds-1.png'], rotated: false, dark: false, loopTime: 60.0);
    addChild(_cloudsSoft);
    _cloudsSoft.active = false;

    _rain = Rain(sprites);
    addChild(_rain);

    _snow = Snow(sprites);
    addChild(_snow);

    _cloud = Cloud(images);
    addChild(_cloud);

    _wind = Wind(sprites);
    addChild(_wind);
  }

  GradientNode _background;
  CloudLayer _cloudsSharp;
  CloudLayer _cloudsSoft;
  CloudLayer _cloudsDark;
  Rain _rain;
  Snow _snow;
  Cloud _cloud;
  Wind _wind;

  WeatherType get weatherType => _weatherType;

  WeatherType _weatherType = WeatherType.sunny;

  set weatherType(WeatherType weatherType) {
    if (weatherType == _weatherType) return;

    // Handle changes between weather types.
    _weatherType = weatherType;

    // Fade the background
    _background.motions.stopAll();

    // Fade the background from one gradient to another.
    _background.motions.run(new MotionTween<Color>(
        (a) => _background.colorTop = a, _background.colorTop, _getBackgroundColorsTop(), 1.0));

    _background.motions.run(new MotionTween<Color>((a) => _background.colorBottom = a,
        _background.colorBottom, _getBackgroundColorsBottom(), 1.0));

    // Activate/deactivate clouds.
    if (weatherType == WeatherType.rainy ||
        weatherType == WeatherType.snowy ||
        weatherType == WeatherType.foggy ||
        weatherType == WeatherType.windy ||
        weatherType == WeatherType.thunderstorm) {
      _cloudsDark.active = true;
      _cloudsSharp.active = true;
      _cloudsSoft.active = true;
    } else {
      _cloudsDark.active = false;
      _cloudsSharp.active = false;
      _cloudsSoft.active = false;
    }

    // Activate/deactivate rainy, snowy, windy, cloudy.
    _rain.active = weatherType == WeatherType.rainy;
    _snow.active = weatherType == WeatherType.snowy;
    _wind.active = weatherType == WeatherType.windy;
    _cloud.active = weatherType == WeatherType.cloudy;
  }

  Color _getBackgroundColorsTop() {
    switch (weatherType) {
      case WeatherType.sunny:
        return Colors.transparent;
        break;
      case WeatherType.rainy:
        return Color(0xff0b2734);
        break;
      case WeatherType.snowy:
        return Colors.transparent;
        break;
      case WeatherType.cloudy:
        return Color(0xFF000000);
        break;
      case WeatherType.foggy:
        return Color(0xff0b2734);
        break;
      case WeatherType.windy:
        return Colors.black;
        break;
      case WeatherType.thunderstorm:
        const Color(0xff0b2734);
        break;
    }
    return Colors.transparent;
  }

  Color _getBackgroundColorsBottom() {
    switch (weatherType) {
      case WeatherType.sunny:
        return Colors.transparent;
        break;
      case WeatherType.rainy:
        return Color(0xff4c5471);
        break;
      case WeatherType.snowy:
        return Color(0xffe0e3ec);
        break;
      case WeatherType.cloudy:
        return Colors.transparent;
        break;
      case WeatherType.foggy:
        return Color(0xff4c5471);
        break;
      case WeatherType.windy:
        return Colors.black;
        break;
      case WeatherType.thunderstorm:
        return Color(0xff4c5471);
        break;
    }
    return Colors.transparent;
  }
}
