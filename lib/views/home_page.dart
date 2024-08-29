import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    MainController mainController = Get.find<MainController>();

    // if (Get.find<MainController>().seller.value.id != '') {
    //   Timer.periodic(Duration(seconds: 10), (timer) {
    //     print('Hàm này sẽ được gọi sau mỗi 10 giây');
    //   });
    // }
    return Obx(() {
      return SafeArea(
        child: Scaffold(
          body: Container(
            child: mainController.page[mainController.numPage.value],
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 15,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 15,
            unselectedFontSize: 12,
            selectedIconTheme: const IconThemeData(
              size: 25,
            ),
            unselectedIconTheme: const IconThemeData(
              size: 20,
            ),
            showUnselectedLabels: true,
            backgroundColor: Colors.green,
            unselectedItemColor: Colors.white,
            unselectedLabelStyle: const TextStyle(color: Colors.white),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            selectedItemColor: Colors.yellowAccent,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Trang Chủ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notes),
                label: 'Danh Mục',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pending_actions_outlined),
                label: 'Đơn Hàng',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.production_quantity_limits_sharp),
                label: 'Sản Phẩm',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded),
                label: 'Tài Khoản',
              ),
            ],
            onTap: (index) {
              mainController.numPage.value = index;
            },
            currentIndex: mainController.numPage.value,
          ),
        ),
      );
    });
  }
}
