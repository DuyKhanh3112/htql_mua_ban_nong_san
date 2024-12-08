import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/admin_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/article_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/banner_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/buyer_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/category_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/report_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';

class DrawerAdmin extends StatelessWidget {
  const DrawerAdmin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AdminController adminController = Get.find<AdminController>();
    MainController mainController = Get.find<MainController>();
    Rx<TextEditingController> nameController = TextEditingController().obs;
    return Obx(() {
      if (mainController.admin.value.id != '') {
        nameController.value.text = mainController.admin.value.name;
      }
      return mainController.isLoading.value || adminController.isLoading.value
          ? const LoadingPage()
          : Container(
              width: Get.width * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            // color: Colors.white,
                            height: 150,
                            width: Get.width * 0.75,
                            decoration: BoxDecoration(
                              color: mainController.admin.value.cover == ''
                                  ? null
                                  : Colors.green,
                              borderRadius: const BorderRadius.only(
                                  // bottomLeft: Radius.circular(40),
                                  // bottomRight: Radius.circular(40),
                                  ),
                              image: mainController.admin.value.cover == ''
                                  ? null
                                  : DecorationImage(
                                      image: NetworkImage(
                                          mainController.admin.value.cover!),
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          )
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: Get.width * 0.05,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                                    mainController.admin.value.avatar != ''
                                        ? mainController.admin.value.avatar!
                                        : 'https://res.cloudinary.com/dg3p7nxyp/image/upload/v1723018608/account_default.png',
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Container(
                              width: Get.width * 0.45,
                              padding: EdgeInsets.only(left: Get.width * 0.05),
                              child: Text(
                                mainController.admin.value.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  // shadows: [
                                  //   BoxShadow(
                                  //     color: Colors.black,
                                  //     spreadRadius: 5,
                                  //     blurRadius: 7,
                                  //     offset:
                                  //         Offset(0, 3), // changes position of shadow
                                  //   ),
                                  // ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Divider(),
                  // Container(
                  //   // color: Colors.white,
                  //   height: 150,
                  //   width: Get.width * 2 / 3,
                  //   decoration: BoxDecoration(
                  //     color: mainController.admin.value.cover != ''
                  //         ? null
                  //         : Colors.green,
                  //     borderRadius: const BorderRadius.only(
                  //         // bottomLeft: Radius.circular(40),
                  //         // bottomRight: Radius.circular(40),
                  //         ),
                  //     image: mainController.admin.value.cover == ''
                  //         ? null
                  //         : DecorationImage(
                  //             image: NetworkImage(
                  //                 mainController.admin.value.cover!),
                  //             fit: BoxFit.fill,
                  //           ),
                  //   ),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Container(
                  //         margin: const EdgeInsets.only(
                  //           bottom: 10,
                  //           left: 5,
                  //           right: 5,
                  //         ),
                  //         child: Row(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Container(
                  //               width: Get.width / 5,
                  //               height: 100,
                  //               // margin: const EdgeInsets.all(10),
                  //               decoration: BoxDecoration(
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: Colors.grey.shade300,
                  //                     spreadRadius: 5,
                  //                     blurRadius: 7,
                  //                     offset: const Offset(
                  //                         0, 3), // changes position of shadow
                  //                   ),
                  //                 ],
                  //                 shape: BoxShape.circle,
                  //                 image: DecorationImage(
                  //                   image: NetworkImage(
                  //                     mainController.admin.value.avatar != ''
                  //                         ? mainController.admin.value.avatar!
                  //                         : 'https://res.cloudinary.com/dg3p7nxyp/image/upload/v1723018608/account_default.png',
                  //                   ),
                  //                   fit: BoxFit.fill,
                  //                 ),
                  //               ),
                  //             ),
                  //             Row(
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 SizedBox(
                  //                   // color: Colors.amber,
                  //                   width: Get.width * 0.35,
                  //                   child: Text(
                  //                     mainController.admin.value.name,
                  //                     style: const TextStyle(
                  //                       fontSize: 20,
                  //                       fontWeight: FontWeight.bold,
                  //                       color: Colors.green,
                  //                       shadows: [
                  //                         BoxShadow(
                  //                           color: Colors.black,
                  //                           spreadRadius: 5,
                  //                           blurRadius: 7,
                  //                           offset: Offset(0,
                  //                               3), // changes position of shadow
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),

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
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Get.back();
                            mainController.indexAdmin.value = 0;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/images/banner_icon.png',
                            width: 40,
                          ),
                          title: const Text(
                            'Banner',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () async {
                            Get.back();
                            await Get.find<BannerController>().loadBanner();
                            mainController.indexAdmin.value = 8;
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/images/buyer_icon.png',
                            width: 40,
                          ),
                          title: const Text(
                            'Người mua',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () async {
                            Get.back();
                            mainController.indexAdmin.value = 1;
                            await Get.find<BuyerController>().loadBuyer();
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/images/seller_icon.png',
                            width: 40,
                          ),
                          title: const Text(
                            'Người bán',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () async {
                            Get.back();
                            mainController.indexAdmin.value = 2;
                            await Get.find<SellerController>().loadAllSeller();
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/images/category_green.png',
                            width: 40,
                          ),
                          title: const Text(
                            'Loại sản phẩm',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () async {
                            Get.back();

                            mainController.indexAdmin.value = 3;
                            await Get.find<CategoryController>().loadCategory();
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/images/product_green.png',
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
                            Get.back();
                            // Get.toNamed('/product_admin');
                            mainController.indexAdmin.value = 4;
                            Get.find<ProductController>().loadAllProduct();
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
                            // Get.toNamed('/product_admin');
                            mainController.indexAdmin.value = 5;
                            Get.find<ArticleController>().loadAllArticle();
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
                            //     'assets/images/report_sell.png',
                            //     width: 30,
                            //   ),
                            //   title: const Text(
                            //     'Thống kê bán hàng',
                            //     style: TextStyle(
                            //         color: Colors.green, fontSize: 18),
                            //   ),
                            //   onTap: () async {
                            //     Get.back();
                            //     Get.find<MainController>().indexSeller.value =
                            //         4;
                            //     await Get.find<ReportController>()
                            //         .showReportOrder();
                            //   },
                            // ),
                            ListTile(
                              contentPadding:
                                  EdgeInsets.only(left: Get.width * 0.1),
                              leading: Image.asset(
                                'assets/images/report_seller.png',
                                width: 30,
                              ),
                              title: const Text(
                                'Thống kê người bán',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 18),
                              ),
                              onTap: () async {
                                Get.back();
                                Get.find<MainController>().indexAdmin.value = 6;

                                await Get.find<ReportController>()
                                    .showReportSeller();
                              },
                            ),

                            ListTile(
                              contentPadding:
                                  EdgeInsets.only(left: Get.width * 0.1),
                              leading: Image.asset(
                                'assets/images/report_buyer.png',
                                width: 30,
                              ),
                              title: const Text(
                                'Thống kê người mua',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 18),
                              ),
                              onTap: () async {
                                Get.back();
                                Get.find<MainController>().indexAdmin.value = 7;

                                // await Get.find<ReportController>()
                                //     .showReportProduct();
                              },
                            ),
                          ],
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
                            Get.toNamed('/login');
                            mainController.seller.value = Seller.initSeller();
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
