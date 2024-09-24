import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/admin_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/admin.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/drawer_admin.dart';

class PersonalAdminPage extends StatelessWidget {
  const PersonalAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    Get.put(AdminController());
    AdminController adminController = Get.find<AdminController>();
    MainController mainController = Get.find<MainController>();
    Rx<Admin> admin = Admin.initAdmin().obs;
    return Obx(() {
      admin.value = mainController.admin.value;
      return mainController.isLoading.value || adminController.isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  title: Text(
                    admin.value.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                body: ListView(
                  // padding: const EdgeInsets.all(10),
                  children: [
                    Container(
                      height: Get.height * 0.3,
                      width: Get.width / 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber,
                        image: DecorationImage(
                          image: NetworkImage(admin.value.avatar!),
                          // fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
                drawer: const DrawerAdmin(),
              ),
            );
    });
  }
}
