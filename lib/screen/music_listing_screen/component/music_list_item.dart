import 'package:flutter/material.dart';
import 'package:musicPlayer/model/song_item.dart';
import 'package:musicPlayer/model/song_provider.dart';
import 'package:musicPlayer/widgets/decoration.dart';
import 'package:musicPlayer/widgets/neumorphic_ui_widget.dart';
import 'package:musicPlayer/widgets/neumorphic_ui_widget_concave.dart';

class MusicListItemWidget extends StatefulWidget {
  final SongItem songItem;
  final Function(SongItem) onSongSelect;
  final Function(PlaySongType) songPlayState;
  final bool showDecoration;
  SongProvider model;

  MusicListItemWidget(
      {this.songItem, this.onSongSelect, this.showDecoration, this.model, this.songPlayState});

  @override
  _MusicListItemWidgetState createState() => _MusicListItemWidgetState();
}

class _MusicListItemWidgetState extends State<MusicListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      color: Color(0xFFE0EAFC),
      child: Container(
        decoration: widget.showDecoration
            ? ConcaveDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                depression: 10,
                colors: [Colors.grey[350], Colors.blue[100]])
            : null,
        child: ListTile(
          onTap: () {
            widget.onSongSelect(widget.songItem);
          },
          title: Text(widget.songItem.title),
          subtitle: Text(widget.songItem.artistName),
          trailing: widget.showDecoration && (widget.model.songState == PlaySongType.PLAY) ? InkWell(
            onTap: (){
              widget.songPlayState(PlaySongType.PAUSE);
            },
            child: NeumorphicCircularIconConcaveWidget(
              iconData: Icons.pause,
              height: 60,
              width: 60,
            ),
          ): InkWell(
            onTap: (){
              widget.songPlayState(PlaySongType.PLAY);
            },
            child: NeumorphicCircularIconWidget(
              widget: Icon(Icons.play_arrow),
              height: 60,
              width: 60,
            ),
          ),
        ),
      ),
    );
  }
}
