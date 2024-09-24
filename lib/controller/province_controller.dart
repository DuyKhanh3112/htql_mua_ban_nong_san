import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convert_vietnamese/convert_vietnamese.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';

class ProvinceController extends GetxController {
  static ProvinceController get to => Get.find<ProvinceController>();
  RxBool isLoading = false.obs;
  CollectionReference provinceCollection =
      FirebaseFirestore.instance.collection('Province');
  RxList<Province> listProvince = <Province>[].obs;

  Future<void> loadProvince() async {
    Get.find<ProvinceController>().listProvince.value = [];
    final snapshotProvince = await provinceCollection.get();
    for (var item in snapshotProvince.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;

      data['id'] = item.id;
      listProvince.add(Province.fromJson(data));
    }
    listProvince.sort(
        (a, b) => removeDiacritics(a.name).compareTo(removeDiacritics(b.name)));
  }
}
