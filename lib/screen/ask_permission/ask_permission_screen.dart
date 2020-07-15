import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicPlayer/screen/home_screen/player_screen.dart';
import 'package:musicPlayer/screen/music_listing_screen/music_listing.dart';
import 'package:musicPlayer/utils/native_bridge.dart';
import 'package:musicPlayer/widgets/neumorphic_ui_button_widget.dart';
import 'package:musicPlayer/widgets/neumorphic_ui_widget.dart';

class AskPermissionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0EAFC), Color(0xFFECF3FC)],
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Container(
                height: 250,
                width: 250,
                child: Image.asset('assets/images/bg.png'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Need Permission",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w300,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "For read local music files need storage permission to work properly",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                ),
              ),
              Expanded(child: Container()),
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      SystemNavigator.pop();
                    },
                    child: NeumorphicButtonWidget(
                      width: 100,
                      widget: Text(
                        "Deny",
                        style: TextStyle(fontSize: 24, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap:() {
                      _askPermission(context);
                    },
                    child: NeumorphicButtonWidget(
                      width: 100,
                      widget: Text(
                        "Allow",
                        style: TextStyle(fontSize: 24, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                ],
              )
              ,SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _askPermission(BuildContext context) {
    NativeBridge.instance.checkPermission("openPop").then((value) {
      var valId = int.parse(value);
      if(valId == 0){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MusicListingScreen()));
      } else{
        SystemNavigator.pop();
      }
    });
  }
}
