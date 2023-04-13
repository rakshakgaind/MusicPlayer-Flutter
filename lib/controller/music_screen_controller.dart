import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider_music_player/controller/base_controller.dart';

import '../main.dart';

class MusicScreenController extends BasController {
  bool isSelected = false;

  Duration duration = const Duration(minutes: 0);

  String filePath="";

  MusicScreenController() {
    debugPrint("<---init called--->");
  //  musicUrl();
  }

 /* void setFilePath(var path) async{
    filePath = path;
    duration = (await musicPlayer.setFilePath(filePath,))!;
    debugPrint("<---duration--->$duration");

    notifyListeners();
  }*/

/*  Future<void> musicUrl() async {
    debugPrint("<---music going to play--->$filePath");
    duration = (await musicPlayer.setFilePath('/storage/emulated/0/Download/Levels.mp3'))!;
    debugPrint("<---duration--->$duration");

    notifyListeners();
  }*/
}
