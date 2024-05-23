import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/User.dart';

class AuthService extends GetxController {
  static AuthService get to => Get.find();
  RxBool isAuthenticated = false.obs;
  String type = '';
  Users? _user;
  RxBool isfirsttime = true.obs;

  void setisfirsttime() {
    isfirsttime = false.obs;
  }

  Users? get user => _user;
  @override
  void onInit() {
    super.onInit();
    loadAuthenticationStatus();
  }

  void updateAuthenticationStatus(Users usr, bool reme) {
    isAuthenticated.value = true;
    type = usr.type;
    if (reme) {
      saveAuthenticationStatus(usr);
    }
    _user = usr;
  }

  Future<void> Logout() async {
    isAuthenticated.value = false;
    type = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isAuthenticated');
    await prefs.remove('dataee');
  }

  Future<void> loadAuthenticationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool savedStatus = prefs.getBool('isAuthenticated') ?? false;
    String admintype = prefs.getString('Type') ?? '';

    String jsonString = prefs.getString('dataee') ?? '';
    if (jsonString.isNotEmpty) {
      try {
        _user = Users.fromJson(json.decode(jsonString));
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    }

    isAuthenticated.value = savedStatus;
    type = admintype;
  }

  Future<void> saveAuthenticationStatus(Users usr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    await prefs.setString('dataee', json.encode(usr.toJson()));
  }
}
