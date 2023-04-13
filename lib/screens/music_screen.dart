import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../controller/dash_board_controller.dart';
import '../main.dart';

class MusicScreen extends StatefulWidget {
  MusicScreen({super.key, required this.id, required this.songUri});

  int id;
  String songUri;

  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  int musicId = 0;
  String song = "";

  @override
  void initState() {
    musicId = widget.id;
    song = widget.songUri;
    // Provider.of<MusicScreenController>(context, listen: false).setFilePath(song);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pop(
                  context,
                );
                setState(() {});
              },
              child: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 10,
          shadowColor: Colors.white,
          title: const Text("Music Player"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 80),
                      child: FutureBuilder<List<SongModel>>(
                        builder: (context, item) {
                          return QueryArtworkWidget(
                              size: 500,
                              artworkHeight: MediaQuery.of(context).size.height / 2,
                              artworkWidth: MediaQuery.of(context).size.height / 2,
                              id: musicId,
                              type: ArtworkType.AUDIO,
                              quality: 100,
                              nullArtworkWidget: Image.asset("assets/images/music_icon.jpeg"));
                        },
                      ),
                    ),

                    /*  CircleAvatar(
                      radius: MediaQuery.of(context).size.height / 6,
                      backgroundImage:
                          const AssetImage("assets/images/music_icon.jpeg"),
                    ),*/
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 70,
                    ),
                    const Text(
                      "In My Feeling..",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 80,
                    ),
                    /*   Text(
                      "Duration(${playerFunction.duration})",
                      style: const TextStyle(color: Colors.white),
                    ),*/
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 80,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height / 80,
                          right: MediaQuery.of(context).size.height / 80,
                          top: MediaQuery.of(context).size.height / 80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {

                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                          ),
                          const Icon(
                            Icons.library_books,
                            color: Colors.white,
                          ),
                          const Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    /// player progress bar---->
                    Consumer<DasBoardScreenController>(
                      builder: (context, playerFunction, child) {
                        return StreamBuilder<Duration>(
                          stream: musicPlayer.positionStream,
                          builder: (context, snapshot) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.height / 15,
                                  right:
                                      MediaQuery.of(context).size.height / 15,
                                  top: MediaQuery.of(context).size.height / 20),
                              child: ProgressBar(
                                progress: musicPlayer.position,
                                buffered: musicPlayer.bufferedPosition,
                                total: playerFunction.duration,
                                progressBarColor: Colors.red,
                                baseBarColor: Colors.white.withOpacity(0.24),
                                bufferedBarColor:
                                    Colors.white.withOpacity(0.24),
                                thumbColor: Colors.white,
                                barHeight: 5.0,
                                thumbRadius: 5.0,
                                timeLabelPadding: 10,
                                timeLabelTextStyle:
                                    const TextStyle(color: Colors.white),
                                onSeek: (duration) {
                                  musicPlayer.seek(duration);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),

                    /// player control--------->
                    Consumer<DasBoardScreenController>(
                      builder: (context, playerFunction, child) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height / 10,
                            right: MediaQuery.of(context).size.height / 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (musicPlayer.position > const Duration(seconds: 2)) {
                                    musicPlayer.seek(Duration(seconds: musicPlayer.position.inSeconds - 2));
                                    if (musicPlayer.position == const Duration(seconds: 2)) {
                                      musicPlayer.seek(Duration.zero);
                                    }
                                  }
                                },
                                icon: Icon(
                                  Icons.rotate_left,
                                  color: Colors.white,
                                  size: MediaQuery.of(context).size.height / 20,
                                ),
                              ),
                              Consumer<DasBoardScreenController>(
                                builder: (context, value, child) {
                                  return StreamBuilder<PlayerState>(
                                    stream: musicPlayer.playerStateStream,
                                    builder: (context, snapshot) {
                                      final playerState = snapshot.data;
                                      final processingState =
                                          playerState?.processingState;
                                      final playing = playerState?.playing;
                                      if (processingState ==
                                              ProcessingState.loading ||
                                          processingState ==
                                              ProcessingState.buffering) {
                                        return Container(
                                          margin: const EdgeInsets.all(8.0),
                                          width: 64.0,
                                          height: 64.0,
                                          child:
                                              const CircularProgressIndicator(),
                                        );
                                      } else if (playing != true) {
                                        return IconButton(
                                          icon: const Icon(
                                            Icons.play_circle,
                                            color: Colors.white,
                                          ),
                                          iconSize: 64.0,
                                          onPressed: musicPlayer.play,
                                        );
                                      } else if (processingState !=
                                          ProcessingState.completed) {
                                        return IconButton(
                                          icon: const Icon(
                                            Icons.pause_circle_filled_sharp,
                                            color: Colors.white,
                                          ),
                                          iconSize: 64.0,
                                          onPressed: musicPlayer.pause,
                                        );
                                      } else {
                                        return IconButton(
                                          icon: const Icon(
                                            Icons.replay,
                                            color: Colors.white,
                                          ),
                                          iconSize: 64.0,
                                          onPressed: () =>
                                              musicPlayer.seek(Duration.zero),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                onPressed: () {
                                  if (musicPlayer.position <=
                                          musicPlayer.bufferedPosition &&
                                      playerFunction.duration! -
                                              const Duration(seconds: 2) >=
                                          musicPlayer.position) {
                                    musicPlayer.seek(Duration(
                                        seconds:
                                            musicPlayer.position.inSeconds +
                                                2));
                                  }
                                },
                                icon: Icon(
                                  Icons.rotate_right,
                                  color: Colors.white,
                                  size: MediaQuery.of(context).size.height / 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
