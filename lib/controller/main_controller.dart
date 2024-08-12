import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/models/admin.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:htql_mua_ban_nong_san/models/buyer.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';
import 'package:htql_mua_ban_nong_san/views/view_buyer/account_setting_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_buyer/home_buyer_page.dart';

class MainController extends GetxController {
  static MainController get to => Get.find<MainController>();

  Rx<Buyer> buyer = Buyer.initBuyer().obs;
  Rx<Seller> seller = Seller.initSeller().obs;
  Rx<Admin> admin = Admin.initAdmin().obs;

  CollectionReference adminCollection =
      FirebaseFirestore.instance.collection('Admin');
  CollectionReference buyerCollection =
      FirebaseFirestore.instance.collection('Buyer');
  CollectionReference sellerCollection =
      FirebaseFirestore.instance.collection('Seller');
  CollectionReference provinceCollection =
      FirebaseFirestore.instance.collection('Province');

  RxBool isLoading = false.obs;

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

  RxList<Province> listProvince = <Province>[].obs;

  Future<bool> login(String uname, String pword) async {
    isLoading.value = true;

    //login with buyer
    final snapshot = await buyerCollection
        .where('username', isEqualTo: uname)
        .where('password', isEqualTo: pword)
        // .where('status', isNotEqualTo: 'inactive')
        .get();
    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          snapshot.docs[0].data() as Map<String, dynamic>;
      data['id'] = snapshot.docs[0].id;

      buyer.value = Buyer.fromJson(data);
      Get.toNamed('/');
      isLoading.value = false;
      return true;
    }

    //login with seller
    final snapshotSeller = await sellerCollection
        .where('username', isEqualTo: uname)
        .where('password', isEqualTo: pword)
        // .where('status', isNotEqualTo: 'inactive')
        .get();
    if (snapshotSeller.docs.isNotEmpty) {
      Map<String, dynamic> data =
          snapshotSeller.docs[0].data() as Map<String, dynamic>;
      data['id'] = snapshotSeller.docs[0].id;

      seller.value = Seller.fromJson(data);
      Get.toNamed('/');
      isLoading.value = false;
      return true;
    }

    //login Admin
    final snapshotAdmin = await adminCollection
        .where('username', isEqualTo: uname)
        .where('password', isEqualTo: pword)
        .get();
    if (snapshotAdmin.docs.isNotEmpty) {
      Map<String, dynamic> data =
          snapshotAdmin.docs[0].data() as Map<String, dynamic>;
      data['id'] = snapshotAdmin.docs[0].id;
      admin.value = Admin.fromJson(data);
      Get.toNamed('/admin');
      isLoading.value = false;
      return true;
    }
    isLoading.value = false;
    return false;
  }

  Future<void> logout() async {
    buyer.value = Buyer.initBuyer();
  }

  Future<void> loadAll() async {
    isLoading.value = true;
    if (listProvince.value.isEmpty) {
      await loadProvince();
    }
    isLoading.value = false;
  }

  Future<void> loadProvince() async {
    final snapshot = await provinceCollection.get();
    if (snapshot.docs.isNotEmpty) {
      for (var snap in snapshot.docs) {
        Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
        data['id'] = snap.id;
        Province province = Province.fromJson(data);
        listProvince.value.add(province);
      }
    }
  }
}
