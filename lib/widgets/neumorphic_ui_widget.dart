import 'package:flutter/material.dart';

class NeumorphicCircularIconWidget extends StatelessWidget {
  IconData iconData;
  double height;
  double width;

  NeumorphicCircularIconWidget({
    @required this.iconData,
    this.height = 50,
    this.width = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              offset: Offset(-5, -5), blurRadius: 10, color: Color(0xFFFFFFFF)),
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
          shape: BoxShape.circle,
        ),
        child: Icon(iconData),
      ),
    );
  }
}
