import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/drawer_seller.dart';

class HomeSellerPage extends StatelessWidget {
  const HomeSellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    // SellerController sellerController = Get.find<SellerController>();
    MainController mainController = Get.find<MainController>();
    return Obx(() {
      return SafeArea(
        child: Scaffold(
          body: Container(
            child: mainController.pageSeller[mainController.indexSeller.value],
          ),
          drawer: const DrawerSeller(),
        ),
      );
    });
  }
}
