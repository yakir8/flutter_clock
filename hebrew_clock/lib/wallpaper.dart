import 'dart:async';

import 'package:digital_clock/handler/clock_style.dart';
import 'package:flutter/material.dart';

/// This Widget crate wallpaper with [_maxImages] images which are change every [switchInterval]
class Wallpaper extends StatefulWidget {
  @override
  State createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  final int _maxImages = 23;
  final int switchInterval = 60;
  final BoxFit _boxFit = BoxFit.fitWidth;
  final String _imagePath = 'assets/images';
  final GlobalKey _imageOneKey = GlobalKey();
  final GlobalKey _imageTwoKey = GlobalKey();

  Timer timer;
  Widget _imageOne;
  Widget _imageTwo;
  int _imageIndex = 1;
  bool isCurrentImage = true;
  Alignment _alignment = Alignment.center;

  @override
  void initState() {
    timer = Timer(Duration(seconds: switchInterval), _replaceImage);
    _imageOne = Image.asset('$_imagePath/1.jpg', fit: _boxFit);
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Widget _buildImage() {
    if (isCurrentImage && _imageOne != null) return _imageOne;
    if (!isCurrentImage && _imageTwo != null) return _imageTwo;
    return Container();
  }

  //build two image widget for smooth swap
  void _replaceImage() async {
    setState(() {
      int nextIndex;
      _imageIndex = _imageIndex < _maxImages ? _imageIndex + 1 : 1;
      nextIndex = _imageIndex < _maxImages ? _imageIndex + 1 : 1;
      _alignment = nextIndex == 5 ? Alignment.bottomCenter : Alignment.center;
      isCurrentImage
          ? _imageTwo =
              Image.asset('$_imagePath/$nextIndex.jpg', fit: _boxFit, alignment: _alignment)
          : _imageOne =
              Image.asset('$_imagePath/$nextIndex.jpg', fit: _boxFit, alignment: _alignment);
      isCurrentImage = !isCurrentImage;
      timer = Timer(Duration(seconds: switchInterval), _replaceImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: Curves.linear,
      duration: Duration(milliseconds: 500),
      child: Row(
        key: isCurrentImage ? _imageOneKey : _imageTwoKey,
        children: <Widget>[
          Expanded(
              child: ClockStyle.isLightMod
                  ? _buildImage()
                  : ColorFiltered(
                      child: _buildImage(),
                      colorFilter: ColorFilter.mode(Colors.grey[600], BlendMode.modulate),
                    )),
        ],
      ),
    );
  }
}
