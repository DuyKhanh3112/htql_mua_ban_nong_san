import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/buyer_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/category_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/cloudinary_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/review_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/models/category.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';
import 'package:htql_mua_ban_nong_san/models/product_image.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';

class ProductController extends GetxController {
  static ProductController get to => Get.find<ProductController>();
  RxBool isLoading = false.obs;

  CollectionReference productCollection =
      FirebaseFirestore.instance.collection('Product');

  CollectionReference productImageCollection =
      FirebaseFirestore.instance.collection('ProductImage');
  CollectionReference sellerCollection =
      FirebaseFirestore.instance.collection('Seller');

  RxList<Product> listProduct = <Product>[].obs;

  RxList<ProductImage> listProductImage = <ProductImage>[].obs;

  Rx<Category> category = Category.initCategory().obs;
  Rx<Province> province = Province.initProvince().obs;
  Rx<Product> product = Product.initProduct().obs;

  Rx<TextEditingController> searchProductController =
      TextEditingController().obs;

  RxInt indexProductPage = 0.obs;

  RxList<dynamic> listStatus = [
    {'value': 'draft', 'label': 'Chờ duyệt', 'color': Colors.grey},
    {'value': 'active', 'label': 'Còn hàng', 'color': Colors.green},
    {'value': 'inactive', 'label': 'Hêt hàng', 'color': Colors.orange},
    {'value': 'hide', 'label': 'Ẩn', 'color': Colors.blue},
    {'value': 'lock', 'label': 'Vi phạm', 'color': Colors.red}
  ].obs;

  Rx<String> sortType = ''.obs;

  Future<void> updateProduct(Product pro) async {
    isLoading.value = true;
    if (pro.quantity == 0 && pro.status == 'active') {
      pro.status = 'inactive';
    }
    if (pro.quantity != 0 && pro.status == 'inactive') {
      pro.status = 'active';
    }

    await productCollection.doc(pro.id).update(pro.toVal());
    // await loadProductByIDServer(pro.id);
    listProductImage.removeWhere(
      (element) => element.product_id == pro.id,
    );
    loadProductImage(pro.id);
    isLoading.value = false;
  }

  Future<void> deleteProductImg(ProductImage proImg) async {
    isLoading.value = true;
    await CloudinaryController()
        .deleteImage(proImg.id, 'product/${proImg.product_id}/');
    await productImageCollection.doc(proImg.id).delete();

    isLoading.value = false;
  }

  Future<void> deleteProduct(Product pro) async {
    isLoading.value = true;
    await productCollection.doc(pro.id).delete();
    await loadProductBySeller();
    isLoading.value = false;
  }

