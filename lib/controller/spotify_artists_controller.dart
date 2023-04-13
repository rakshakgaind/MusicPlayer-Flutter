import 'package:flutter/cupertino.dart';
import 'package:provider_music_player/controller/base_controller.dart';
import '../api_constant/api_constant.dart';
import '../models/spotify_artist_models.dart';
import '../network_class/network_class.dart';

class SpotifyArtistsScreenController extends BasController{

  List<Item?> artistList = <Item>[];
 // List<Image?> imageList = <Image>[];

  //List<String> imageList=[];


  Future<SpotifyArtistsModel?> getArtists() async {

    SpotifyArtistsModel? modelResponse;
    try {
      isLoading=true;
      httpService.initInterceptors();
      var type="artist";
      var response = await httpService.request(url: "${ApiConstants.baseUrl}${ApiConstants.artists}&type=$type",
          method: Method.GET);
      modelResponse = SpotifyArtistsModel.fromJson(response?.data);
      artistList.addAll(modelResponse.artists.items);
      notifyListeners();

      debugPrint("<---artistList length--->${artistList.length}");

    } catch (e) {
      String error = e.toString().replaceAll("Exception:", "");
      errorMessage;
    } finally {
      isLoading=false;
    }
    return modelResponse;
  }



}