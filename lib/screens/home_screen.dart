import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:provider_music_player/controller/home_screen_controller.dart';
import '../controller/dash_board_controller.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    requestPermission();
   /* createDatabase();*/
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenController>(builder: (context, controller, child) {
      Provider.of<HomeScreenController>(context,listen: false).createDatabase();
      return SafeArea(
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.black,
          appBar: AppBar(
            toolbarHeight: 100,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text("Home Screen"),
            backgroundColor: Colors.black,
            elevation: 0,
            shadowColor: Colors.white,
          ),
          body: FutureBuilder<List<SongModel>>(
            future: audioQuery.querySongs(
              sortType: null,
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.EXTERNAL,
              ignoreCase: false,
            ),
            builder: (context, item) {

              // Loading content
              if (item.data == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (item.data!.isEmpty) return const Text("Nothing found!");
              return RefreshIndicator(
                onRefresh:   controller.createDatabase,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: item.data!.length,
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
                                for(int i=0;i<controller.list.length;i++){
                                  var idList =[];
                                  debugPrint("Music ID : ${controller.list[i]['_id']}");
                                }
                                setState(() {});
                                Provider.of<DasBoardScreenController>(context, listen: false).isPlaying = true;
                                debugPrint("<----Played song info--->${item.data![index]}");
                                Provider.of<DasBoardScreenController>(context, listen: false).setFilePath(item.data![index].data, item.data![index].id, item.data![index].title, item.data![index].artist.toString(), false);
                              },
                              title: Text(
                                item.data![index].title,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(item.data![index].artist ?? "No Artist",
                                  style: const TextStyle(color: Colors.white)),
                              trailing:
                              GestureDetector(
                                onTap: () {
                                  setState(() {});
                                  Provider.of<DasBoardScreenController>(context, listen: false).createPlaList(
                                    item.data![index].id,
                                    item.data![index].uri.toString(),
                                    item.data![index].artist.toString(),
                                    item.data![index].title,
                                    item.data![index].duration,
                                    item.data![index].data,
                                    item.data![index].displayName,
                                    item.data![index].albumId,
                                  );
                                  controller.indexList.add(index);
                                  debugPrint("<---index list--->${controller.indexList}");

                                },
                                child:
                                !(controller.indexList.contains(index))?
                                (controller.idList.contains(item.data![index].id))
                                    ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                                    :
                                 const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                ) :
                                 const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ),
                              leading: QueryArtworkWidget(
                                id: item.data![index].id,
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
                  ),
                ),
              );
            },
          ),
        ),
      );
    },);
  }
}
