import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/buyer_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
// import 'package:htql_mua_ban_nong_san/controller/user_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() async {
    await mainController();
    await buyerController();
    await sellerController();
  }

  Future<void> mainController() async {
    Get.put(MainController(), permanent: true);
  }

  Future<void> buyerController() async {
    Get.put(BuyerController(), permanent: true);
  }

  Future<void> sellerController() async {
    Get.put(SellerController(), permanent: true);
  }
}
