import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musicPlayer/model/song_item.dart';
import 'package:musicPlayer/model/song_provider.dart';
import 'package:musicPlayer/screen/home_screen/home_screen.dart';
import 'package:musicPlayer/screen/music_listing_screen/component/music_list_item.dart';
import 'package:musicPlayer/utils/native_bridge.dart';
import 'package:musicPlayer/widgets/decoration.dart';
import 'package:musicPlayer/widgets/neumorphic_ui_widget.dart';
import 'package:musicPlayer/widgets/neumorphic_ui_widget_concave.dart';
import 'package:provider/provider.dart';

class MusicListingScreen extends StatefulWidget {
  MusicListingScreen({Key key}) : super(key: key);

  @override
  _MusicListingScreenState createState() => _MusicListingScreenState();
}

class _MusicListingScreenState extends State<MusicListingScreen> {
  Duration duration;
  Duration position;
  bool isBottomViewShow;

  @override
  void initState() {
    super.initState();
  }

  Future<List<SongItem>> getList() async {
    Future.delayed(Duration(seconds: 5));
    String localStorage = await NativeBridge.instance.getLocalStorage();

    List<SongItem> songList = json
        .decode(localStorage)
        .map<SongItem>((item) => SongItem.fromJson(item))
        .toList();

    return songList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFE0EAFC),
        title: Text("Beuni Music", style: TextStyle(
          color: Colors.blue
        ),),
        iconTheme: IconThemeData(
          color: Colors.blue
        ),
        leading: Icon(Icons.menu),
        centerTitle: true,
      ),
      body: listingWidget(),
    );
  }

  Widget listingWidget() {
    return Container(
      child: FutureBuilder<List<SongItem>>(
        future: getList(),
        builder: (context, AsyncSnapshot<List<SongItem>> snapshot) {
          if (snapshot.hasData) {
            return Consumer<SongProvider>(
              builder: (context, model, child) {
                model.updateSongList(snapshot.data);
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, position) {
                            return MusicListItemWidget(
                              model: model,
                              showDecoration: model.currentSongPosition == position,
                              songItem: snapshot.data[position],
                              onSongSelect: (songItem) {
                                setState(() {
                                  model.playSong(position);
                                });
                              },
                              songPlayState: (playSongState){
                                setState(() {
                                  if(playSongState == PlaySongType.PLAY){
                                      model.resumeSong();
                                  } else{
                                      model.pauseSong();
                                  }
                                });

                              },
                            );
                          }),
                    ),
                    Visibility(
                      visible: model.currentSong != null,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            margin: EdgeInsets.all(8),
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color(0xFFE0EAFC),
                            ),
                            child: Container(
                              decoration: ConcaveDecoration(
                                  depression: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  colors: [
                                    Colors.grey[350],
                                    Color(0xFFFFFFFF)
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width/2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            model.currentSong == null
                                                ? ""
                                                : model.currentSong.title,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                          ),
                                          Text(
                                            model.currentSong == null
                                                ? ""
                                                : model.currentSong.artistName,
                                            maxLines: 1,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          Visibility(
                                            visible: model.songState !=
                                                PlaySongType.PLAY,
                                            child: InkWell(
                                              onTap: (){
                                                setState(() {
                                                  model.resumeSong();
                                                });
                                              },
                                              child: NeumorphicCircularIconWidget(
                                                iconData: Icons.play_arrow,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: model.songState ==
                                                PlaySongType.PLAY,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  model.pauseSong();
                                                });
                                              },
                                              child:
                                                  NeumorphicCircularIconConcaveWidget(
                                                iconData: Icons.pause,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      InkWell(
                                        onTap: (){
                                          model.nextSong();
                                        },
                                        child: NeumorphicCircularIconWidget(
                                          iconData: Icons.fast_forward,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
