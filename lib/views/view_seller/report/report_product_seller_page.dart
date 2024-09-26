import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/report_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/drawer_seller.dart';

class ReportProductSellerPage extends StatelessWidget {
  const ReportProductSellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    ReportController reportController = Get.find<ReportController>();
    return Obx(() {
      return reportController.isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Thống kê sản phẩm',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                body: Column(
                  children: [],
                ),
                drawer: const DrawerSeller(),
              ),
            );
    });
  }
}
