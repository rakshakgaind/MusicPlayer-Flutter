import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:provider_music_player/controller/dash_board_controller.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  initState() {
    //requestPermission();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Provider.of<DasBoardScreenController>(context, listen: false).getFavList();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: 100,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("Favourite Screen"),
          backgroundColor: Colors.black,
          elevation: 0,
          shadowColor: Colors.white,

        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Consumer<DasBoardScreenController>(
              builder: (BuildContext context, controller, Widget? child) {
                if(Provider.of<DasBoardScreenController>(context,listen: false).list.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: Provider.of<DasBoardScreenController>(context, listen: false).list.length,
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
                                  Provider.of<DasBoardScreenController>(context,
                                      listen: false)
                                      .isPlaying = true;
                                  Provider.of<DasBoardScreenController>(context, listen: false).setFilePath(
                                    Provider.of<DasBoardScreenController>(context, listen: false).list[index]["_data"],
                                    Provider.of<DasBoardScreenController>(context, listen: false).list[index]["_id"],
                                    Provider.of<DasBoardScreenController>(context, listen: false).list[index]["title"],
                                    Provider.of<DasBoardScreenController>(context, listen: false).list[index]["artist"],
                                    false
                                  );
                                },
                                title: Text(
                                  Provider.of<DasBoardScreenController>(context, listen: false).list[index]["title"] ,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                    Provider.of<DasBoardScreenController>(context,
                                        listen: false)
                                        .list[index]["artist"] ,
                                    style: const TextStyle(color: Colors.white)),
                                trailing: GestureDetector(
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
                                ),
                                leading: QueryArtworkWidget(
                                  id: Provider.of<DasBoardScreenController>(context,
                                      listen: false)
                                      .list[index]["_id"] ,
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
      ),
    );
  }
}
