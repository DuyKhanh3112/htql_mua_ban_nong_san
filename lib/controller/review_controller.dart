import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/buyer_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/models/order.dart';
import 'package:htql_mua_ban_nong_san/models/review.dart';

class ReviewController extends GetxController {
  static ReviewController get to => Get.find<ReviewController>();
  RxBool isLoading = false.obs;
  CollectionReference reviewCollection =
      FirebaseFirestore.instance.collection('Review');
  Rx<Review> review = Review.initReview().obs;
  RxList<Review> listReview = <Review>[].obs;

  Future<void> createReview(Review re) async {
    isLoading.value = true;
    WriteBatch batch = FirebaseFirestore.instance.batch();
    re.id = reviewCollection.doc().id;
    DocumentReference refReview = reviewCollection.doc(re.id);
    batch.set(refReview, re.toVal());
    await batch.commit();
    await Get.find<OrderController>().loadOrderDetailByOrder(
        Get.find<OrderController>()
                .listOrder
                .firstWhereOrNull((element) => element.id == re.order_id) ??
            Orders.initOrder());
    for (var odd in Get.find<OrderController>()
        .listOrderDetail
        .where((p0) => p0.order_id == re.order_id)) {
      for (var product in Get.find<ProductController>()
          .listProduct
          .where((p0) => p0.id == odd.product_id)) {
        product.ratting = await getRatting(product.id);
      }
    }
    listReview.add(re);
    isLoading.value = false;
  }

  Future<void> updateReview(Review re) async {
    isLoading.value = true;
    await reviewCollection.doc(re.id).update(re.toVal());

    listReview.removeWhere((element) => element.id == re.id);
    listReview.add(re);
    await Get.find<OrderController>().loadOrderDetailByOrder(
        Get.find<OrderController>()
                .listOrder
                .firstWhereOrNull((element) => element.id == re.order_id) ??
            Orders.initOrder());
    for (var odd in Get.find<OrderController>()
        .listOrderDetail
        .where((p0) => p0.order_id == re.order_id)) {
      for (var product in Get.find<ProductController>()
          .listProduct
          .where((p0) => p0.id == odd.product_id)) {
        product.ratting = await getRatting(product.id);
      }
    }
    isLoading.value = false;
  }

  Future<void> loadReviewByOrderID(String orderId) async {
    // isLoading.value = true;
    final snapshot =
        await reviewCollection.where('order_id', isEqualTo: orderId).get();

    for (var item in snapshot.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listReview.add(Review.fromJson(data));
    }
    // isLoading.value = false;
  }

  Future<void> loadReviewByProductID(String productID) async {
    isLoading.value = true;
    listReview.value = [];
    Get.find<BuyerController>().listBuyer.value = [];
    Get.find<OrderController>().listOrder.value = [];

    final snapOdd = await Get.find<OrderController>()
        .orderDetailCollection
        .where('product_id', isEqualTo: productID)
        .get();

    for (var odd in snapOdd.docs) {
      String orderId = (odd.data() as Map<String, dynamic>)['order_id'];
      await loadReviewByOrderID(orderId);
      // final snapOrder =
      //     await Get.find<OrderController>().orderCollection.doc(orderId).get();
      // Map<String, dynamic> dataOrder = snapOrder.data() as Map<String, dynamic>;
      // dataOrder['id'] = orderId;
      // await Get.find<BuyerController>()
      //     .loadBuyerByID(Orders.fromJson(dataOrder).buyer_id);
      // await Get.find<OrderController>().loadOrderByID(orderId);
    }

    for (var review in listReview) {
      await Get.find<OrderController>().loadOrderByID(review.order_id);
    }
    isLoading.value = false;
  }

  Future<double> getRatting(String productId) async {
    double count = 0;
    double ratting = 0;
    List<String> listOrder = [];

    final snapshootOrderDetail = await Get.find<OrderController>()
        .orderDetailCollection
        .where('product_id', isEqualTo: productId)
        .get();

    for (var itemODD in snapshootOrderDetail.docs) {
      Map<String, dynamic> odd = itemODD.data() as Map<String, dynamic>;
      if (!listOrder.contains(odd['order_id'])) {
        final snapshotOrder = await Get.find<OrderController>()
            .orderCollection
            .doc(odd['order_id'])
            .get();
        final snapshootReview = await reviewCollection
            .where('order_id', isEqualTo: snapshotOrder.id)
            .get();
        for (var item in snapshootReview.docs) {
          Map<String, dynamic> data = item.data() as Map<String, dynamic>;
          count += 1;
          ratting += data['ratting'];
        }
      }
    }
    if (count != 0) {
      return ratting / count;
    }
    return 0;
  }
}
