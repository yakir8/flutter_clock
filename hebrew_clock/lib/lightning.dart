import 'dart:async';

import 'package:flutter/material.dart';

class Lightning extends StatefulWidget {
  @override
  State createState() => _LightningState();
}

class _LightningState extends State<Lightning> {
  Timer timer;
  double opacityLevel = 0;

  @override
  void initState() {
    timer = Timer(Duration(milliseconds: 500), _flashing);
    super.initState();
  }

  void _flashing() {
    timer = Timer(Duration(seconds: 10), _flashing);
    setState(() => opacityLevel = 1);
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() => opacityLevel = 1);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        onEnd: () {
          setState(() => opacityLevel = 0);
        },
        opacity: opacityLevel,
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 200),
        child: Opacity(
          opacity: 0.7,
          child: Container(
            color: Colors.blue[50],
          ),
        ));
  }
}
