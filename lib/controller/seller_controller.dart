import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';

class SellerController extends GetxController {
  static SellerController get to => Get.find<SellerController>();

  CollectionReference sellerCollection =
      FirebaseFirestore.instance.collection('Seller');

  RxList<Seller> listSeller = <Seller>[].obs;

  RxBool isLoading = false.obs;

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
}
