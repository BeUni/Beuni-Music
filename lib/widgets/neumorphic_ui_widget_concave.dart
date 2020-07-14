import 'package:flutter/material.dart';
import 'package:musicPlayer/widgets/decoration.dart';

class NeumorphicCircularIconConcaveWidget extends StatelessWidget {
  IconData iconData;
  double height;
  double width;

  NeumorphicCircularIconConcaveWidget({
    this.iconData,
    this.height = 50,
    this.width = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Container(
        decoration: ConcaveDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            colors: [Colors.grey[350],Color(0xFFFFFFFF)],
            depression: 10
        ),
        child: Icon(iconData),
      ),
    );
  }
}
