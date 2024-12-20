import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/cloudinary_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';

class SellerController extends GetxController {
  static SellerController get to => Get.find<SellerController>();

  RxList<dynamic> listStatus = [
    {
      'value': 'draft',
      'label': 'Đang chờ duyệt',
      'color': Colors.grey,
    },
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

  CollectionReference sellerCollection =
      FirebaseFirestore.instance.collection('Seller');

  RxList<Seller> listSeller = <Seller>[].obs;
  RxInt indexSeller = 0.obs;

  RxBool isLoading = false.obs;
  Rx<Seller> seller = Seller.initSeller().obs;

  Future<void> getSeller(String id) async {
    isLoading.value = true;
    final snapshot = await sellerCollection.doc(id).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    data['id'] = id;
    seller.value = Seller.fromJson(data);
    isLoading.value = false;
  }

  double getRatting() {
    double count = 0;
    double ratting = 0;
    for (var item in Get.find<ProductController>()
        .listProduct
        .where((p0) => p0.seller_id == seller.value.id)) {
      if ((item.sale_num ?? 0) > 0 && (item.ratting ?? 0) > 0) {
        count += 1;
        ratting += item.ratting!;
      }
    }
    if (count == 0) {
      return 0;
    }
    return ratting / count;
  }

  double getSaleNum() {
    double count = 0;
    for (var item in Get.find<ProductController>()
        .listProduct
        .where((p0) => p0.seller_id == seller.value.id)) {
      count += item.sale_num ?? 0;
    }
    return count;
  }

  Future<void> updateSeller(Seller seller) async {
    isLoading.value = true;
    // await buyerCollection.doc(buyer.id).update(buyer.toVal());
    await sellerCollection.doc(seller.id).update(seller.toVal());
    if (seller.status != 'inactive' &&
        await Get.find<ProductController>().getProductLock(seller.id) >= 3) {
      seller.status = 'warning';
    }
    isLoading.value = false;
  }

  Future<void> loadSeller() async {
    isLoading.value = true;
    listSeller.value = [];
    final snapshotSeller =
        await sellerCollection.where('status', isEqualTo: 'active').get();
    for (var item in snapshotSeller.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listSeller.add(Seller.fromJson(data));
    }
    isLoading.value = false;
  }

  Future<void> loadAllSeller() async {
    isLoading.value = true;
    listSeller.value = [];
    final snapshotSeller = await sellerCollection.get();
    for (var item in snapshotSeller.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      int countLock =
          await Get.find<ProductController>().getProductLock(item.id);
      if (countLock >= 3 && data['status'] != 'inactive') {
        data['status'] = 'warning';
      }
      listSeller.add(Seller.fromJson(data));
    }
    isLoading.value = false;
  }

  Future<void> createSeller(Seller seller) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    String newSellerID = sellerCollection.doc().id;

    DocumentReference refSeller = sellerCollection.doc(newSellerID);

    batch.set(refSeller, seller.toVal());

    await batch.commit();
  }

  Future<bool> checkExistUsername(String username) async {
    final snapshot =
        await sellerCollection.where('username', isEqualTo: username).get();
    if (snapshot.docs.isEmpty) {
      return false;
    }
    return true;
  }

  Future<bool> checkExistEmail(String email) async {
    final snapshot =
        await sellerCollection.where('email', isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      return false;
    }
    return true;
  }

  Future<bool> checkExistPhone(String phone) async {
    final snapshot =
        await sellerCollection.where('phone', isEqualTo: phone).get();
    if (snapshot.docs.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> forgotPassword(String email, String password) async {
    isLoading.value = true;
    final snapshot =
        await sellerCollection.where('email', isEqualTo: email).get();
    for (var item in snapshot.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      data['password'] = password;

      Seller seller = Seller.fromJson(data);
      await sellerCollection.doc(seller.id).update(seller.toJson());
    }
    isLoading.value = false;
  }

  Future<void> updateInformation(
      String filePathAvatar, String filePathCover) async {
    isLoading.value = true;
    Seller seller = Get.find<MainController>().seller.value;
    if (filePathAvatar != '') {
      Get.find<MainController>().seller.value.avatar =
          await CloudinaryController().uploadImage(filePathAvatar,
              '${seller.username}_avatar', 'seller/${seller.username}');
    }
    if (filePathCover != '') {
      Get.find<MainController>().seller.value.cover =
          await CloudinaryController().uploadImage(filePathCover,
              '${seller.username}_cover', 'seller/${seller.username}');
    }
    await sellerCollection
        .doc(seller.id)
        .update(Get.find<MainController>().seller.value.toVal());
    isLoading.value = false;
  }

  Future<void> updatePassword(Seller seller) async {
    isLoading.value = true;
    await sellerCollection.doc(seller.id).update(seller.toVal());

    isLoading.value = false;
  }
}
