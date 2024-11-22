import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/article_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/report_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
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
        width: Get.width * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              // color: Colors.white,
              height: 150,
              width: Get.width * 0.75,
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
                    padding: EdgeInsets.only(
                      bottom: Get.width * 0.02,
                      left: Get.width * 0.02,
                      right: Get.width * 0.01,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: Get.width * 0.2,
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
                        Container(
                          // color: Colors.amber,
                          width: Get.width * 0.45,
                          padding: EdgeInsets.only(left: Get.width * 0.05),
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
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  [
                    'draft',
                    'inactive'
                  ].contains(Get.find<MainController>().seller.value.status)
                      ? const SizedBox()
                      : Column(
                          children: [
                            ListTile(
                              leading: Image.asset(
                                'assets/images/personal_info_icon.png',
                                width: 40,
                              ),
                              title: const Text(
                                'Thông tin cá nhân',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                Get.back();
                                mainController.indexSeller.value = 0;
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
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () async {
                                // Get.toNamed('/product_seller');
                                Get.back();
                                mainController.indexSeller.value = 1;
                                await Get.find<ProductController>()
                                    .loadProductBySeller();
                              },
                            ),
                            ListTile(
                              leading: Image.asset(
                                'assets/images/order_icon.png',
                                width: 40,
                              ),
                              title: const Text(
                                'Đơn hàng',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () async {
                                Get.back();
                                Get.find<MainController>().indexSeller.value =
                                    2;
                                await Get.find<OrderController>()
                                    .loadOrderBySeller();
                              },
                            ),
                            ListTile(
                              leading: Image.asset(
                                'assets/images/article_green.png',
                                width: 40,
                              ),
                              title: const Text(
                                'Bài viết',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () async {
                                Get.back();
                                Get.find<MainController>().indexSeller.value =
                                    3;

                                await Get.find<ArticleController>()
                                    .loadArticleBySeller();
                              },
                            ),
                            ExpansionTile(
                              leading: Image.asset(
                                'assets/images/statistics_icon.png',
                                width: 40,
                              ),
                              title: const Text(
                                'Thống kê báo cáo',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              collapsedIconColor: Colors.green,
                              children: [
                                // ListTile(
                                //   contentPadding:
                                //       EdgeInsets.only(left: Get.width * 0.1),
                                //   leading: Image.asset(
                                //     'assets/images/report_revenue.png',
                                //     width: 30,
                                //   ),
                                //   title: const Text(
                                //     'Thống kê doanh thu',
                                //     style: TextStyle(
                                //         color: Colors.green, fontSize: 18),
                                //   ),
                                //   onTap: () async {
                                //     Get.back();
                                //     // Get.find<MainController>()
                                //     //     .indexSeller
                                //     //     .value = 6;
                                //     // await Get.find<ReportController>()
                                //     //     .showReportRevenue();
                                //   },
                                // ),

                                ListTile(
                                  contentPadding:
                                      EdgeInsets.only(left: Get.width * 0.1),
                                  leading: Image.asset(
                                    'assets/images/report_sell.png',
                                    width: 30,
                                  ),
                                  title: const Text(
                                    'Thống kê bán hàng',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 18),
                                  ),
                                  onTap: () async {
                                    Get.back();
                                    Get.find<MainController>()
                                        .indexSeller
                                        .value = 4;
                                    await Get.find<ReportController>()
                                        .showReportOrder();
                                  },
                                ),
                                ListTile(
                                  contentPadding:
                                      EdgeInsets.only(left: Get.width * 0.1),
                                  leading: Image.asset(
                                    'assets/images/report_product.png',
                                    width: 30,
                                  ),
                                  title: const Text(
                                    'Thống kê sản phẩm',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 18),
                                  ),
                                  onTap: () async {
                                    Get.back();
                                    Get.find<MainController>()
                                        .indexSeller
                                        .value = 5;

                                    await Get.find<ReportController>()
                                        .showReportProduct();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                  ListTile(
                    leading: const Icon(
                      Icons.store_mall_directory_outlined,
                      color: Colors.green,
                      size: 40,
                    ),
                    title: const Text(
                      'Xem cửa hàng',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      Get.toNamed('/view_seller');
                      Get.find<SellerController>().seller.value =
                          mainController.seller.value;
                      // await Get.find<SellerController>()
                      //     .getSeller(mainController.seller.value.id);
                      // Get.back();
                      // mainController.seller.value = Seller.initSeller();
                      // Get.toNamed('/login');
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
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Get.back();
                      mainController.seller.value = Seller.initSeller();
                      mainController.indexSeller.value = 0;
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
