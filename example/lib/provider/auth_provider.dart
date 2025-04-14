import 'package:cart_service/config/network_config.dart';
import 'package:cart_service/config/request.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final String _token = "";
  String get token => _token;

  Future<dynamic> login() async {
    try {
      var res = await ApplicationBaseRequest.post(
          CartNetworkConfig.baseUrl,
          "/auth/login",
          {"username": "morrison@gmail.com", "password": "mor_2314"}).request();
      print("Login:${res.data}");
      if (res.status ~/ 100 == 2) {
        return res.data['data'];
      } else {
        debugPrint("errro: ${res.data['data']}");
        return res.data;
      }
    } catch (e, trace) {
      debugPrint("Error while loging user $e \n $trace");
    }
  }
}
