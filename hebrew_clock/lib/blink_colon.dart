import 'dart:async';

import 'package:flutter/material.dart';
import 'package:digital_clock/handler/clock_style.dart';

class BlinkColon extends StatefulWidget {
  @override
  State createState() => _BlinkColonState();
}

class _BlinkColonState extends State<BlinkColon> {
  // timer between colon blinking
  Timer blinkTimer;

  //current colon opacity level
  double _opacityLevel = 1;

  @override
  void initState() {
    blinkTimer = Timer(Duration(milliseconds: 500), _blinkColon);
    super.initState();
  }

  @override
  void dispose() {
    blinkTimer?.cancel();
    super.dispose();
  }

  Widget _buildCircle() {
    return Container(
        decoration: BoxDecoration(
      border:
          Border.all(color: ClockStyle.isLightMod ? Colors.white : Color(0xFF2f545b), width: 6.0),
      borderRadius: BorderRadius.all(
        Radius.circular(40.0),
      ),
      boxShadow: [
        BoxShadow(
          blurRadius: 0,
          color: ClockStyle.getShadowColors(context),
          offset: Offset(3, 0),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: _opacityLevel,
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 500),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 2,
            ),
            Column(
              children: <Widget>[
                SizedBox(height: 10),
                _buildCircle(),
                SizedBox(
                  height: 15,
                ),
                _buildCircle(),
                SizedBox(
                  height: 20,
                )
              ],
            ),
            SizedBox(
              width: 2,
            ),
          ],
        ));
  }

  //Blinking execution
  void _blinkColon() {
    setState(() => _opacityLevel = _opacityLevel == 0 ? 1.0 : 0.0);
    blinkTimer = Timer(Duration(seconds: 1), _blinkColon);
  }
}
