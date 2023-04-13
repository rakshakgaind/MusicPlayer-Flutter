import 'package:flutter/cupertino.dart';
import 'package:provider_music_player/controller/base_controller.dart';

import '../api_constant/api_constant.dart';
import '../models/album_track_model.dart';
import '../network_class/network_class.dart';

class AlbumTrackScreenController extends BasController{

  List<Item?> albumTracksList = <Item>[];

  Future<AlbumTrackModel?> getArtistsAlbumTracks(String id) async {
    AlbumTrackModel? modelResponse;
    try {
      isLoading=true;
      httpService.initInterceptors();
      var response = await httpService.request(url: "${ApiConstants.baseUrl}${ApiConstants.albumTracksUrl}$id/tracks", method: Method.GET);
      modelResponse = AlbumTrackModel.fromJson(response?.data);
      albumTracksList.addAll((modelResponse.items)!);
      debugPrint("<--track list--->${albumTracksList.length}");

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