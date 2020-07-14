import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:musicPlayer/model/song_provider.dart';
import 'package:musicPlayer/utils/native_bridge.dart';
import 'package:musicPlayer/widgets/decoration.dart';
import 'package:musicPlayer/widgets/gradial_circular_image.dart';
import 'package:musicPlayer/widgets/neumorphic_ui_widget.dart';
import 'package:musicPlayer/widgets/neumorphic_ui_widget_concave.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int valueHolder = 20;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homeScreenWidget(),
    );
  }

  Widget homeScreenWidget() {
    return Consumer<SongProvider>(
      builder: (context, model, child) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE0EAFC), Color(0xFFECF3FC)],
            ),
          ),
          child: itemWidget(model),
        );
      },
    );
  }

  Widget itemWidget(SongProvider model) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 60,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: NeumorphicCircularIconWidget(
                iconData: Icons.close,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            NeumorphicCircularIconWidget(
              iconData: Icons.menu,
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        SizedBox(
          height: 50,
        ),
        GradialCircularImageWidget(
          imageUrl:
              'https://scontent.fblr1-4.fna.fbcdn.net/v/t1.0-9/c0.0.843.843a/p843x403/72755829_3051147524960621_5300041247296061440_o.jpg?_nc_cat=101&_nc_sid=09cbfe&_nc_ohc=mEoekI1IcPsAX97_Ki3&_nc_ht=scontent.fblr1-4.fna&oh=19b2bbe3e4349b664f8ffc5cc22d0ccc&oe=5F0B99CD',
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          model.currentSong.title,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          model.currentSong.artistName,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 40,),
        NeumorphicSlider(
          value: model.position?.inMilliseconds?.toDouble() ?? 0,
          onChanged: (double value) =>
              NativeBridge.instance.seekSong((value / 1000).roundToDouble()),
          min: 0.0,
          max: model.duration.inMilliseconds.toDouble(),
          style: SliderStyle(
            depth: 10,
            border: NeumorphicBorder.none(),
          ),
        ),
        SizedBox(height: 40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                model.previousSong();
              },
              child: NeumorphicCircularIconWidget(
                iconData: Icons.fast_rewind,
                height: 60,
                width: 60,
              ),
            ),
            Stack(
              children: <Widget>[
                Visibility(
                  visible: model.songState != PlaySongType.PLAY,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        model.resumeSong();
                      });
                    },
                    child: NeumorphicCircularIconWidget(
                      iconData: Icons.play_arrow,
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
                Visibility(
                  visible: model.songState == PlaySongType.PLAY,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        model.pauseSong();
                      });
                    },
                    child: NeumorphicCircularIconConcaveWidget(
                      iconData: Icons.pause,
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                model.nextSong();
              },
              child: NeumorphicCircularIconWidget(
                iconData: Icons.fast_forward,
                height: 60,
                width: 60,
              ),
            )
          ],
        )
      ],
    );
  }

  void checkpermission() {
//     NativeBridge.instance.checkPermission().then((value)  {
//       if(value == 0){
//
//       }
//     });
  }
}

// colors: [Color(0xFFECF3FC),Color(0xFFE0EAFC)],
