import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/models/address.dart';

class AddressController extends GetxController {
  static AddressController get to => Get.find<AddressController>();
  RxBool isLoading = false.obs;
  CollectionReference addressCollection =
      FirebaseFirestore.instance.collection('Address');

  RxList<Address> listAddress = <Address>[].obs;
  Rx<Address> address = Address.initAddress().obs;

  Future<void> loadAddressBuyer() async {
    isLoading.value = true;
    listAddress.value = [];
    final snapshoot = await addressCollection
        .where('buyer_id', isEqualTo: Get.find<MainController>().buyer.value.id)
        .get();
    for (var item in snapshoot.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;

      listAddress.add(Address.fromJson(data));
    }
    isLoading.value = false;
  }

  Future<void> createAddress(Address add) async {
    isLoading.value = true;
    WriteBatch batch = FirebaseFirestore.instance.batch();
    if (listAddress.isEmpty) {
      add.is_default = true;
    }
    DocumentReference refAddress =
        addressCollection.doc(addressCollection.doc().id);
    batch.set(refAddress, add.toVal());
    await batch.commit();
    await loadAddressBuyer();
    isLoading.value = false;
  }

  Future<void> updateAddress(Address add) async {
    isLoading.value = true;
    await addressCollection.doc(add.id).update(add.toVal());
    await loadAddressBuyer();
    isLoading.value = false;
  }

  Future<void> setDefault(Address add) async {
    isLoading.value = true;
    for (var item in listAddress.where((p0) =>
        p0.id != add.id &&
        p0.buyer_id == Get.find<MainController>().buyer.value.id)) {
      item.is_default = false;
      await addressCollection.doc(item.id).update(item.toVal());
    }
    add.is_default = true;
    await addressCollection.doc(add.id).update(add.toVal());
    await loadAddressBuyer();
    isLoading.value = false;
  }
}
