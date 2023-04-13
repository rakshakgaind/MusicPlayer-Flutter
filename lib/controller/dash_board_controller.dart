import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider_music_player/controller/base_controller.dart';

import '../main.dart';

class DasBoardScreenController extends BasController {
  Duration duration = const Duration(minutes: 0);
  String filePath = "";
  String songTitle = "";
  String artistName = "";
  int musicId = 0;
  bool isPlaying = false;
  List<PlaylistModel> playlists = [];
  List<Map> list = [];



  void setFilePath(var path, int id, String title, String name,bool isFromSpotify) async {
    filePath = path;
    musicId = id;
    songTitle = title;
    artistName = name;
    musicPlayer.play();
   if(isFromSpotify){
     duration=(await musicPlayer.setAudioSource(AudioSource.uri(Uri.parse(filePath),

       tag: MediaItem(
         // Specify a unique ID for each media item:
         id: musicId.toString(),
         // Metadata to display in the notification:
         album: artistName,
         title: songTitle,
         artUri: Uri.parse('https://example.com/albumart.jpg'),

       ),)))!;
   }else{
     duration=(await musicPlayer.setAudioSource(AudioSource.uri(Uri.file(filePath),

       tag: MediaItem(
         // Specify a unique ID for each media item:
         id: musicId.toString(),
         // Metadata to display in the notification:
         album: artistName,
         title: songTitle,
         artUri: Uri.parse('https://example.com/albumart.jpg'),

       ),)))!;
   }

    musicPlayer.play();
    notifyListeners();
  }

  void createPlaList(int addToFavouriteSongId,String uri,String artist,String title,int? duration,String data,String displayName,int? albumId, ) async {

    await database.insert(
      'my_table',
      {
        '_uri': uri,
        'artist': artist,
        'title': title,
        'duration': duration,
        '_data': data,
        '_display_name': displayName,
        'album_id': albumId,
        '_id': addToFavouriteSongId,
      },
    );

    notifyListeners();
  }

  Future<void> deleteRow(int id) async {
    final db = database; // assuming you have already created a reference to the database using the `openDatabase` method
    await db.delete(
      'my_table',
      where: 'id = ?',
      whereArgs: [id],
    );

    getFavList();
  }

  Future<void> getFavList() async {
    list = (await database.rawQuery('SELECT * FROM my_table'));
    debugPrint("list length:${list.length}");
    notifyListeners();
  }


@override
  void notifyListeners();
}
