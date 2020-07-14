import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class GradialCircularImageWidget extends StatelessWidget {

  final String imageUrl;
  GradialCircularImageWidget({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  offset: Offset(5, 5),
                  color: Color(0xFFE0EAFC),
                  blurRadius: 50)
            ],
            gradient: LinearGradient(
              transform: GradientRotation(math.pi / 4),
              begin: Alignment(-56.0, -56.0),
              end: Alignment(1.0, 1.0),
              colors: [Colors.black, Colors.white],
            ),
          ),
          child: Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    offset: Offset(5, 5),
                    color: Color(0xFFE0EAFC),
                    blurRadius: 50)
              ],
              gradient: LinearGradient(
                transform: GradientRotation(math.pi / 4),
                begin: Alignment(-56.0, -56.0),
                end: Alignment(1.0, 1.0),
                colors: [Colors.black, Colors.white],
              ),
            ),
            child: Card(
              shape: CircleBorder(
                  side: BorderSide(
                width: 10,
                color: Color(0xFFE0EAFC),
              )),
              elevation: 20,
              child: CircleAvatar(
                minRadius: 100,
                maxRadius: 100,
                backgroundImage: FileImage(File(imageUrl)),
              ),
            ),
          ),
        ),
    );
  }
}
