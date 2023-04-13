import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:provider_music_player/controller/artist_playlist_screen_controller.dart';
import 'package:provider_music_player/controller/spotify_artists_controller.dart';

import 'artist_playlist_screen.dart';

class SpotifyArtists extends StatefulWidget {
  const SpotifyArtists({super.key});

  @override
  State<SpotifyArtists> createState() => _SpotifyArtistsState();
}

class _SpotifyArtistsState extends State<SpotifyArtists> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<SpotifyArtistsScreenController>(context, listen: false).getArtists();
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 100,
          centerTitle: true,
          title: const Text("Spotify Artists"),
          backgroundColor: Colors.black,
          elevation: 0,
          shadowColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Consumer<SpotifyArtistsScreenController>(
          builder: (BuildContext context, value, Widget? child) {
            return GridView.builder(
              shrinkWrap: true,
              itemCount: value.artistList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 3,
                  mainAxisExtent: 199.9,
                  childAspectRatio: 19 / 12),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    debugPrint("<---Artist id--->${value.artistList[index]!.id}");
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  ArtistPlayListScreen(artisId:value.artistList[index]!.id),)).then((value) {

                      Provider.of<ArtistPlayListScreenController>(context,listen: false).artistPlayList.clear();


                    });
                  },
                  child: Column(
                    children: [
                      value.artistList[index]!.images.isNotEmpty ?
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 100.0,
                          /* autoPlay: true,
                         autoPlayInterval: Duration(seconds: 5),*/
                        ),
                        items: value.artistList[index]!.images.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              if (i.url.isNotEmpty) {
                                return CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.height / 9.5,
                                  backgroundColor: Colors.amber,
                                  child: CircleAvatar(
                                      backgroundColor:
                                          Colors.deepPurpleAccent.shade700,
                                      radius:
                                          MediaQuery.of(context).size.height / 15,
                                      backgroundImage: NetworkImage(i.url)),
                                );
                              }
                              else {
                                return CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.height / 9.5,
                                  backgroundColor: Colors.amber,
                                  child: CircleAvatar(
                                      backgroundColor:
                                          Colors.deepPurpleAccent.shade700,
                                      radius:
                                          MediaQuery.of(context).size.height / 15,
                                      backgroundImage: const AssetImage(
                                          "assets/images/splash_music.png")),
                                );
                              }
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
                        value.artistList[index]!.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          // light
                        ),
                      ),
                      (value.artistList[index]!.genres?.isNotEmpty)! ?
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 20.0,
                          scrollDirection: Axis.horizontal,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                        ),
                        items: value.artistList[index]!.genres?.map((i) {
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            Numeral(value.artistList[index]!.followers.total)
                                .format(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          const Text(
                            "Followers",
                            style: TextStyle(
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
