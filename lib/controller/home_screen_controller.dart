import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:on_audio_query_platform_interface/details/on_audio_query_helper.dart';
import 'package:path/path.dart';
import 'package:provider_music_player/controller/base_controller.dart';
import 'package:sqflite/sqflite.dart';

import '../main.dart';

class HomeScreenController extends BasController {

  Duration duration = const Duration(minutes: 0);
  String filePath = "";
  String songTitle = "";
  String artistName = "";
  int musicId = 0;
  List<PlaylistModel> playlists=[];


  List<FileSystemEntity>? files;
  List<FileSystemEntity> songs = [];
  List<String> myMusicList = [];
  bool isPlaying = false;

  List<SongModel> favouriteList = [];
  bool isSelected = false;
  int? currentIndex;
  List<Map> list = [];


  List<int> idList =[];
  List<int> indexList=[];
  late  Database database;
  /// permission for audio query to fetch the songs from device-->
  requestPermission() async {
    bool permissionStatus = await audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await audioQuery.permissionsRequest();
    }
  }
  /// method for creating data base-->
  Future<Database> createDatabase() async {
    debugPrint("<---Create Database Method Called--->");
    /// Get a location using getDatabasesPath
    final String databasePath = await getDatabasesPath();

    /// Construct the path to the database
    final String path = join(databasePath, 'my_database.db');

    /// Open the database
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create the database table
        await db.execute(
          'CREATE TABLE my_table ('
              'id INTEGER PRIMARY KEY,'
              '_uri TEXT,'
              'artist TEXT,'
              'title TEXT,'
              'duration INTEGER,'
              ' _data TEXT,'
              '_display_name TEXT,'
              'album_id INTEGER,'
              '_id INTEGER)',
        );
      },
    );
    /// get favourite song list
    getFavList();
    return database;
  }
  /// get the favourite songs id's -->
  Future<void> getFavList() async {
    list = await database.rawQuery('SELECT * FROM my_table');
    debugPrint("<----saved song list length--->${list.length}");
    idList.clear();
    for(int i=0;i<list.length;i++){
      idList.add(list[i]['_id']);
    }
    debugPrint("<----id List--->$idList");

  }

  void setFilePath(var path, int id, String title, String name) async {
    filePath = path;
    musicId = id;
    songTitle = title;
    artistName = name;
    musicPlayer.play();
    duration = (await musicPlayer.setFilePath(
      filePath,
    ))!;
    musicPlayer.play();

    notifyListeners();
  }

}
