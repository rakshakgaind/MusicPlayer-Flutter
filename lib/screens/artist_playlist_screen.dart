import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:provider_music_player/controller/spotify_artists_controller.dart';
import 'package:provider_music_player/screens/album_tracks_screen.dart';

import '../controller/artist_playlist_screen_controller.dart';

class ArtistPlayListScreen extends StatefulWidget {

   ArtistPlayListScreen({super.key, required this. artisId});
  String artisId="";
  @override
  State<ArtistPlayListScreen> createState() => _ArtistPlayListScreenState();
}

class _ArtistPlayListScreenState extends State<ArtistPlayListScreen> {
  String id="";

  @override
  void initState() {
    id=widget.artisId;
    debugPrint("<-----Artist Id---->$id");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ArtistPlayListScreenController>(context, listen: false).getArtistsPlayList(id);


    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: 100,
          centerTitle: true,
          title: const Text("Artist PlayList"),
          backgroundColor: Colors.black,
          elevation: 0,
          shadowColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Consumer<ArtistPlayListScreenController>(
          builder: (BuildContext context, value, Widget? child) {
            return GridView.builder(
              shrinkWrap: true,
              itemCount: value.artistPlayList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 3,
                  mainAxisExtent: 199.9,
                  childAspectRatio: 19 / 12),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    debugPrint("<---album id--->${value.artistPlayList[index]!.id}");
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>   AlbumTrackScreen(albumId:value.artistPlayList[index]!.id.toString())));
                  },
                  child: Column(
                    children: [
                      (value.artistPlayList[index]!.images?.isNotEmpty)! ?
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 100.0,
                          /* autoPlay: true,
                         autoPlayInterval: Duration(seconds: 5),*/
                        ),
                        items: value.artistPlayList[index]!.images?.map((i) {
                          return Builder(
                            builder: (BuildContext context) {

                                return CircleAvatar(
                                  radius:
                                  MediaQuery.of(context).size.height / 9.5,
                                  backgroundColor: Colors.amber,
                                  child: CircleAvatar(
                                      backgroundColor:
                                      Colors.deepPurpleAccent.shade700,
                                      radius:
                                      MediaQuery.of(context).size.height / 15,
                                      backgroundImage: NetworkImage(i.url.toString())),
                                );
                            },
                          );
                        }).toList(),
                      )
                          :  CircleAvatar(
                        radius:
                        MediaQuery.of(context).size.height / 14,
                        backgroundColor: Colors.amber,
                        child: CircleAvatar(
                            backgroundColor:
                            Colors.deepPurpleAccent.shade700,
                            radius:
                            MediaQuery.of(context).size.height / 15,
                            backgroundImage: const AssetImage(
                                "assets/images/splash_music.png")),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        value.artistPlayList[index]!.name.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          // light
                        ),
                      ),
                     /* (value.artistPlayList[index]!.genres?.isNotEmpty)! ?
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 20.0,
                          scrollDirection: Axis.horizontal,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                        ),
                        items: value.artistPlayList[index]!.genres?.map((i) {
                          return Text(
                            i,
                            style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w100,
                            ),
                          );
                        }).toList(),
                      ) :
                      const Text(
                        "N/A",
                        style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w100,
                        ),
                      ),*/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Total Tracks : ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          Text(
                            (value.artistPlayList[index]!.totalTracks.toString()),

                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
        
      ),
    );
  }
}
