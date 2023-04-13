import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:provider_music_player/controller/album_track_screen_controller.dart';
import 'package:provider_music_player/controller/music_screen_controller.dart';
import 'package:provider_music_player/controller/spotify_artists_controller.dart';
import 'package:provider_music_player/screens/splash_scren.dart';
import 'package:sqflite/sqflite.dart';
import 'controller/artist_playlist_screen_controller.dart';
import 'controller/dash_board_controller.dart';
import 'controller/home_screen_controller.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  requestPermission();
  createDatabase();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MultiProvider(providers:  [
    ChangeNotifierProvider<HomeScreenController>(create: (context) => HomeScreenController()),
    ChangeNotifierProvider<MusicScreenController>(create: (context) => MusicScreenController()),
    ChangeNotifierProvider<DasBoardScreenController>(create: (context) => DasBoardScreenController()),
    ChangeNotifierProvider<SpotifyArtistsScreenController>(create: (context) => SpotifyArtistsScreenController()),
    ChangeNotifierProvider<ArtistPlayListScreenController>(create: (context) => ArtistPlayListScreenController()),
    ChangeNotifierProvider<AlbumTrackScreenController>(create: (context) => AlbumTrackScreenController()),
  ], child: const MyApp()));
}


requestPermission() async {
  bool permissionStatus = await audioQuery.permissionsStatus();
  if (!permissionStatus) {
    await audioQuery.permissionsRequest();
  }

}

  late  Database database;

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

  return database;
}

final musicPlayer = AudioPlayer();
final OnAudioQuery audioQuery = OnAudioQuery();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
