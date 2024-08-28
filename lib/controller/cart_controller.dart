import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/models/cart.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';

class CartController extends GetxController {
  static CartController get to => Get.find<CartController>();
  RxBool isLoading = false.obs;
  CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('Cart');

  RxList<Cart> listCart = <Cart>[].obs;
  // RxList<OrderDetail> listOrderDetail = <OrderDetail>[].obs;
  RxDouble countCart = 0.0.obs;
  RxDouble totalCart = 0.0.obs;
  RxBool isChange = false.obs;
  RxList<Cart> listCartChoose = <Cart>[].obs;

  Future<void> loadCartByBuyer() async {
    // double count = 0;
    final snapshotCart = await cartCollection
        .where('buyer_id', isEqualTo: Get.find<MainController>().buyer.value.id)
        .get();
    listCart.value = [];
    countCart.value = 0.0;
    for (var item in snapshotCart.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listCart.add(Cart.fromJson(data));
      countCart.value += data['quantity'];
    }
    // return count;
    getCountCart();
  }

  void getCountCart() {
    countCart.value = 0.0;
    totalCart.value = 0.0;
    for (var element in getCartGroupBySeller()) {
      for (var item in element[1]) {
        countCart.value += item.quantity;
        if (listCartChoose.contains(item)) {
          Product product = Get.find<ProductController>()
                  .listProduct
                  .firstWhereOrNull((p0) => p0.id == item.product_id) ??
              Product.initProduct();
          totalCart.value += item.quantity * product.price;
        }
      }
    }
  }

  Future<void> createCart(Cart cart) async {
    isLoading.value = true;

    Cart? cartData = listCart
        .firstWhereOrNull((element) => element.product_id == cart.product_id);
    if (cartData == null) {
      listCart.add(cart);
      // WriteBatch batch = FirebaseFirestore.instance.batch();
      // DocumentReference refCart = cartCollection.doc(cartCollection.doc().id);
      // batch.set(refCart, cart.toVal());
      // await batch.commit();
    } else {
      cartData.quantity += cart.quantity;
      // await updateCart(cartData);
    }
    // loadCartByBuyer();
    getCountCart();
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
    for (var item in listCart) {
      quantity += item.quantity;
    }
    return quantity;
  }

  Future<void> saveCart() async {
    isLoading.value = true;
    for (var cart in listCart) {
      await cartCollection.doc(cart.id).update(cart.toVal());
    }
    isLoading.value = false;
  }

  dynamic getCartGroupBySeller() {
    var listCartSeller = [];
    for (var seller in Get.find<ProductController>().listSeller) {
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
