class SongItem {
//  @SerializedName("id")
  String id;

//  @SerializedName("artistName")
  String artistName;

//  @SerializedName("title")
  String title;

//  @SerializedName("songPath")
  String songPath;

//  @SerializedName("displayName")
  String displayName;

//  @SerializedName("duration")
  String duration;

  SongItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    artistName = json['artistName'];
    title = json['title'];
    songPath = json['songPath'];
    displayName = json['displayName'];
    duration = json['duration'];
  }
}
