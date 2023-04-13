import 'package:flutter/cupertino.dart';

import '../network_class/network_class.dart';

class BasController extends ChangeNotifier{
  var isLoading = false;
  HttpService httpService = HttpService();
  var errorMessage = "";
}