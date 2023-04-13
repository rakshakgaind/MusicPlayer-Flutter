import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:provider_music_player/controller/album_track_screen_controller.dart';
import 'package:provider_music_player/controller/dash_board_controller.dart';

class AlbumTrackScreen extends StatefulWidget {
  String albumId="";
   AlbumTrackScreen({super.key, required this.albumId});

  @override
  State<AlbumTrackScreen> createState() => _AlbumTrackScreenState();
}

class _AlbumTrackScreenState extends State<AlbumTrackScreen> {
  String id="";
  @override
  initState() {
    id=widget.albumId;
    //requestPermission();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Provider.of<AlbumTrackScreenController>(context,listen: false).getArtistsAlbumTracks(id);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Songs Screen"),
        backgroundColor: Colors.black,
        elevation: 0,
        shadowColor: Colors.white,

      ),
      body: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Consumer<AlbumTrackScreenController>(
            builder: (BuildContext context, controller, Widget? child) {
              if(Provider.of<AlbumTrackScreenController>(context,listen: false).albumTracksList.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: Provider.of<AlbumTrackScreenController>(context, listen: false).albumTracksList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          ListTile(
                            dense: true,
                            hoverColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.white, width: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onTap: () {
                              setState(() {});
                              Provider.of<DasBoardScreenController>(context, listen: false).isPlaying = true;
                              debugPrint("<----data--->${Provider.of<AlbumTrackScreenController>(context, listen: false).albumTracksList[index]!.previewUrl}");
                              Provider.of<DasBoardScreenController>(context, listen: false).setFilePath(
                                Provider.of<AlbumTrackScreenController>(context, listen: false).albumTracksList[index]!.previewUrl,
                               0,
                                (Provider.of<AlbumTrackScreenController>(context, listen: false).albumTracksList[index]!.name)!,
                                (Provider.of<AlbumTrackScreenController>(context, listen: false).albumTracksList[index]!.artists?.first.name.toString())!,
                                true
                              );
                            },
                            title: Text(
                              Provider.of<AlbumTrackScreenController>(context, listen: false).albumTracksList[index]!.name.toString() ,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(Provider.of<AlbumTrackScreenController>(context, listen: false).albumTracksList[index]!.name.toString(),
                                style: const TextStyle(color: Colors.white)),
                            /*trailing: GestureDetector(
                              onTap: () {
                                Provider.of<DasBoardScreenController>(context,
                                    listen: false)
                                    .deleteRow(
                                    Provider.of<DasBoardScreenController>(
                                        context,
                                        listen: false)
                                        .list[index]['id'])
                                    .then((value) => {
                                  Provider.of<DasBoardScreenController>(
                                      context,
                                      listen: false)
                                      .notifyListeners()
                                });
                              },
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ),*/
                            leading: QueryArtworkWidget(
                              id: 0,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: CircleAvatar(
                                  radius: MediaQuery.of(context).size.height / 30,
                                  backgroundImage: const AssetImage(
                                      "assets/images/music_icon.jpeg")),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return  Center(child: Image.asset("assets/images/no_data.webp",color: Colors.amber,));
              }
            },
          )),
    );
  }
}
