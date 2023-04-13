
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

// storage
final box = GetStorage();

class SessionManager {
  static SessionManager? _instance;
  static SessionManager getInstance() {
    _instance ??= SessionManager();
    return _instance!;
  }

/*
  void addUserData(UserData? data) async {
    var encoded = jsonEncode(data);
    await box.write(ApiConstants.userData, encoded);
  }
  Future<UserData> getUserData() async {
    var data = box.read(ApiConstants.userData);
    var decoded = UserData.fromJson(json.decode(data)!);
    return decoded;
  }
*/

  void addToken(String? tokenArtist) async {
    debugPrint("token:-$tokenArtist");
    await box.write("token", tokenArtist);
  }

  Future<String?> getToken() async {
    return box.read("token");
  }

}