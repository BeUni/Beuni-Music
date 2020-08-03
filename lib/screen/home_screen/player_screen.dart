import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:musicPlayer/model/song_provider.dart';
import 'package:musicPlayer/screen/sponor_screen/sponsor_screen.dart';
import 'package:musicPlayer/utils/native_bridge.dart';
import 'package:musicPlayer/widgets/gradial_circular_image.dart';
import 'package:musicPlayer/widgets/neumorphic_ui_button_widget.dart';
import 'package:musicPlayer/widgets/neumorphic_ui_widget.dart';
import 'package:musicPlayer/widgets/neumorphic_ui_widget_concave.dart';
import 'package:provider/provider.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
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
    return model.currentSong != null
        ? Column(
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
                      widget: Icon(Icons.close),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SponsorScreen()));
                    },
                    child: NeumorphicButtonWidget(
                      widget: Icon(Icons.favorite, color: Colors.red,),
                    ),
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
                    model.currentSong?.albumArt ?? "",
                isUrlFromAsset: false,
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
              SizedBox(
                height: 40,
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: NeumorphicSlider(
                  value: model.position?.inMilliseconds?.toDouble() ?? 0,
                  onChanged: (double value) => NativeBridge.instance
                      .seekSong((value / 1000).roundToDouble()),
                  min: 0.0,
                  max: model.duration.inMilliseconds.toDouble(),
                  style: SliderStyle(
                    depth: 10,
                    border: NeumorphicBorder.none(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: <Widget>[
                    Text(
                      model.positionText,
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.w400),
                    ),
                    Expanded(child: Container()),
                    Text(
                      model.durationText,
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      model.previousSong();
                    },
                    child: NeumorphicCircularIconWidget(
                      widget: Icon(Icons.fast_rewind),
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
                            widget: Icon(Icons.play_arrow),
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
                      widget: Icon(Icons.fast_forward),
                      height: 60,
                      width: 60,
                    ),
                  )
                ],
              )
            ],
          )
        : Container();
  }
}
