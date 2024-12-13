import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/cart_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/cloudinary_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/models/buyer.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';

class BuyerController extends GetxController {
  static BuyerController get to => Get.find<BuyerController>();

  CollectionReference buyerCollection =
      FirebaseFirestore.instance.collection('Buyer');

  RxList<Buyer> listBuyer = <Buyer>[].obs;
  RxList<Product> listProductBought = <Product>[].obs;

  RxBool isLoading = false.obs;
  RxList<int> listCart = <int>[].obs;
  RxList<dynamic> listStatus = [
    {
      'value': 'active',
      'label': 'Đang hoạt động',
      'color': Colors.green,
    },
    {
      'value': 'warning',
      'label': 'Cảnh báo',
      'color': Colors.orange,
    },
    {
      'value': 'inactive',
      'label': 'Khóa',
      'color': Colors.red,
    },
  ].obs;
  RxInt indexBuyer = 0.obs;

  Future<void> loadBuyer() async {
    isLoading.value = true;
    listBuyer.value = [];
    final snapshot = await buyerCollection.get();
    for (var item in snapshot.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;

      data['id'] = item.id;
      data['rate_order'] =
          await Get.find<OrderController>().getRateSuccessByBuyer(item.id);
      if (data['status'] == 'active' && data['rate_order'] < 50) {
        data['status'] = 'warning';
      }

      listBuyer.add(Buyer.fromJson(data));
    }
    isLoading.value = false;
  }

  Future<void> loadBuyerByID(String id) async {
    isLoading.value = true;
    if (listBuyer.where((p0) => p0.id == id).isEmpty) {
      final snapshot = await buyerCollection.doc(id).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data['id'] = id;
      listBuyer.add(Buyer.fromJson(data));
    }
  }

  Future<void> updateBuyer(Buyer buyer) async {
    isLoading.value = true;
    await buyerCollection.doc(buyer.id).update(buyer.toVal());
    // await loadBuyer();
    if (buyer.status == 'active' && buyer.rate_order! < 80) {
      buyer.status = 'warning';
    }
    isLoading.value = false;
  }

  Future<void> updatePassword(Buyer buyer) async {
    isLoading.value = true;
    await buyerCollection.doc(buyer.id).update(buyer.toVal());

    isLoading.value = false;
  }

  Future<void> createBuyer(
    Buyer buyer,
  ) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    String newBuyerID = buyerCollection.doc().id;
    DocumentReference refBuyer = buyerCollection.doc(newBuyerID);
    batch.set(refBuyer, buyer.toVal());

    await batch.commit();
  }

  Future<bool> checkExistUsername(String username) async {
    final snapshot =
        await buyerCollection.where('username', isEqualTo: username).get();
    if (snapshot.docs.isEmpty) {
      return false;
    }

    return true;
  }

  Future<bool> checkExistEmail(String email) async {
    final snapshot =
        await buyerCollection.where('email', isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      return false;
    }
    return true;
  }

  Future<bool> checkExistPhone(String phone) async {
    final snapshot =
        await buyerCollection.where('phone', isEqualTo: phone).get();
    if (snapshot.docs.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    isLoading.value = true;
    listProductBought.value = [];
    await Get.find<CartController>().saveCart();
    Get.find<MainController>().buyer.value = Buyer.initBuyer();
    Get.find<MainController>().numPage.value = 0;

    Get.toNamed('/');
    isLoading.value = false;
  }

  Future<void> forgotPassword(String email, String password) async {
    isLoading.value = true;
    final snapshot =
        await buyerCollection.where('email', isEqualTo: email).get();
    for (var item in snapshot.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      data['password'] = password;
      Buyer buyer = Buyer.fromJson(data);
      await buyerCollection.doc(buyer.id).update(buyer.toJson());
    }
    isLoading.value = false;
  }

  Future<void> updateInformation(
      String filePathAvatar, String filePathCover) async {
    isLoading.value = true;
    Buyer buyer = Get.find<MainController>().buyer.value;
    if (filePathAvatar != '') {
      Get.find<MainController>().buyer.value.avatar =
          await CloudinaryController().uploadImage(filePathAvatar,
              '${buyer.username}_avatar', 'buyer/${buyer.username}');
    }
    if (filePathCover != '') {
      Get.find<MainController>().buyer.value.cover =
          await CloudinaryController().uploadImage(filePathCover,
              '${buyer.username}_cover', 'buyer/${buyer.username}');
    }
    await buyerCollection
        .doc(buyer.id)
        .update(Get.find<MainController>().buyer.value.toVal());
    isLoading.value = false;
  }
}
