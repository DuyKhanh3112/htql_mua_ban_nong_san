import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/cloudinary_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
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

  Future<void> updateInformation(
      String filePathCover, String filePathAvatar) async {
    isLoading.value = true;
    Admin admin = Get.find<MainController>().admin.value;
    if (filePathCover != '') {
      Get.find<MainController>().admin.value.cover =
          await CloudinaryController().uploadImage(filePathAvatar,
              '${admin.username}_cover', 'admin/${admin.username}');
    }
    if (filePathAvatar != '') {
      Get.find<MainController>().admin.value.avatar =
          await CloudinaryController().uploadImage(filePathAvatar,
              '${admin.username}_cover', 'admin/${admin.username}');
    }

    await adminCollection
        .doc(Get.find<MainController>().admin.value.id)
        .update(Get.find<MainController>().admin.value.toVal());
    isLoading.value = false;
  }
}
