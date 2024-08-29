import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/main_drawer.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    return Obx(() {
      return SafeArea(
        child: Scaffold(
          body: Container(
            child: mainController.pageAdmin[mainController.indexAdmin.value],
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   elevation: 15,
          //   type: BottomNavigationBarType.fixed,
          //   selectedFontSize: 15,
          //   unselectedFontSize: 12,
          //   selectedIconTheme: const IconThemeData(
          //     size: 25,
          //   ),
          //   unselectedIconTheme: const IconThemeData(
          //     size: 20,
          //   ),
          //   showUnselectedLabels: true,
          //   backgroundColor: Colors.green,
          //   unselectedItemColor: Colors.white,
          //   unselectedLabelStyle: const TextStyle(color: Colors.white),
          //   selectedLabelStyle: const TextStyle(
          //     fontWeight: FontWeight.w500,
          //     color: Colors.white,
          //   ),
          //   selectedItemColor: Colors.yellowAccent,
          //   items: const <BottomNavigationBarItem>[
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.home),
          //       label: 'Trang Chủ',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.notes),
          //       label: 'Danh Mục',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.pending_actions_outlined),
          //       label: 'Đơn Hàng',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.production_quantity_limits_sharp),
          //       label: 'Sản Phẩm',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.account_circle_rounded),
          //       label: 'Tài Khoản',
          //     ),
          //   ],
          //   onTap: (index) {
          //     // print(index);
          //     mainController.numPage.value = index;
          //   },
          //   currentIndex: mainController.numPage.value,
          // ),
          drawer: const DrawerAdmin(),
        ),
      );
    });
  }
}
