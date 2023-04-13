import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:provider_music_player/screens/dash_board_screen.dart';
import 'package:sqflite/sqflite.dart';
import '../api_constant/api_constant.dart';
import '../controller/dash_board_controller.dart';
import '../main.dart';
import '../models/token_model.dart';
import '../network_class/network_class.dart';
import '../session_manager/session_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  List<FileSystemEntity>? files;
  List<FileSystemEntity> songs = [];
  List<String> myMusicList = [];
  bool isPlaying = false;

  List<SongModel> favouriteList = [];
  bool isSelected = false;
  int? currentIndex;
  List<Map> list = [];

  @override
  void initState() {
//    requestPermission();
    createDatabase();
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
    musicPlayer.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("<----App Resumed--->");
    } else if (state == AppLifecycleState.paused) {
      debugPrint("<----App paused--->");
    } else if (state == AppLifecycleState.detached) {
      debugPrint("<----App detached--->");
      musicPlayer.dispose();
    } else if (state == AppLifecycleState.inactive) {
      debugPrint("<----App inactive--->");
    }
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

  var isLoading = false;
  HttpService httpService = HttpService();
  var errorMessage = "";
  List<int> idList = [];

  List<int> indexList = [];

  Future<void> getFavList() async {
    list = await database.rawQuery('SELECT * FROM my_table');
    debugPrint("list length : ${list.length}");
    for (int i = 0; i < list.length; i++) {
      idList.add(list[i]['_id']);

      debugPrint("Music ID : ${list[i]['_id']}");
      debugPrint("idList : ${idList}");
    }
  }

  Future<TokenModel?> getToken() async {
    TokenModel? tokenResponse;
    try {
      /*  var response = await httpService.request(url: ApiConstants.tokenBaseUrl + ApiConstants.tokenEndUrl, method: Method.POST, params: formData);
      tokenResponse = TokenModel.fromJson(response?.data);*/

      var dio = Dio();

      var url = ApiConstants.tokenBaseUrl + ApiConstants.tokenEndUrl;
      var data = {
        'client_id': "a5b1a2cd01d748a197c7f1fce58a9d43",
        'client_secret': "a2d19b5c8bd54168a5db45027d8f25ec",
        'grant_type': 'client_credentials',
      };

      var response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );
      tokenResponse = TokenModel.fromJson(response?.data);
      SessionManager.getInstance().addToken(tokenResponse.accessToken);
    } catch (e) {
      String error = e.toString().replaceAll("Exception:", "");
      errorMessage = error;
    } finally {
      isLoading = false;
    }
    return tokenResponse;
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DashBoard(),
          ));
      // Do something
    });
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset("assets/images/splash2.jpeg"),
            )
          ],
        ));
  }
}
