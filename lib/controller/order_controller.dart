import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/address_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/buyer_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/cart_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/models/address.dart';
import 'package:htql_mua_ban_nong_san/models/cart.dart';
import 'package:htql_mua_ban_nong_san/models/order.dart';
import 'package:htql_mua_ban_nong_san/models/order_detail.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';
import 'package:htql_mua_ban_nong_san/models/product_image.dart';

class OrderController extends GetxController {
  static OrderController get to => Get.find<OrderController>();
  RxBool isLoading = false.obs;

  RxList<dynamic> listStatus = [
    {'value': 'unconfirm', 'label': 'Chờ xác nhận'},
    {'value': 'delivering', 'label': 'Đang giao'},
    {'value': 'delivered', 'label': 'Đã giao'},
    {'value': 'cancelled', 'label': 'Đã hủy'},
    {'value': 'failed', 'label': 'Không nhận'}
  ].obs;
  RxInt orderIndex = 0.obs;

  CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('Order');
  CollectionReference orderDetailCollection =
      FirebaseFirestore.instance.collection('OrderDetail');

  RxList<Orders> listOrder = <Orders>[].obs;
  RxList<OrderDetail> listOrderDetail = <OrderDetail>[].obs;

  Rx<Orders> order = Orders.initOrder().obs;
  Rx<Address> address = Address.initAddress().obs;
  RxList<Product> listProduct = <Product>[].obs;
  RxList<ProductImage> listProductImage = <ProductImage>[].obs;

  Future<void> loadOrderByBuyer() async {
    isLoading.value = true;
    listOrder.value = [];
    final snapOrder = await orderCollection
        .where('buyer_id', isEqualTo: Get.find<MainController>().buyer.value.id)
        .get();
    for (var od in snapOrder.docs) {
      Map<String, dynamic> dataOrder = od.data() as Map<String, dynamic>;
      dataOrder['id'] = od.id;
      listOrder.add(Orders.fromJson(dataOrder));
    }

    listOrder.sort((a, b) => b.update_at.compareTo(a.update_at));
    isLoading.value = false;
  }

  Future<void> loadOrderBySeller() async {
    isLoading.value = true;
    listOrder.value = [];
    await Get.find<BuyerController>().loadBuyer();
    final snapOrder = await orderCollection
        .where('seller_id',
            isEqualTo: Get.find<MainController>().seller.value.id)
        .get();
    for (var od in snapOrder.docs) {
      Map<String, dynamic> dataOrder = od.data() as Map<String, dynamic>;
      dataOrder['id'] = od.id;

      listOrder.add(Orders.fromJson(dataOrder));
    }

    listOrder.sort((a, b) => b.update_at.compareTo(a.update_at));
    isLoading.value = false;
  }

  Future<void> loadOrderDetailByOrder(Orders ord) async {
    isLoading.value = true;

    listOrderDetail.value = [];

    listProduct.value = [];
    listProductImage.value = [];
    final snapODD =
        await orderDetailCollection.where('order_id', isEqualTo: ord.id).get();
    for (var odd in snapODD.docs) {
      Map<String, dynamic> dataOdd = odd.data() as Map<String, dynamic>;
      dataOdd['id'] = odd.id;
      listOrderDetail.add(OrderDetail.fromJson(dataOdd));
      var listPro = Get.find<ProductController>()
          .listProduct
          .where((p0) => p0.id == dataOdd['product_id']);
      if (listPro.isEmpty) {
        var snap = await Get.find<ProductController>()
            .productCollection
            .doc(dataOdd['product_id'])
            .get();
        Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
        data['id'] = snap.id;
        listProduct.add(Product.fromJson(data));
        var snapImg = await Get.find<ProductController>()
            .productImageCollection
            .where('product_id', isEqualTo: dataOdd['product_id'])
            .get();
        for (var element in snapImg.docs) {
          Map<String, dynamic> dataImg = element.data() as Map<String, dynamic>;
          dataImg['id'] = element.id;
          listProductImage.add(ProductImage.fromJson(dataImg));
        }
      } else {
        listProduct.addAll(listPro);
        listProductImage.addAll(Get.find<ProductController>()
            .listProductImage
            .where((p0) => p0.product_id == dataOdd['product_id']));
      }
    }

    if (Get.find<AddressController>()
        .listAddress
        .where((p0) => p0.id == ord.address_id)
        .isEmpty) {
      final snapAddress = await Get.find<AddressController>()
          .addressCollection
          .doc(ord.address_id)
          .get();
      Map<String, dynamic> dataAddress =
          snapAddress.data() as Map<String, dynamic>;
      dataAddress['id'] = snapAddress.id;
      address.value = Address.fromJson(dataAddress);
    } else {
      address.value = Get.find<AddressController>()
              .listAddress
              .firstWhereOrNull((p0) => p0.id == ord.address_id) ??
          Address.initAddress();
    }
    isLoading.value = false;
  }

