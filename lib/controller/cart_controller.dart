import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/models/cart.dart';
import 'package:htql_mua_ban_nong_san/models/order_detail.dart';

class CartController extends GetxController {
  static CartController get to => Get.find<CartController>();
  RxBool isLoading = false.obs;
  CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('Cart');

  RxList<Cart> listCart = <Cart>[].obs;
  RxList<OrderDetail> listOrderDetail = <OrderDetail>[].obs;

  Future<double> loadCartByBuyer() async {
    double count = 0;
    final snapshotCart = await cartCollection
        .where('buyer_id', isEqualTo: Get.find<MainController>().buyer.value.id)
        .get();
    listCart.value = [];
    for (var item in snapshotCart.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listCart.add(Cart.fromJson(data));
    }
    return count;
  }

  Future<void> createCart(Cart cart) async {
    isLoading.value = true;
    Cart? cartData = listCart.value
        .firstWhereOrNull((element) => element.product_id == cart.product_id);
    if (cartData == null) {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      DocumentReference refCart = cartCollection.doc(cartCollection.doc().id);
      batch.set(refCart, cart.toVal());
      await batch.commit();
    } else {
      cartData.quantity += cart.quantity;
      await updateCart(cartData);
    }
    loadCartByBuyer();

    isLoading.value = false;
  }

  Future<void> updateCart(Cart cart) async {
    isLoading.value = true;
    cart.create_at = Timestamp.now();
    await cartCollection.doc(cart.id).update(cart.toVal());
    isLoading.value = false;
  }

  double getQuantityCart() {
    double quantity = 0;
    for (var item in listCart.value) {
      quantity += item.quantity;
    }
    return quantity;
  }

  List<dynamic> getCartGroupBySeller() {
    var listCartSeller = [];
    for (var seller in Get.find<ProductController>().listSeller.value) {
      var carts = [];
      var listProductID = [];
      for (var pro in Get.find<ProductController>()
          .listProduct
          .where((p0) => p0.seller_id == seller.id && p0.status == 'active')
          .toList()) {
        listProductID.add(pro.id);
      }
      for (var c in listCart
          .where((element) => listProductID.contains(element.product_id))) {
        carts.add(c);
      }

      if (carts.isNotEmpty) {
        listCartSeller.add([seller, carts]);
      }
    }
    return listCartSeller.toList();
  }
}
