import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:provider_music_player/screens/favourites_screen.dart';
import 'package:provider_music_player/screens/home_screen.dart';
import 'package:provider_music_player/screens/spotify_artist.dart';
import '../controller/dash_board_controller.dart';
import '../controller/home_screen_controller.dart';
import '../controller/music_screen_controller.dart';
import '../main.dart';
import 'artists_screen.dart';
import 'music_screen.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  initState() {
    super.initState();
  }

  bool isPlaying = false;
  final controller = PersistentTabController(initialIndex: 0);

  final screens = [
    const HomeScreen(),
    const FavouritesScreen(),
    const ArtistScreen(),
    const SpotifyArtists()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: PersistentTabView(
        context,
        screens: screens,
        bottomScreenMargin: 30,
        handleAndroidBackButtonPress: true,
        floatingActionButton:  Consumer<DasBoardScreenController>(
          builder: (BuildContext context, controller, Widget? child) {
            return InkWell(onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                    duration: const Duration(milliseconds: 600),
                    type: PageTransitionType.bottomToTop,
                    inheritTheme: true,
                    ctx: context,
                    child: MusicScreen(
                        id: controller.musicId, songUri: controller.filePath),
                  ));
            }, child: Consumer<DasBoardScreenController>(
              builder: (BuildContext context, controller, Widget? child) {
                return Visibility(
                  visible: controller.isPlaying,
                  child: AnimatedContainer(
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                    ),
                    padding: const EdgeInsets.only(left: 8, bottom: 5),
                    height: MediaQuery.of(context).size.height / 11,
                    width: MediaQuery.of(context).size.width/1.05,
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Consumer<DasBoardScreenController>(
                                    builder: (context, controller, child) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                              .size
                                              .height /
                                              90,
                                        ),
                                        child: FutureBuilder<List<SongModel>>(
                                          builder: (context, item) {
                                            return QueryArtworkWidget(
                                              id: controller.musicId,
                                              type: ArtworkType.AUDIO,
                                              nullArtworkWidget: CircleAvatar(
                                                  radius: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                      31,
                                                  backgroundImage: const AssetImage(
                                                      "assets/images/music_icon.jpeg")),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width / 70,
                                  ),
                                  Consumer<DasBoardScreenController>(
                                    builder: (BuildContext context, controller,
                                        Widget? child) {
                                      return Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .height /
                                                4,
                                            child: Text(
                                              controller.songTitle,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .height /
                                                4,
                                            child: Text(
                                              controller.artistName,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Consumer<DasBoardScreenController>(
                                builder: (context, playerFunction, child) {
                                  return Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Consumer<MusicScreenController>(
                                        builder: (context, value, child) {
                                          return StreamBuilder<PlayerState>(
                                            stream:
                                            musicPlayer.playerStateStream,
                                            builder: (context, snapshot) {
                                              final playerState = snapshot.data;
                                              final processingState =
                                                  playerState?.processingState;
                                              final playing =
                                                  playerState?.playing;
                                              if (processingState ==
                                                  ProcessingState.loading ||
                                                  processingState ==
                                                      ProcessingState
                                                          .buffering) {
                                                return Container(
                                                  margin:
                                                  const EdgeInsets.all(8.0),
                                                  width: 10.0,
                                                  height: 10.0,
                                                  child:
                                                  const CircularProgressIndicator(),
                                                );
                                              } else if (playing != true) {
                                                return IconButton(
                                                  icon: const Icon(
                                                    Icons.play_circle,
                                                    color: Colors.white,
                                                  ),
                                                  iconSize: 30.0,
                                                  onPressed: musicPlayer.play,
                                                );
                                              } else if (processingState !=
                                                  ProcessingState.completed) {
                                                return IconButton(
                                                  icon: const Icon(
                                                    Icons
                                                        .pause_circle_filled_sharp,
                                                    color: Colors.white,
                                                  ),
                                                  iconSize: 30.0,
                                                  onPressed: musicPlayer.pause,
                                                );
                                              } else {
                                                return IconButton(
                                                  icon: const Icon(
                                                    Icons.replay,
                                                    color: Colors.white,
                                                  ),
                                                  iconSize: 20.0,
                                                  onPressed: () => musicPlayer
                                                      .seek(Duration.zero),
                                                );
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ));
          },
        ),
        backgroundColor: Colors.black,
        confineInSafeArea: true,
        resizeToAvoidBottomInset: true,
        items: [
          PersistentBottomNavBarItem(
            title: "Home",
            icon: const Icon(
              Icons.holiday_village,
            ),
          ),
          PersistentBottomNavBarItem(
            title: "Favourites",
            icon: const Icon(
              Icons.favorite,
            ),
          ),
          PersistentBottomNavBarItem(
            title: "Artists",
            icon: const Icon(
              Icons.account_box,
            ),
          ),
          PersistentBottomNavBarItem(
            title: "Spotify",
            icon: const Icon(
              Icons.online_prediction_sharp,
            ),
          ),
        ],
        stateManagement: true,
      ),


    );
  }
}
