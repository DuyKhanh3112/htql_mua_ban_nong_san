import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convert_vietnamese/convert_vietnamese.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/models/category.dart';

class CategoryController extends GetxController {
  static CategoryController get to => Get.find<CategoryController>();
  RxBool isLoading = false.obs;
  CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('Category');

  RxList<Category> listCategory = <Category>[].obs;

  Future<void> createCategory(Category category) async {
    isLoading.value = true;
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference refBuyer =
        categoryCollection.doc(categoryCollection.doc().id);
    batch.set(refBuyer, category.toVal());
    await batch.commit();
    await loadCategory();
    isLoading.value = false;
  }

  Future<void> updateCategory(Category category) async {
    isLoading.value = true;
    await categoryCollection.doc(category.id).update(category.toVal());
    isLoading.value = false;
  }

  Future<void> deleteCategory(Category category) async {
    isLoading.value = true;
    await categoryCollection.doc(category.id).delete();
    await loadCategory();
    isLoading.value = false;
  }

  Future<void> loadCategory() async {
    isLoading.value = true;
    listCategory.value = [];
    final snapshot = await categoryCollection.get();
    for (var item in snapshot.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listCategory.add(Category.fromJson(data));
    }
    listCategory.sort((a, b) => removeDiacritics(a.name.toLowerCase().trim())
        .compareTo(removeDiacritics(b.name.toLowerCase().trim())));
    isLoading.value = false;
  }
}
