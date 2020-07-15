import 'package:flutter/material.dart';

class NeumorphicButtonWidget extends StatelessWidget {
  IconData iconData;
  double height;
  double width;
  Widget widget;

  NeumorphicButtonWidget(
      {@required this.iconData,
      this.height = 50,
      this.width = 50,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            offset: Offset(-5, -5),
            blurRadius: 10,
            color: Color(0xFFFFFFFF),
          ),
          BoxShadow(
            offset: Offset(5, 5),
            blurRadius: 10,
            color: Colors.grey[350],
          )
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFFE0EAFC),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Center(child: widget),
      ),
    );
  }
}
