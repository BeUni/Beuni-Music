import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musicPlayer/model/song_item.dart';
import 'package:musicPlayer/utils/native_bridge.dart';

enum PlaySongType { PLAY, PAUSE, STOP }

class SongProvider extends ChangeNotifier {
  List<SongItem> _songItemList = List();
  SongItem _currentSong;
  PlaySongType songState = PlaySongType.PAUSE;
  int _currentSongPosition;

  Duration duration;
  Duration position;

  List<SongItem> get songItemList => _songItemList;

  SongItem get currentSong => _currentSong;

  int get currentSongPosition => _currentSongPosition;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';


  void updateSongList(List<SongItem> songItemList) {
    _songItemList = songItemList;
    initPlayer();
  }

  void currentPlaySong(SongItem songItem) {
    _currentSong = songItem;
  }

  void updateState(PlaySongType state) {
    songState = state;
    notifyListeners();
  }

  void playSong(int position) {
    stopSong();
    _currentSongPosition = position;
    play(songItemList[position]);
    updateState(PlaySongType.PLAY);
    notifyListeners();
  }

  void play(SongItem songItem) {
    _currentSong = songItem;
    NativeBridge.instance.playSong(songItem.songPath);
  }

  void onComplete() {
    nextSong();
  }

  void pauseSong() {
    updateState(PlaySongType.PAUSE);
    NativeBridge.instance.pauseSong();
  }

  void resumeSong() {
    initPlayer();
    updateState(PlaySongType.PLAY);
    NativeBridge.instance.resumeSong();
  }

  void nextSong() {
    stopSong();
    if (songItemList.length > currentSongPosition) {
      playSong(currentSongPosition + 1);
    } else {
      playSong(0);
    }
  }

  void previousSong() {
    stopSong();
    if (currentSongPosition == 0) {
      playSong(songItemList.length);
    } else {
      playSong(currentSongPosition - 1);
    }
  }

  void stopSong() {
    updateState(PlaySongType.STOP);
    NativeBridge.instance.stopSong();
  }

  void initPlayer() {
    NativeBridge.instance.setDurationHandler((d) {
      this.duration = d;
      notifyListeners();
    });

    NativeBridge.instance.setPositionHandler((p) {
      this.position = p;
      notifyListeners();
    });

    NativeBridge.instance.setCompletionHandler(() {
      nextSong();
      notifyListeners();
    });
  }
}
