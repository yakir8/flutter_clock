import 'package:digital_clock/lightning.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:digital_clock/handler/weather_world.dart';

class WeatherAnimation extends StatefulWidget {
  final ClockModel clockModel;

  WeatherAnimation(this.clockModel, {Key key}) : super(key: key);

  @override
  _WeatherAnimationState createState() => new _WeatherAnimationState();
}

class _WeatherAnimationState extends State<WeatherAnimation> {
  bool assetsLoaded = false;

  // The image map hold all of our image assets.
  ImageMap _images;

  // The sprite sheet contains an image and a set of rectangles defining the individual sprites.
  SpriteSheet _sprites;

  // The weather world is our sprite tree that handles the weather animations.
  WeatherWorld weatherWorld;

  @override
  void initState() {
    // Always call super.initState
    super.initState();

    // Get our root asset bundle
    AssetBundle bundle = rootBundle;

    // Load all graphics, then set the state to assetsLoaded and create the
    // WeatherWorld sprite tree
    _loadAssets(bundle).then((_) {
      setState(() {
        assetsLoaded = true;
        weatherWorld = new WeatherWorld(_images, _sprites);
      });
    });
  }

  // This method loads all assets image that are needed for the weather animation.
  Future<void> _loadAssets(AssetBundle bundle) async {
    // Load images using an ImageMap
    _images = new ImageMap(bundle);
    await _images.load(<String>[
      'assets/images/clouds-0.png',
      'assets/images/clouds-1.png',
      'assets/images/weathersprites.png',
    ]);

    // Load the sprite sheet, which contains snowflakes and rain drops.
    String json =
        await DefaultAssetBundle.of(context).loadString('assets/images/weathersprites.json');
    _sprites = new SpriteSheet(_images['assets/images/weathersprites.png'], json);
  }

  void _decodeWeatherType() {
    switch (widget.clockModel.weatherCondition) {
      case WeatherCondition.cloudy:
        weatherWorld.weatherType = WeatherType.cloudy;
        break;
      case WeatherCondition.foggy:
        weatherWorld.weatherType = WeatherType.foggy;
        break;
      case WeatherCondition.rainy:
        weatherWorld.weatherType = WeatherType.rainy;
        break;
      case WeatherCondition.snowy:
        weatherWorld.weatherType = WeatherType.snowy;
        break;
      case WeatherCondition.sunny:
        weatherWorld.weatherType = WeatherType.sunny;
        break;
      case WeatherCondition.thunderstorm:
        weatherWorld.weatherType = WeatherType.thunderstorm;
        break;
      case WeatherCondition.windy:
        weatherWorld.weatherType = WeatherType.windy;
        break;
    }
  }

  double _decodeWeatherOpacity() {
    switch (widget.clockModel.weatherCondition) {
      case WeatherCondition.cloudy:
        return 1;
        break;
      case WeatherCondition.foggy:
        return 0.7;
        break;
      case WeatherCondition.rainy:
        return 0.4;
        break;
      case WeatherCondition.snowy:
        return 0.6;
        break;
      case WeatherCondition.sunny:
        return 0;
        break;
      case WeatherCondition.thunderstorm:
        return 1;
        break;
      case WeatherCondition.windy:
        return 0.6;
        break;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    if (!assetsLoaded) return Container();
    _decodeWeatherType();
    return Opacity(
        opacity: _decodeWeatherOpacity(),
        child: Stack(
          children: <Widget>[
            WeatherCondition.thunderstorm == widget.clockModel.weatherCondition
                ? Lightning()
                : Container(),
            SpriteWidget(weatherWorld)
          ],
        ));
  }
}
