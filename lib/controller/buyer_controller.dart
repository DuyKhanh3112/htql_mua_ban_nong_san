import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/cart_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/models/buyer.dart';

class BuyerController extends GetxController {
  static BuyerController get to => Get.find<BuyerController>();

  CollectionReference buyerCollection =
      FirebaseFirestore.instance.collection('Buyer');

  RxList<Buyer> listBuyer = <Buyer>[].obs;

  RxBool isLoading = false.obs;
  RxList<int> listCart = <int>[].obs;

  Future<void> loadBuyer() async {
    isLoading.value = true;
    listBuyer.value = [];
    final snapshot = await buyerCollection.get();
    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          snapshot.docs[0].data() as Map<String, dynamic>;

      data['id'] = snapshot.docs[0].id;
      data['rate_order'] = await Get.find<OrderController>()
          .getRateSuccessByBuyer(snapshot.docs[0].id);

      listBuyer.add(Buyer.fromJson(data));
    }

    isLoading.value = false;
  }

  Future<void> createBuyer(
    Buyer buyer,
  ) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    String newBuyerID = buyerCollection.doc().id;
    // DocumentReference refProgram = programsCollection.doc(newProgramId);
    // batch.set(refProgram, newProgram.toJson());
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

    await Get.find<CartController>().saveCart();
    Get.find<MainController>().buyer.value = Buyer.initBuyer();
    Get.find<MainController>().numPage.value = 0;
    Get.toNamed('/');
    isLoading.value = false;
  }
}
