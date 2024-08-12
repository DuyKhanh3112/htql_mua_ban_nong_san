import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:htql_mua_ban_nong_san/models/buyer.dart';

class BuyerController extends GetxController {
  static BuyerController get to => Get.find<BuyerController>();

  CollectionReference buyerCollection =
      FirebaseFirestore.instance.collection('Buyer');

  RxBool isLoading = false.obs;

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
}
