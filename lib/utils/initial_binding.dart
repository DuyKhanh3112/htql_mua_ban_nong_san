import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/admin_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/buyer_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/cart_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/category_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/review_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
// import 'package:htql_mua_ban_nong_san/controller/user_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() async {
    Get.put(MainController(), permanent: true);
    Get.put(BuyerController(), permanent: true);
    Get.put(SellerController(), permanent: true);
    Get.put(AdminController(), permanent: true);
    Get.put(CategoryController(), permanent: true);
    Get.put(ProductController(), permanent: true);
    Get.put(OrderController(), permanent: true);
    Get.put(ReviewController(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.find<MainController>().isLoading.value = true;

    await Get.find<ProductController>().loadProductActive();
    await Get.find<ProductController>().loadCategory();
    await Get.find<ProductController>().loadSeller();
    await Get.find<ProductController>().loadProvince();
    Get.find<MainController>().isLoading.value = false;
  }

  Future<void> buyerController() async {
    Get.put(BuyerController(), permanent: true);
  }

  Future<void> sellerController() async {
    Get.put(SellerController(), permanent: true);
  }
}
