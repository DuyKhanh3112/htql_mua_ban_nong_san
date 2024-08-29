import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/models/order_detail.dart';

class OrderController extends GetxController {
  static OrderController get to => Get.find<OrderController>();
  RxBool isLoading = false.obs;

  RxList<dynamic> listStatus = [
    {'value': 'unconfirm', 'label': 'Chờ xác nhận'},
    {'value': 'delivering', 'label': 'Đang giao'},
    {'value': 'delivered', 'label': 'Đã giao'},
    {'value': 'cancelled', 'label': 'Đã hủy'},
    {'value': 'fail', 'label': 'Không nhận'}
  ].obs;
  RxInt orderIndex = 0.obs;

  CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('Order');
  CollectionReference orderDetailCollection =
      FirebaseFirestore.instance.collection('OrderDetail');

  RxList<Order> listOrder = <Order>[].obs;
  RxList<OrderDetail> listOrderDetail = <OrderDetail>[].obs;

  Future<double> getNumOfSale(String productID) async {
    double count = 0;
    final snapshootOrderDetail = await orderDetailCollection
        .where('product_id', isEqualTo: productID)
        .get();
    for (var item in snapshootOrderDetail.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      // data['id']= item.id;
      // OrderDetail odd = OrderDetail.fromJson(data);
      count += data['quantity'];
    }
    return count;
  }
}
