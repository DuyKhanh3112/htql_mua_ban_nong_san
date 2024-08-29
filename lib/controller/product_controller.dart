import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convert_vietnamese/convert_vietnamese.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/category_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/cloudinary_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/review_controller.dart';
import 'package:htql_mua_ban_nong_san/models/category.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';
import 'package:htql_mua_ban_nong_san/models/product_image.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';

class ProductController extends GetxController {
  static ProductController get to => Get.find<ProductController>();
  RxBool isLoading = false.obs;

  CollectionReference productCollection =
      FirebaseFirestore.instance.collection('Product');
  CollectionReference provinceCollection =
      FirebaseFirestore.instance.collection('Province');
  CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('Category');
  CollectionReference productImageCollection =
      FirebaseFirestore.instance.collection('ProductImage');
  CollectionReference sellerCollection =
      FirebaseFirestore.instance.collection('Seller');

  RxList<Product> listProduct = <Product>[].obs;
  RxList<Category> listCategory = <Category>[].obs;
  RxList<Province> listProvince = <Province>[].obs;
  RxList<ProductImage> listProductImage = <ProductImage>[].obs;
  RxList<Seller> listSeller = <Seller>[].obs;

  Rx<Category> category = Category.initCategory().obs;
  Rx<Province> province = Province.initProvince().obs;
  Rx<Product> product = Product.initProduct().obs;

  Rx<TextEditingController> searchProductController =
      TextEditingController().obs;

  RxInt indexProductPage = 0.obs;

  RxList<dynamic> listStatus = [
    {'value': 'draft', 'label': 'Chờ duyệt'},
    {'value': 'active', 'label': 'Còn hàng'},
    {'value': 'inactive', 'label': 'Hêt hàng'},
    {'value': 'hide', 'label': 'Ẩn'},
    {'value': 'lock', 'label': 'Vi phạm'}
  ].obs;

  Future<void> updateProduct(Product pro) async {
    isLoading.value = true;
    if (pro.quantity == 0 && pro.status == 'active') {
      pro.status = 'inactive';
    }
    if (pro.quantity != 0 && pro.status == 'inactive') {
      pro.status = 'active';
    }
    // if (pro.status == 'lock') {
    //   pro.status = 'draft';
    // }

    await productCollection.doc(pro.id).update(pro.toVal());
    await loadAllProduct();
    isLoading.value = false;
  }

  Future<void> deleteProduct(Product pro) async {
    isLoading.value = true;
    await productCollection.doc(pro.id).delete();
    await loadProductBySeller();
    isLoading.value = false;
  }

  Future<void> loadProductBySeller() async {
    listProduct.value = [];
    listProductImage.value = [];
    final snapshotProduct = await productCollection
        .where('seller_id',
            isEqualTo: Get.find<MainController>().seller.value.id)
        .get();
    for (var item in snapshotProduct.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listProduct.add(Product.fromJson(data));

      final snapshotImg = await productImageCollection
          .where('product_id', isEqualTo: item.id)
          .get();
      for (var img in snapshotImg.docs) {
        Map<String, dynamic> dataImg = img.data() as Map<String, dynamic>;
        dataImg['id'] = img.id;
        listProductImage.add(ProductImage.fromJson(dataImg));
      }
    }
  }

  Future<void> loadAllProduct() async {
    isLoading.value = true;
    listProduct.value = [];
    listProductImage.value = [];
    final snapshotProduct = await productCollection.get();
    for (var item in snapshotProduct.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      data['sale_num'] =
          await Get.find<OrderController>().getNumOfSale(data['id']);
      data['ratting'] =
          await Get.find<ReviewController>().getRatting(data['id']);

      listProduct.add(Product.fromJson(data));

      final snapshotImg = await productImageCollection
          .where('product_id', isEqualTo: item.id)
          .get();
      for (var img in snapshotImg.docs) {
        Map<String, dynamic> dataImg = img.data() as Map<String, dynamic>;
        dataImg['id'] = img.id;
        listProductImage.add(ProductImage.fromJson(dataImg));
      }
    }
    listProduct.sort((a, b) => b.create_at.compareTo(a.create_at));
    isLoading.value = false;
  }

  Future<void> loadProductActive() async {
    listProduct.value = [];
    listProductImage.value = [];
    final snapshotProduct =
        await productCollection.where('status', isEqualTo: 'active').get();
    for (var item in snapshotProduct.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      data['sale_num'] =
          await Get.find<OrderController>().getNumOfSale(data['id']);
      data['ratting'] =
          await Get.find<ReviewController>().getRatting(data['id']);

      listProduct.add(Product.fromJson(data));

      final snapshotImg = await productImageCollection
          .where('product_id', isEqualTo: item.id)
          .get();
      for (var img in snapshotImg.docs) {
        Map<String, dynamic> dataImg = img.data() as Map<String, dynamic>;
        dataImg['id'] = img.id;
        listProductImage.add(ProductImage.fromJson(dataImg));
      }
    }
    listProduct.sort((a, b) => b.create_at.compareTo(a.create_at));
  }

  Future<void> loadData() async {
    isLoading.value = true;

    await loadSeller();

    listCategory.value = [];
    await Get.find<CategoryController>().loadCategory();
    listCategory.value = Get.find<CategoryController>().listCategory;

    listProvince.value = [];
    final snapshotProvince = await provinceCollection.get();
    for (var item in snapshotProvince.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;

      data['id'] = item.id;
      listProvince.add(Province.fromJson(data));
    }
    listProvince.sort(
        (a, b) => removeDiacritics(a.name).compareTo(removeDiacritics(b.name)));

    listCategory.sort(
        (a, b) => removeDiacritics(a.name).compareTo(removeDiacritics(b.name)));
    await loadProductBySeller();
    isLoading.value = false;
  }

  Future<void> loadSeller() async {
    listSeller.value = [];
    final snapshotSeller = await sellerCollection.get();
    for (var item in snapshotSeller.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listSeller.add(Seller.fromJson(data));
    }
  }

  Future<void> loadAllData() async {
    isLoading.value = true;

    await loadSeller();

    await loadCategory();

    await loadProvince();

    await loadAllProduct();
    isLoading.value = false;
  }

  Future<void> loadCategory() async {
    listCategory.value = [];
    await Get.find<CategoryController>().loadCategory();
    listCategory.value = Get.find<CategoryController>().listCategory;
  }

  Future<void> loadProvince() async {
    listProvince.value = [];
    final snapshotProvince = await provinceCollection.get();
    for (var item in snapshotProvince.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;

      data['id'] = item.id;
      listProvince.add(Province.fromJson(data));
    }
    listProvince.sort((a, b) => removeDiacritics(a.name.toLowerCase())
        .compareTo(removeDiacritics(b.name.toLowerCase())));
  }

  Future<void> createProduct(List<dynamic> listFilePath) async {
    isLoading.value = true;
    WriteBatch batch = FirebaseFirestore.instance.batch();
    String productID = productCollection.doc().id;
    DocumentReference refPrduct = productCollection.doc(productID);

    batch.set(refPrduct, product.value.toVal());

    for (var path in listFilePath) {
      DocumentReference refImg =
          productImageCollection.doc(productImageCollection.doc().id);

      String? url = await CloudinaryController().uploadImage(
          path['path'], productImageCollection.doc().id, 'product/$productID/');
      if (url != null) {
        ProductImage productImage = ProductImage(
            id: '',
            product_id: productID,
            image: url,
            is_default: path['is_defalut']);
        batch.set(refImg, productImage.toVal());
      }
    }
    await batch.commit();
    await loadProductBySeller();
    isLoading.value = false;
  }
}
