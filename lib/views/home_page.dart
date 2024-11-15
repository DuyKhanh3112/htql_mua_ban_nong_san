import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/buyer_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    MainController mainController = Get.find<MainController>();

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
                icon: Icon(Icons.menu),
                label: 'Danh Mục',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.pending_actions_outlined),
              //   label: 'Đơn Hàng',
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.newspaper_rounded),
                label: 'Bài Viết',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded),
                label: 'Tài Khoản',
              ),
            ],
            onTap: (index) async {
              mainController.numPage.value = index;
              // if (index == 2) {
              //   mainController.isLoading.value = true;
              //   await Get.find<ArticleController>().loadAllArticleActive();
              //   mainController.isLoading.value = false;
              // }
              if (index == 3) {
                Get.find<BuyerController>().isLoading.value = false;
              }
            },
            currentIndex: mainController.numPage.value,
          ),
        ),
      );
    });
  }
}
