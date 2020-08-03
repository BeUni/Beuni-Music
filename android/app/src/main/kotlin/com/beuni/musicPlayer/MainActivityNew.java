package com.beuni.musicPlayer;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.util.Log;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;

import com.beuni.musicPlayer.model.SongItem;
import com.google.gson.Gson;

import org.jetbrains.annotations.NotNull;

import java.io.File;
import java.io.IOException;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivityNew extends FlutterActivity {

    private static final String CHANNEL_NAME = "com.beuni.MusicPlayer";

    private String[] permissions = {Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE};
    private MethodChannel.Result result;

    private MethodChannel channel;
    private AudioManager am;
    private Handler handler;

    private MediaPlayer mediaPlayer;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        handler = new Handler();
        if (am == null){
            am = (AudioManager) getActivity().getApplicationContext().getSystemService(Context.AUDIO_SERVICE);
        }
    }

    @Override
    public void configureFlutterEngine(@NotNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        channel = new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL_NAME);

        channel.setMethodCallHandler((methodCall, result) -> {
                    switch (methodCall.method) {
                        case MethodName.ASK_PERMISSION:
                            askPermission(methodCall, result);
                            break;
                        case MethodName.GET_LOCAL_STORAGE_ADDRESS:
                            getSongList(methodCall, result);
                            break;
                        case MethodName.PLAY_SONG:
                            playSong(methodCall, result);
                            result.success(1);
                            break;
                        case MethodName.PAUSE_SONG:
                            pauseSong(methodCall, result);
                            break;
                        case MethodName.RESUME_SONG:
                            resumeSong(methodCall, result);
                            break;
                        case MethodName.STOP_SONG:
                            stopSong(methodCall, result);
                            break;
                        case MethodName.SEEK_POSITION:
                            seekPosition(methodCall, result);
                            break;
                        case MethodName.MUTE_SONG:
                            muteSong(methodCall, result);
                            break;
                        case MethodName.ON_SHARE_APP:
                            onShareApp();
                            break;
                        case MethodName.OPEN_PAYPAL:
                            openPaypal();
                            break;
                    }

                });
    }

    private void openPaypal() {
        Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("http://paypal.me/imshivamsharma"));
        startActivity(browserIntent);
    }

    private void onShareApp() {
        Intent sendIntent = new Intent();
        sendIntent.setAction(Intent.ACTION_SEND);
        sendIntent.putExtra(Intent.EXTRA_TEXT,
                "Hey check Beuni Music App at: https://play.google.com/store/apps/details?id=" + BuildConfig.APPLICATION_ID);
        sendIntent.setType("text/plain");
        startActivity(sendIntent);
    }

    private void resumeSong(MethodCall methodCall, MethodChannel.Result result) {
        mediaPlayer.start();
        handler.post(sendData);
        channel.invokeMethod(MethodName.ON_START, true);
    }

    private boolean playSong(MethodCall methodCall, MethodChannel.Result result) {

        String url = (String) methodCall.arguments;
        if (mediaPlayer == null) {
            mediaPlayer = new MediaPlayer();
            mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
            try {
                mediaPlayer.setDataSource(url);
            } catch (IOException e) {
                e.printStackTrace();
                Log.d("AUDIO", "invalid DataSource");
            }

            mediaPlayer.prepareAsync();
        } else {
            channel.invokeMethod(MethodName.SEEK_DURATION, mediaPlayer.getDuration());
            mediaPlayer.start();
            channel.invokeMethod(MethodName.ON_START, true);
        }

        mediaPlayer.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
            @Override
            public void onPrepared(MediaPlayer mp) {
                channel.invokeMethod(MethodName.SEEK_DURATION, mediaPlayer.getDuration());
                mediaPlayer.start();
                channel.invokeMethod(MethodName.ON_START, true);
            }
        });

        mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
            @Override
            public void onCompletion(MediaPlayer mp) {
                stop();
                channel.invokeMethod(MethodName.ON_COMPLETE, true);
            }
        });

        mediaPlayer.setOnErrorListener(new MediaPlayer.OnErrorListener() {
            @Override
            public boolean onError(MediaPlayer mp, int what, int extra) {
                channel.invokeMethod("audio.onError", String.format("{\"what\":%d,\"extra\":%d}", what, extra));
                return true;
            }
        });

        handler.post(sendData);

        return true;
    }

    private void pauseSong(MethodCall methodCall, MethodChannel.Result result) {
        pause();
        result.success(1);
    }

    private void stopSong(MethodCall methodCall, MethodChannel.Result result) {
        stop();
        result.success(1);
    }

    private void seekPosition(MethodCall methodCall, MethodChannel.Result result) {
        double position = methodCall.arguments();
        seek(position);
        result.success(1);
    }

    private void muteSong(MethodCall methodCall, MethodChannel.Result result) {
        Boolean muted = methodCall.arguments();
        mute(muted);
        result.success(1);
    }

    private void askPermission(MethodCall methodCall, MethodChannel.Result result) {
        this.result = result;

        if (checkWriteExternalPersmisison()) {
            Log.d("Permission Pop", "return Result :- 0");
            result.success("0");
        } else {
            String openPop = methodCall.arguments.toString();
            if (openPop.equals("openPop")) {
                if (!hasPermission(this, permissions)) {
                    Log.d("Permission Pop", "OpenPOop");
                    ActivityCompat.requestPermissions(this, permissions, 1);
                } else {
                    Log.d("Permission Pop", "return Result :- 0");
                    result.success("0");
                }
            } else {
                Log.d("Permission Pop", "return Result :- 1");
                result.success("1");
            }
        }

    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        if (permissions.length == 0) {
            return;
        }

        for (String permission : permissions) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, permission)) {
                //denied
                Log.e("denied", permission);
                Toast.makeText(
                        this,
                        "Permission denied to read External Storage",
                        Toast.LENGTH_SHORT
                ).show();
                finish();
            } else {
                if (ActivityCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED) {
                    //allowed
                    Log.e("allowed", permission);
                    Log.d("Permission Pop", "return Result :- 0");
//                    result.success("0");
                } else {
                    //set to never ask again
                    Log.e("set to never ask again", permission);
                }
            }
        }

        if (hasPermission(this, permissions)) {
            result.success("0");
        }

    }

    private void getSongList(MethodCall methodCall, MethodChannel.Result result) {

        File file = new File(Environment.getExternalStorageDirectory().toString());
        Log.d("local storage", file.getAbsolutePath());
        SongUtils songUtils = new SongUtils(getContentResolver());
        List<SongItem> songItemLists = songUtils.getSongList();
        for (SongItem songItemList : songItemLists) {
            showLogg(songItemList.getId());
            showLogg(songItemList.getArtistName());
            showLogg(songItemList.getSongPath());
            showLogg(songItemList.getDuration());
            showLogg(songItemList.getAlbumArt());
            showLogg(songItemList.getDisplayName());
            showLogg(songItemList.getTitle());
        }
        result.success(new Gson().toJson(songItemLists));
//        result .success(songsMap);

    }


    private boolean hasPermission(Context context, String[] permissions) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            for (String permission : permissions) {
                if (ActivityCompat.checkSelfPermission(context, permission)
                        != PackageManager.PERMISSION_GRANTED) {
                    return false;
                }
            }
        }
        return true;

    }


    private boolean checkWriteExternalPersmisison() {
        String permission = Manifest.permission.READ_EXTERNAL_STORAGE;
        return checkCallingOrSelfPermission(permission) == PackageManager.PERMISSION_GRANTED;
    }

    private final Runnable sendData = new Runnable() {
        public void run() {
            try {
                if (!mediaPlayer.isPlaying()) {
                    handler.removeCallbacks(sendData);
                }
                int time = mediaPlayer.getCurrentPosition();
                channel.invokeMethod(MethodName.ON_CURRENT_POSITION, time);

                handler.postDelayed(this, 200);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    };


    private void mute(Boolean muted) {
        if (am == null)
            return;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            am.adjustStreamVolume(AudioManager.STREAM_MUSIC,
                    muted ? AudioManager.ADJUST_MUTE : AudioManager.ADJUST_UNMUTE, 0);
        } else {
            am.setStreamMute(AudioManager.STREAM_MUSIC, muted);
        }
    }

    private void seek(double position) {
        mediaPlayer.seekTo((int) (position * 1000));
    }

    private void stop() {
        handler.removeCallbacks(sendData);
        if (mediaPlayer != null) {
            mediaPlayer.stop();
            mediaPlayer.release();
            mediaPlayer = null;
        }
    }

    private void pause() {
        mediaPlayer.pause();
        handler.removeCallbacks(sendData);
    }


    interface MethodName {
        String GET_LOCAL_STORAGE_ADDRESS = "getLocalStorageAddress";
        String ASK_PERMISSION = "askPermission";
        String PLAY_SONG = "playSong";
        String PAUSE_SONG = "pauseSong";
        String RESUME_SONG = "resumeSong";
        String STOP_SONG = "stopSong";
        String MUTE_SONG = "muteSong";
        String SEEK_POSITION = "seekPosition";
        String SEEK_DURATION = "seekDuration";
        String ON_COMPLETE = "onComplete";
        String ON_START = "onStart";
        String ON_CURRENT_POSITION = "onCurrentPosition";
        String ON_SHARE_APP = "onShareApp";
        String OPEN_PAYPAL = "openPaypal";
    }

    private void showLogg(String msg){
        Log.d("BEUNI---->", msg);
    }
}
