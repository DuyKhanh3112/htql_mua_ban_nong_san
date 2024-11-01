import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/admin_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/article_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/buyer_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/category_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/report_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/admin.dart';

class DrawerAdmin extends StatelessWidget {
  const DrawerAdmin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AdminController adminController = Get.find<AdminController>();
    MainController mainController = Get.find<MainController>();
    RxBool ischange = false.obs;
    RxBool isEdit = false.obs;
    Rx<TextEditingController> nameController = TextEditingController().obs;
    return Obx(() {
      if (mainController.admin.value.id != '') {
        nameController.value.text = mainController.admin.value.name;
      }
      return mainController.isLoading.value || adminController.isLoading.value
          ? const LoadingPage()
          : Container(
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
                                      mainController.admin.value.avatar != ''
                                          ? mainController.admin.value.avatar!
                                          : 'https://res.cloudinary.com/dg3p7nxyp/image/upload/v1723018608/account_default.png',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    // color: Colors.amber,
                                    width: Get.width * 0.35,
                                    child: Text(
                                      mainController.admin.value.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          BoxShadow(
                                            color: Colors.grey.shade400,
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    child: Icon(
                                        isEdit.value ? null : Icons.edit,
                                        color: Colors.white,
                                        shadows: [
                                          BoxShadow(
                                            color: Colors.grey.shade400,
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ]),
                                    onTap: () async {
                                      isEdit.value = true;
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  isEdit.value
                      ? Container(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 10,
                          ),
                          child: TextFormField(
                            controller: nameController.value,
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                            ),
                            onChanged: (value) {
                              ischange.value = true;
                            },
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: '',
                              hintStyle: const TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                              ),
                              errorStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  // hidePass.value = !hidePass.value;
                                  if (ischange.value) {
                                    mainController.admin.value.name =
                                        nameController.value.text;
                                    await adminController.updateAdmin(
                                        mainController.admin.value);
                                    ischange.value = false;
                                    isEdit.value = false;
                                  }
                                },
                                icon: ischange.value
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : const Icon(null),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Không được bỏ trống';
                              }
                              return null;
                            },
                          ),
                        )
                      : const SizedBox(),
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
                            // Get.toNamed('/personal_admin');

                            Get.back();
                            mainController.indexAdmin.value = 0;
                          },
                        ),
                        const SizedBox(
                          height: 10,
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
                            mainController.indexAdmin.value = 5;
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
                            mainController.indexAdmin.value = 6;
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
                                Get.find<MainController>().indexAdmin.value = 7;

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
                                Get.find<MainController>().indexAdmin.value = 8;

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
                          ),
                          title: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Get.toNamed('/login');
                            mainController.admin.value = Admin.initAdmin();
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
