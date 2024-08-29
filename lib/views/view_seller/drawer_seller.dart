import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';

class DrawerSeller extends StatelessWidget {
  const DrawerSeller({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    return Obx(() {
      return Container(
        width: Get.width * 2 / 3,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              // color: Colors.white,
              height: 150,
              width: Get.width * 2 / 3,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                    // bottomLeft: Radius.circular(40),
                    // bottomRight: Radius.circular(40),
                    ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                      left: 5,
                      right: 5,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: Get.width / 5,
                          height: 100,
                          // margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                mainController.seller.value.avatar != ''
                                    ? mainController.seller.value.avatar!
                                    : 'https://res.cloudinary.com/dg3p7nxyp/image/upload/v1723018608/account_default.png',
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              // color: Colors.amber,
                              width: Get.width * 0.35,
                              child: Text(
                                mainController.seller.value.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.grey.shade400,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Image.asset(
                      'assets/images/personal_info_icon.png',
                      width: 40,
                    ),
                    title: const Text(
                      'Thông tin cá nhân',
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    ),
                    onTap: () {
                      Get.back();
                      // Get.toNamed('/seller');
                    },
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/images/product_icon.png',
                      width: 40,
                    ),
                    title: const Text(
                      'Sản phẩm',
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    ),
                    onTap: () async {
                      // Get.toNamed('/product_seller');
                      Get.back();
                      mainController.indexSeller.value = 0;
                      await Get.find<ProductController>().loadData();
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.green,
                      size: 40,
                    ),
                    title: const Text(
                      'Đăng xuất',
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    ),
                    onTap: () {
                      Get.back();
                      mainController.seller.value = Seller.initSeller();
                      Get.toNamed('/login');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
