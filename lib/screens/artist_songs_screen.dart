import 'dart:io';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import '../controller/dash_board_controller.dart';
import '../main.dart';
import 'music_screen.dart';

class ArtistSongs extends StatefulWidget {
  ArtistSongs({super.key, required this.artistName});

  String artistName = "";

  @override
  State<ArtistSongs> createState() => _ArtistSongsState();
}

class _ArtistSongsState extends State<ArtistSongs> {
  List<FileSystemEntity>? files;
  List<FileSystemEntity> songs = [];
  List<String> myMusicList = [];
  bool isPlaying = false;

  List<SongModel> favouriteList = [];
  bool isSelected = false;
  int? currentIndex;
  List<Map> list = [];
  String aName = "";
  List songsByArtist = [];

  songsByArtistMethod(String name) async {
    songsByArtist = await OnAudioQuery().queryWithFilters(
      name, WithFiltersType.AUDIOS,
      args: AudiosArgs.ARTIST,
    );
    debugPrint("<---songs list-->$songsByArtist");
  }

  @override
  void initState() {
    requestPermission();
    createDatabase();
    aName = widget.artistName;
    songsByArtistMethod(aName);
    super.initState();
  }

  requestPermission() async {
    bool permissionStatus = await audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await audioQuery.permissionsRequest();
    }
    setState(() {});
  }

  late final Database database;

  Future<Database> createDatabase() async {
    // Get a location using getDatabasesPath
    final String databasePath = await getDatabasesPath();

    // Construct the path to the database
    final String path = join(databasePath, 'my_database.db');

    // Open the database
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

    getFavList();

    return database;
  }

  Future<void> getFavList() async {
    list = await database.rawQuery('SELECT * FROM my_table');
    debugPrint("list length : ${list.length}");
    for (int i = 0; i < list.length; i++) {
      idList.add(list[i]['_id']);

      debugPrint("Music ID : ${list[i]['_id']}");
      debugPrint("idList : ${idList}");
    }
  }

  List<int> idList = [];

  List<int> indexList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_rounded)),
        centerTitle: true,
        title: Text("Songs by $aName"),
        backgroundColor: Colors.black,
        elevation: 0,
        shadowColor: Colors.white,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: songsByArtist.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  hoverColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white, width: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onTap: () {
                    for (int i = 0; i < list.length; i++) {
                      var idList = [];
                      debugPrint("Music ID : ${list[i]['_id']}");
                    }

                    setState(() {});
                    Provider.of<DasBoardScreenController>(context,
                            listen: false)
                        .isPlaying = true;

                    Provider.of<DasBoardScreenController>(context,
                            listen: false)
                        .setFilePath(
                      songsByArtist[index]['_data'],
                      songsByArtist[index]["_id"],
                      songsByArtist[index]["title"],
                      songsByArtist[index]["artist"].toString(),
                      false,
                    );
                  },
                  title: Text(
                    songsByArtist[index]['title'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(songsByArtist[index]['artist'] ?? "No Artist",
                      style: const TextStyle(color: Colors.white)),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {});
                      debugPrint(
                          "<---data--->${songsByArtist[index]['_data']}");
                      Provider.of<DasBoardScreenController>(context,
                              listen: false)
                          .createPlaList(
                        songsByArtist[index]['_id'],
                        songsByArtist[index]['_uri'].toString(),
                        songsByArtist[index]['artist'].toString(),
                        songsByArtist[index]['title'],
                        songsByArtist[index]['duration'],
                        songsByArtist[index]['_data'],
                        songsByArtist[index]['_display_name'],
                        songsByArtist[index]['album_id'],
                      );
                      indexList.add(index);
                      // currentIndex=index;
                    },
                    child: !(indexList.contains(index))
                        ? (idList.contains(songsByArtist[index]['_id']))
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite,
                                color: Colors.white,
                              )
                        : const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                  ),
                  leading: QueryArtworkWidget(
                    id: songsByArtist[index]['_id'],
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: CircleAvatar(
                        radius: MediaQuery.of(context).size.height / 30,
                        backgroundImage:
                            const AssetImage("assets/images/music_icon.jpeg")),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
