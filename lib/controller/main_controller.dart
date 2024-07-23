import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/models/users.dart';
import 'package:htql_mua_ban_nong_san/views/client/account_setting_page.dart';
import 'package:htql_mua_ban_nong_san/views/client/home_user_page.dart';

class MainController extends GetxController {
  static MainController get to => Get.find<MainController>();

  List<Widget> page = [
    const HomeUserPage(),
    const AccountSettingPage(),
    const AccountSettingPage(),
    const AccountSettingPage(),
    const AccountSettingPage(),
  ];

  List<String> titles = [
    'Home',
    'Danh Muc',
    'Don Hang',
    'San Pham',
    'tai khoan'
  ];

  RxInt numPage = 0.obs;

  Rx<User> user = User.initUser().obs;

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  RxBool isLoading = false.obs;
  RxBool isLogin = false.obs;

  Future<void> login(String uname, String pword) async {
    isLoading.value = true;
    final snapshot = await usersCollection
        .where('username', isEqualTo: uname)
        .where('password', isEqualTo: pword)
        .get();
    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          snapshot.docs[0].data() as Map<String, dynamic>;
      data["id"] = snapshot.docs[0].id;
      user.value = User.fromJson(data);
      isLogin.value = true;
    }
    isLoading.value = false;
  }

  Future<void> logout() async {
    isLoading.value = true;
    user.value = User.initUser();
    isLogin.value = false;
    numPage.value = 0;
    isLoading.value = false;
  }
}