  Future<void> loadProductBySeller() async {
    isLoading.value = true;
    // listProduct.value = [];
    // listProductImage.value = [];
    final snapshotProduct = await productCollection
        .where('seller_id',
            isEqualTo: Get.find<MainController>().seller.value.id)
        .where('category_id',
            whereIn: Get.find<CategoryController>()
                .listCategory
                .where((p0) => p0.hide == false)
                .map((element) => element.id)
                .toList())
        .get();
    for (var item in snapshotProduct.docs.where((element) => listProduct
        .where(
          (p0) => p0.id == element.id,
        )
        .isEmpty)) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;

      data['id'] = item.id;
      data['sale_num'] =
          await Get.find<OrderController>().getNumOfSale(data['id']);
      data['ratting'] =
          await Get.find<ReviewController>().getRatting(data['id']);
      listProduct.add(Product.fromJson(data));
      loadProductImage(item.id);
    }
    isLoading.value = false;
  }

  // Future<void> loadProductAllBySeller() async {
  //   isLoading.value = true;
  //   listProduct.value = [];
  //   listProductImage.value = [];
  //   final snapshotProduct = await productCollection
  //       .where('seller_id',
  //           isEqualTo: Get.find<MainController>().seller.value.id)
  //       .where('category_id',
  //           whereIn: Get.find<CategoryController>()
  //               .listCategory
  //               .where((p0) => p0.hide == false)
  //               .map((element) => element.id)
  //               .toList())
  //       .get();
  //   for (var item in snapshotProduct.docs) {
  //     Map<String, dynamic> data = item.data() as Map<String, dynamic>;
  //     data['id'] = item.id;
  //     data['sale_num'] =
  //         await Get.find<OrderController>().getNumOfSale(data['id']);
  //     data['ratting'] =
  //         await Get.find<ReviewController>().getRatting(data['id']);
  //     listProduct.add(Product.fromJson(data));
  //     await loadProductImage(item.id);
  //   }
  //   isLoading.value = false;
  // }

  Future<void> loadProductActiveBySeller() async {
    isLoading.value = true;
    listProduct.value = [];
    listProductImage.value = [];
    final snapshotProduct = await productCollection
        .where('seller_id',
            isEqualTo: Get.find<MainController>().seller.value.id)
        .where('category_id',
            whereIn: Get.find<CategoryController>()
                .listCategory
                .where((p0) => p0.hide == false)
                .map((element) => element.id)
                .toList())
        .where('status', isEqualTo: 'active')
        .get();
    for (var item in snapshotProduct.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;

      data['id'] = item.id;
      data['sale_num'] =
          await Get.find<OrderController>().getNumOfSale(data['id']);
      data['ratting'] =
          await Get.find<ReviewController>().getRatting(data['id']);
      listProduct.add(Product.fromJson(data));

      loadProductImage(item.id);
    }
    isLoading.value = false;
  }

  Future<int> getProductLock(String sellerID) async {
    final snapshotProduct = await productCollection
        .where('seller_id', isEqualTo: sellerID)
        .where('status', isEqualTo: 'lock')
        .get();
    return snapshotProduct.docs.length;
  }

  Future<void> loadProductImage(String productId) async {
    final snapshotImg = await productImageCollection
        .where('product_id', isEqualTo: productId)
        .get();
    for (var img in snapshotImg.docs) {
      Map<String, dynamic> dataImg = img.data() as Map<String, dynamic>;
      dataImg['id'] = img.id;
      listProductImage.add(ProductImage.fromJson(dataImg));
    }
  }

  Future<void> loadAllProduct() async {
    isLoading.value = true;
    // listProduct.value = [];
    // listProductImage.value = [];
    final snapshotProduct = await productCollection
        // .where('status', isEqualTo: 'active')
        .where('seller_id',
            whereIn: Get.find<SellerController>()
                .listSeller
                .map((element) => element.id)
                .toList())
        .get();
    for (var item in snapshotProduct.docs.where(
      (element) => listProduct
          .where(
            (p0) => p0.id == element.id,
          )
          .isEmpty,
    )) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;

      data['id'] = item.id;
      data['sale_num'] =
          await Get.find<OrderController>().getNumOfSale(data['id']);
      data['ratting'] =
          await Get.find<ReviewController>().getRatting(data['id']);

      listProduct.add(Product.fromJson(data));

      loadProductImage(item.id);
    }
    listProduct.sort((a, b) => b.create_at.compareTo(a.create_at));
    isLoading.value = false;
  }

  Future<void> loadProductActive() async {
    isLoading.value = true;
    // listProduct.value = [];
    // listProductImage.value = [];
    final snapshotProduct = await productCollection
        .where('status', isEqualTo: 'active')
        .where('category_id',
            whereIn: Get.find<CategoryController>()
                .listCategory
                .where((p0) => p0.hide == false)
                .map((element) => element.id)
                .toList())
        .get();
    for (var item in snapshotProduct.docs.where((element) =>
        Get.find<SellerController>()
            .listSeller
            .map((element) => element.id)
            .toList()
            .contains((element.data() as Map<String, dynamic>)['seller_id']) &&
        listProduct
            .where(
              (p0) => p0.id == element.id,
            )
            .isEmpty)) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;

      data['id'] = item.id;
      data['sale_num'] =
          await Get.find<OrderController>().getNumOfSale(data['id']);
      data['ratting'] =
          await Get.find<ReviewController>().getRatting(data['id']);

      listProduct.add(Product.fromJson(data));

      loadProductImage(item.id);
    }
    listProduct.sort((a, b) => b.create_at.compareTo(a.create_at));
    isLoading.value = false;
  }

  Future<void> createProduct(List<dynamic> listFilePath) async {
    isLoading.value = true;
    WriteBatch batch = FirebaseFirestore.instance.batch();
    String productID = productCollection.doc().id;
    DocumentReference refPrduct = productCollection.doc(productID);

    batch.set(refPrduct, product.value.toVal());

    await createProductImage(listFilePath, productID);
    await batch.commit();
    await loadProductBySeller();
    isLoading.value = false;
  }

  Future<void> createProductImage(
      List<dynamic> listFilePath, String productID) async {
    isLoading.value = true;
    WriteBatch batch = FirebaseFirestore.instance.batch();
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
    isLoading.value = false;
  }

  Future<void> loadProductByID(String id) async {
    var snap = await productCollection.doc(id).get();
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    data['id'] = snap.id;
    Product pro = Product.fromJson(data);
    pro.id = id;
    pro.sale_num = await Get.find<OrderController>().getNumOfSale(data['id']);
    pro.ratting = await Get.find<ReviewController>().getRatting(data['id']);
    listProduct.remove(
        listProduct.firstWhereOrNull((element) => element.id == id) ??
            Product.initProduct());
    listProduct.add(pro);
  }

  Future<void> loadProductBoughtByBuyer() async {
    isLoading.value = true;
    var snapOrder = await Get.find<OrderController>()
        .orderCollection
        .where('buyer_id', isEqualTo: Get.find<MainController>().buyer.value.id)
        .get();
    for (var order in snapOrder.docs) {
      if (Get.find<BuyerController>().listProductBought.length < 5) {
        Map<String, dynamic> dataOrder = order.data() as Map<String, dynamic>;
        var snapODD = await Get.find<OrderController>()
            .orderDetailCollection
            .where('order_id', isEqualTo: order.id)
            .get();
        for (var odd in snapODD.docs) {
          if (Get.find<BuyerController>().listProductBought.length < 5) {
            Map<String, dynamic> dataOdd = odd.data() as Map<String, dynamic>;

            if (Get.find<BuyerController>()
                .listProductBought
                .where((p0) => p0.id == dataOdd['product_id'])
                .isEmpty) {
              if (listProduct
                  .where((p0) => p0.id == dataOdd['product_id'])
                  .isNotEmpty) {
                for (var pro in listProduct
                    .where((p0) => p0.id == dataOdd['product_id'])) {
                  pro.create_at = dataOrder['update_at'];
                  Get.find<BuyerController>().listProductBought.add(pro);
                }
              } else {
                var snapProduct =
                    await productCollection.doc(dataOdd['product_id']).get();
                Map<String, dynamic> data =
                    snapProduct.data() as Map<String, dynamic>;
                if (Get.find<CategoryController>()
                        .listCategory
                        .where((p0) => p0.id == data['category_id'])
                        .isNotEmpty &&
                    Get.find<SellerController>()
                        .listSeller
                        .where((p0) => p0.id == data['seller_id'])
                        .isNotEmpty &&
                    data['status'] == 'active') {
                  data['create_at'] = dataOrder['update_at'];
                  data['id'] = snapProduct.id;
                  data['sale_num'] = await Get.find<OrderController>()
                      .getNumOfSale(data['id']);
                  data['ratting'] =
                      await Get.find<ReviewController>().getRatting(data['id']);
                  Get.find<BuyerController>()
                      .listProductBought
                      .add(Product.fromJson(data));
                }
              }
            }
          } else {
            break;
          }
        }
      } else {
        break;
      }
    }
    Get.find<BuyerController>()
        .listProductBought
        .sort((b, a) => a.create_at.compareTo(b.create_at));
    isLoading.value = false;
  }
}
