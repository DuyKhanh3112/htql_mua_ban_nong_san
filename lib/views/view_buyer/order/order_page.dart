import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:convert_vietnamese/convert_vietnamese.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/category_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/category.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/main_drawer.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    OrderController orderController = Get.find<OrderController>();
    MainController mainController = Get.find<MainController>();

    return Obx(() {
      return mainController.isLoading.value || orderController.isLoading.value
          ? const LoadingPage()
          : DefaultTabController(
              initialIndex: 0,
              length: orderController.listStatus.length,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Đơn Hàng',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // actions: [
                  //   Container(
                  //     padding: const EdgeInsets.only(right: 5),
                  //     child: InkWell(
                  //       onTap: () async {
                  //         // widgetCreateCategory(context);
                  //       },
                  //       child: const Icon(
                  //         Icons.refresh,
                  //         size: 35,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ],
                  bottom: TabBar(
                    isScrollable: true,
                    labelColor: Colors.yellow,
                    unselectedLabelColor: Colors.white,
                    dividerColor: Colors.transparent,
                    tabs: <Widget>[
                      for (var item in orderController.listStatus)
                        Tab(
                          text: '${item['label']}',
                          // icon: Icon(Icons.flight),
                        ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    // ignore: unused_local_variable
                    for (var item in orderController.listStatus)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: const SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [],
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
    });
  }
}
