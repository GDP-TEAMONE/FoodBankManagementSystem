import 'dart:ui';
import 'package:foodbankmanagementsystem/Model/User.dart';
import 'package:foodbankmanagementsystem/helper/auth_service.dart';
import 'package:get/get.dart';

import 'package:get/get_state_manager/src/simple/list_notifier.dart';

class MockAuthService extends GetxService implements AuthService {
  @override
  RxBool isAuthenticated = false.obs;

  @override
  String type = '';

  @override
  Users? get user => null;

  @override
  Future<void> Logout() {

    throw UnimplementedError();
  }

  @override
  Disposer addListener(GetStateUpdate listener) {

    throw UnimplementedError();
  }

  @override
  Disposer addListenerId(Object? key, GetStateUpdate listener) {

    throw UnimplementedError();
  }

  @override
  void dispose() {

  }

  @override
  void disposeId(Object id) {

  }

  @override

  bool get hasListeners => throw UnimplementedError();

  @override

  int get listeners => throw UnimplementedError();

  @override
  Future<void> loadAuthenticationStatus() async {

    isAuthenticated.value = true;
    type = 'Admin';
  }

  @override
  void notifyChildrens() {

  }

  @override
  void refresh() {

  }

  @override
  void refreshGroup(Object id) {

  }

  @override
  void removeListener(VoidCallback listener) {

  }

  @override
  void removeListenerId(Object id, VoidCallback listener) {

  }

  @override
  Future<void> saveAuthenticationStatus(Users usr) {

    throw UnimplementedError();
  }

  @override
  void setisfirsttime() {

  }

  @override
  void update([List<Object>? ids, bool condition = true]) {

  }

  @override
  void updateAuthenticationStatus(Users usr, bool reme) {

  }

  @override
  late RxBool isfirsttime;


}