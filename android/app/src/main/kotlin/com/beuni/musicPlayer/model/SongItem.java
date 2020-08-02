package com.beuni.musicPlayer.model;

import com.google.gson.annotations.SerializedName;

public class SongItem {

    @SerializedName("id")
    private String id;

    @SerializedName("artistName")
    private String artistName;

    @SerializedName("title")
    private String title;

    @SerializedName("songPath")
    private String songPath;

    @SerializedName("displayName")
    private String displayName;

    @SerializedName("duration")
    private String duration;

    @SerializedName("albumArt")
    private String albumArt = "";

    public String getAlbumArt() {
        return albumArt;
    }

    public void setAlbumArt(String albumArt) {
        this.albumArt = albumArt;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getArtistName() {
        return artistName;
    }

    public void setArtistName(String artistName) {
        this.artistName = artistName;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSongPath() {
        return songPath;
    }

    public void setSongPath(String songPath) {
        this.songPath = songPath;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }


}
