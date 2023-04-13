import 'package:flutter/cupertino.dart';
import 'package:provider_music_player/controller/base_controller.dart';
import '../api_constant/api_constant.dart';
import '../models/artist_play_list_model.dart';
import '../network_class/network_class.dart';

class ArtistPlayListScreenController extends BasController{


  String artistId="";
  List<Item?> artistPlayList = <Item>[];
  Future<ArtistPlayListScreenModel?> getArtistsPlayList(String id) async {
    ArtistPlayListScreenModel? modelResponse;
    try {
      isLoading=true;
      httpService.initInterceptors();
      var response = await httpService.request(url: "${ApiConstants.baseUrl}${ApiConstants.artistAlbum}$id/albums", method: Method.GET);
      modelResponse = ArtistPlayListScreenModel.fromJson(response?.data);
      artistPlayList.addAll((modelResponse.items)!);
      debugPrint("<----artist Play List---->${artistPlayList.length}");
      notifyListeners();

    } catch (e) {
      String error = e.toString().replaceAll("Exception:", "");
      errorMessage;
    } finally {
      isLoading=false;
    }
    return modelResponse;
  }

}