  Future<double> getNumOfSale(String productID) async {
    double count = 0;
    List listOrderId = [];
    final snapOrder = await orderCollection.where('status',
        whereIn: ['unconfirm', 'delivering', 'delivered']).get();
    for (var element in snapOrder.docs) {
      listOrderId.add(element.id);
    }
    final QuerySnapshot<Object?> snapshootOrderDetail;
    if (listOrderId.isEmpty) {
      snapshootOrderDetail = await orderDetailCollection
          .where('product_id', isEqualTo: productID)
          .get();
    } else {
      snapshootOrderDetail = await orderDetailCollection
          .where('product_id', isEqualTo: productID)
          .where('order_id', whereIn: listOrderId)
          .get();
    }
    for (var item in snapshootOrderDetail.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;

      count += data['quantity'];
    }
    return count;
  }

  Future<int> getRateSuccessByBuyer(String id) async {
    final snapOrder =
        await orderCollection.where('buyer_id', isEqualTo: id).get();
    int totalOrder = snapOrder.docs.length;
    final snapOrderFail = await orderCollection
        .where('buyer_id', isEqualTo: id)
        .where('status', isEqualTo: 'failed')
        .get();
    int totalOrderFail = snapOrderFail.docs.length;
    if (totalOrder == 0) {
      return 100;
    }
    return 100 - totalOrderFail * 100 ~/ totalOrder;
  }

  Future<void> createOrder(Orders order) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference refOrder = orderCollection.doc(order.id);
    batch.set(refOrder, order.toVal());
    await batch.commit();
  }

  Future<void> createOrderDetail(OrderDetail orderDetail) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference refOrderDetail =
        orderDetailCollection.doc(orderDetail.id);
    batch.set(refOrderDetail, orderDetail.toVal());
    await batch.commit();
  }

  Future<void> cancelOrder(Orders ord) async {
    isLoading.value = true;
    ord.update_at = Timestamp.now();
    await orderCollection.doc(ord.id).update(ord.toVal());
    await loadOrderDetailByOrder(ord);
    for (var odd in listOrderDetail) {
      Product pro = Get.find<ProductController>()
              .listProduct
              .firstWhereOrNull((p0) => p0.id == odd.product_id) ??
          Product.initProduct();
      pro.quantity += odd.quantity;
      pro.sale_num = await getNumOfSale(pro.id);
      await Get.find<ProductController>().updateProduct(pro);
    }
    isLoading.value = false;
  }

  Future<void> updateOrder(Orders ord) async {
    isLoading.value = true;
    ord.update_at = Timestamp.now();
    await orderCollection.doc(ord.id).update(ord.toVal());
    isLoading.value = false;
  }

  Future<void> rebuy(Orders ord) async {
    isLoading.value = true;
    await loadOrderDetailByOrder(ord);
    for (var odd in listOrderDetail) {
      Cart cart = Cart(
        id: '',
        buyer_id: ord.buyer_id,
        product_id: odd.product_id,
        quantity: odd.quantity,
        create_at: Timestamp.now(),
      );
      await Get.find<CartController>().createCart(cart);
    }

    isLoading.value = false;
  }
}
