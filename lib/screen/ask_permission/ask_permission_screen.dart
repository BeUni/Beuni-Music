import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicPlayer/screen/home_screen/home_screen.dart';
import 'package:musicPlayer/utils/native_bridge.dart';

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
              Expanded(child: Container()),
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      SystemNavigator.pop();
                    },
                    child: Text(
                      "Deny",
                      style: TextStyle(fontSize: 24, color: Colors.green),
                    ),
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap:() {
                      _askPermission(context);
                    },
                    child: Text(
                      "Allow",
                      style: TextStyle(fontSize: 24, color: Colors.green),
                    ),
                  ),
                ],
              )
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
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else{
        SystemNavigator.pop();
      }
    });
  }
}
