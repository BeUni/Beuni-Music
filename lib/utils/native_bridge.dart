import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';


typedef void TimeChangeHandler(Duration duration);

class NativeBridge {
  static const String channelName = "com.beuni.MusicPlayer";
  static const String _askPermission = "askPermission";
  static const String _getLocalStorageAddress = "getLocalStorageAddress";
  static const String _playSong = "playSong";
  static const String _pauseSong = "pauseSong";
  static const String _resumeSong = "resumeSong";
  static const String _stopSong = "stopSong";
  static const String _seekSong = "seekPosition";
  static const String _muteSong = "muteSong";
  static const String _onComplete = "onComplete";
  static const String _onStart = "onStart";
  static const String _onDuration = "seekDuration";
  static const String _onCurrentPosition = "onCurrentPosition";
  static const String _onShareApp = "onShareApp";

  TimeChangeHandler durationHandler;
  TimeChangeHandler positionHandler;
  VoidCallback startHandler;
  VoidCallback completionHandler;

  static NativeBridge _instance;
  static final MethodChannel _platform = MethodChannel(channelName);

  NativeBridge._(){
    _platform.setMethodCallHandler(platformCallHandler);
  }

  static NativeBridge get instance {
    _instance ??= NativeBridge._();
    return _instance;
  }
  Future platformCallHandler(MethodCall call) async {
    //    print("_platformCallHandler call ${call.method} ${call.arguments}");
    switch (call.method) {
      case _onDuration:
        final duration = new Duration(milliseconds: call.arguments);
        if (durationHandler != null) {
          durationHandler(duration);
        }
        //durationNotifier.value = duration;
        break;
      case _onCurrentPosition:
        if (positionHandler != null) {
          positionHandler(new Duration(milliseconds: call.arguments));
        }
        break;
      case _onStart:
        if (startHandler != null) {
          startHandler();
        }
        break;
      case _onComplete:
        if (completionHandler != null) {
          completionHandler();
        }
        break;
      default:
        print('Unknowm method ${call.method} ');
    }
  }

  Future<String> checkPermission(String openPop) async {
    try {
      String value = await _platform.invokeMethod(_askPermission, openPop);
      return value;
    } on PlatformException catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }
  }

  Future<String> getLocalStorage() async {
    try {
      String localAddress =
          await _platform.invokeMethod(_getLocalStorageAddress);
      print("fromNative--->"+localAddress);
      return localAddress;
    } on PlatformException catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }
  }

  Future<void> playSong(String url) async {
    try {
      await _platform.invokeMethod(_playSong, url);
    } catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }
  }

  Future<void> pauseSong() async {
    try {
      await _platform.invokeMethod(_pauseSong);
    } catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }
  }

  Future<void> resumeSong() async {
    try {
      await _platform.invokeMethod(_resumeSong);
    } catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }
  }

  Future<void> stopSong() async {
    try {
      await _platform.invokeMethod(_stopSong);
    } catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }
  }

  Future<void> seekSong(double position) async {
    try {
      await _platform.invokeMethod(_seekSong, position);
    } catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }
  }

  Future<void> muteSong() async {
    try {
      await _platform.invokeMethod(_muteSong);
    } catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }
  }

  void setDurationHandler(TimeChangeHandler handler) {
    durationHandler = handler;
  }

  void setPositionHandler(TimeChangeHandler handler) {
    positionHandler = handler;
  }

  void setStartHandler(VoidCallback callback) {
    startHandler = callback;
  }

  void setCompletionHandler(VoidCallback callback) {
    completionHandler = callback;
  }

  void shareApp() async{
    try {
      await _platform.invokeMethod(_onShareApp);
    } catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }
  }
}
