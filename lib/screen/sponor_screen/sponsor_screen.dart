import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musicPlayer/utils/native_bridge.dart';
import 'package:musicPlayer/widgets/neumorphic_ui_button_widget.dart';
import 'package:musicPlayer/widgets/neumorphic_ui_widget.dart';

class SponsorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0EAFC), Color(0xFFECF3FC)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 60,
            ),
            Container(
              margin: EdgeInsets.only(left: 16),
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: NeumorphicButtonWidget(
                  widget: Icon(Icons.close),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Appreciate Us",
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
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Text(
                      "This music app is side project, we are trying to implement "
                          "new feature and release it ASAP and your feedback is valuable for us to improve it",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SvgPicture.asset('assets/images/sponsor.svg', height: 200, width: 200,),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          NativeBridge.instance.feedback();
                        },
                        child: NeumorphicButtonWidget(
                          width: 150,
                          widget: Text("Feedback"),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          NativeBridge.instance.openPaypal();
                        },
                        child: NeumorphicButtonWidget(
                          width: 150,
                          widget: Text("Appreciate us"),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
