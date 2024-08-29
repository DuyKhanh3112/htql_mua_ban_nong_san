import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/models/admin.dart';

class AdminController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt numPage = 0.obs;
  CollectionReference adminCollection =
      FirebaseFirestore.instance.collection('Admin');

  Future<void> updateAdmin(Admin admin) async {
    isLoading.value = true;

    await adminCollection.doc(admin.id).update(admin.toVal());
    isLoading.value = false;
  }
}
