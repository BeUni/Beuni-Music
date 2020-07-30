package com.example.musicPlayer;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;

import com.example.musicPlayer.model.SongItem;
import com.google.gson.Gson;

import java.io.File;
import java.util.AbstractList;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class SongUtils {

    final String MEDIA_PATH = Environment.getExternalStorageDirectory()
            .getPath() + "/";
    private ArrayList<SongItem> songsList = new ArrayList<>();
    private String mp3Pattern = ".mp3";

    private List<SongItem> mSongs = new ArrayList<>();
    private ContentResolver mContentResolver;

    private List<String> songs = new ArrayList<String>();

    public SongUtils(ContentResolver contentResolver) {
        mContentResolver = contentResolver;
    }


    public List<SongItem> getSongList(){
        //Some audio may be explicitly marked as not being music
        String selection = MediaStore.Audio.Media.IS_MUSIC + " != 0";

        String[] projection = {
                MediaStore.Audio.Media._ID,
                MediaStore.Audio.Media.ARTIST,
                MediaStore.Audio.Media.TITLE,
                MediaStore.Audio.Media.DATA,
                MediaStore.Audio.Media.DISPLAY_NAME,
                MediaStore.Audio.Media.DURATION,
                MediaStore.Audio.Media.ALBUM_ID
        };

        Cursor cursor = mContentResolver.query(
                MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                projection,
                selection,
                null,
                null);

        while(cursor.moveToNext()){
            SongItem songItem = new SongItem();
            songItem.setId(cursor.getString(0));
            songItem.setArtistName(cursor.getString(1));
            songItem.setTitle(cursor.getString(2));
            songItem.setSongPath(cursor.getString(3));
            songItem.setDisplayName(cursor.getString(4));
            songItem.setDuration(cursor.getString(5));
            long albumId = cursor.getLong(6);

            Uri sArtworkUri = Uri
                    .parse("content://media/external/audio/albumart");
            Uri albumArtUri = ContentUris.withAppendedId(sArtworkUri, albumId);
            songItem.setAlbumArt(getRealPathFromURI(albumId));

            mSongs.add(songItem);
//            songs.add(cursor.getString(0) + "||" + cursor.getString(1) + "||" +   cursor.getString(2) + "||" +   cursor.getString(3) + "||" +  cursor.getString(4) + "||" +  cursor.getString(5));
        }

        return mSongs;
    }


    public String getRealPathFromURI(long albumId) {
        Cursor cursor = mContentResolver.query(MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI,
                new String[] {MediaStore.Audio.Albums._ID, MediaStore.Audio.Albums.ALBUM_ART},
                MediaStore.Audio.Albums._ID+ "=?",
                new String[] {String.valueOf(albumId)},
                null);

        cursor.moveToFirst();
        return cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Albums.ALBUM_ART));
            // do whatever you need to do
    }
}
