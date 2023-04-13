import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import '../controller/dash_board_controller.dart';
import '../main.dart';
import 'artist_songs_screen.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({super.key});

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  @override
  void initState() {
    requestPermission();
    createDatabase();
    someName();
    songsByArtist();
    super.initState();
  }

  requestPermission() async {
    bool permissionStatus = await audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await audioQuery.permissionsRequest();
    }
    setState(() {});
  }

  List<ArtistModel> something=[];

  someName() async {
    // DEFAULT:
    ArtistSortType.ARTIST;
    // OrderType.ASC_OR_SMALLER
    something = await audioQuery.queryArtists();
    debugPrint("something-->$something");
  }

  songsByArtist() async {
    List songsByArtist = await OnAudioQuery().queryWithFilters("Abhilipsa Panda",   WithFiltersType.AUDIOS,
      // This method has [args] as parameter. With this value you can create
      // a more 'advanced' search.
      args: AudiosArgs.ARTIST,
    );
    debugPrint("<-songs->$songsByArtist");
  }

  someNameAr() async {
    // DEFAULT: ArtworkFormat.JPEG, 200 and false
    Uint8List? something = await audioQuery.queryArtwork(
      12,
      ArtworkType.ARTIST,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 100,
          centerTitle: true,
          title: const Text("Artists"),
          backgroundColor: Colors.black,
          elevation: 0,
          shadowColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: GridView.builder(
          itemCount: something.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 1,
            mainAxisSpacing: 15,
            mainAxisExtent: 199.9,
            childAspectRatio: 19/12
          ), itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  ArtistSongs(artistName:something[index].artist),));
              },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.height/10.5,
                      backgroundColor: Colors.amber,
                      child: CircleAvatar(
                        backgroundColor: Colors.deepPurpleAccent.shade700,
                        radius: MediaQuery.of(context).size.height/11,
                        child: QueryArtworkWidget(
                          id: something[index].id ,
                          artworkBorder: BorderRadius.circular(100),
                          artworkHeight: MediaQuery.of(context).size.height / 5,
                          artworkWidth: MediaQuery.of(context).size.height / 5,
                          type: ArtworkType.ARTIST,
                          nullArtworkWidget: CircleAvatar(
                              radius: MediaQuery.of(context).size.height / 10,
                              backgroundImage: const AssetImage(
                                  "assets/images/music_icon.jpeg")),
                        ),
                      ),),
                    const SizedBox(height: 5,),
                    Text( something[index].artist,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white,
                        fontWeight: FontWeight.w300, // light
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),

            );
        },
        )

      ),
    );
  }
}
