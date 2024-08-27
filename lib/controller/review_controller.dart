import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  static ReviewController get to => Get.find<ReviewController>();
  RxBool isLoading = false.obs;
  CollectionReference reviewCollection =
      FirebaseFirestore.instance.collection('Review');
  CollectionReference orderDetailCollection =
      FirebaseFirestore.instance.collection('OrderDetail');
  Future<double> getRatting(String productId) async {
    double count = 0;
    double ratting = 0;

    final snapshootOrderDetail = await orderDetailCollection
        .where('product_id', isEqualTo: productId)
        .get();

    for (var itemODD in snapshootOrderDetail.docs) {
      final snapshootReview = await reviewCollection
          .where('order_detail_id', isEqualTo: itemODD.id)
          .get();
      for (var item in snapshootReview.docs) {
        Map<String, dynamic> data = item.data() as Map<String, dynamic>;
        count += 1;
        ratting += ratting;
      }
    }
    if (count != 0) {
      return ratting / count;
    }
    return 4;
  }
}
