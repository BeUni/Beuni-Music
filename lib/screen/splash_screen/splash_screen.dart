import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musicPlayer/screen/ask_permission/ask_permission_screen.dart';
import 'package:musicPlayer/screen/music_listing_screen/music_listing.dart';
import 'package:musicPlayer/utils/native_bridge.dart';
import 'package:musicPlayer/widgets/gradial_circular_image.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0EAFC), Color(0xFFECF3FC)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GradialCircularImageWidget(
                imageUrl:
                    'https://i.pinimg.com/564x/24/62/77/246277e0d908cd3a798eb1cd2b28c14e.jpg',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Timer> _startTimer() async {
    return new Timer(Duration(seconds: 4), _openNextScreen);
  }

  void _openNextScreen() {
    NativeBridge.instance.checkPermission("openScreen").then((value) {
      var valId = int.parse(value);
      if (valId == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MusicListingScreen()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AskPermissionScreen()));
      }
    });
  }
}
