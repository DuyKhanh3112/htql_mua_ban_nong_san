import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/widget/header_widget.dart';

class AccountSettingPage extends StatelessWidget {
  const AccountSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    MainController mainController = Get.find<MainController>();
    return Obx(() {
      return mainController.isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                body: Column(
                  children: [
                    const HeaderWidget(),
                    Expanded(
                        child: Container(
                      margin: const EdgeInsets.all(20),
                      child: mainController.isLogin.value
                          ? ListView(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.account_circle,
                                      color: Colors.green,
                                    ),
                                    title: const Text(
                                      'Quản lý tài khoản',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green,
                                      ),
                                    ),
                                    shape: const Border(
                                      bottom: BorderSide(color: Colors.green),
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.password,
                                      color: Colors.green,
                                    ),
                                    title: const Text(
                                      'Cập nhật mật khẩu',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green,
                                      ),
                                    ),
                                    shape: const Border(
                                      bottom: BorderSide(color: Colors.green),
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.output,
                                      color: Colors.green,
                                    ),
                                    title: const Text(
                                      'Đăng xuất',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green,
                                      ),
                                    ),
                                    shape: const Border(
                                      bottom: BorderSide(color: Colors.green),
                                    ),
                                    onTap: () async {
                                      await mainController.logout();
                                    },
                                  ),
                                ),
                              ],
                            )
                          : ListView(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.login,
                                      color: Colors.green,
                                    ),
                                    title: const Text(
                                      'Dang Nhap',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green,
                                      ),
                                    ),
                                    shape: const Border(
                                      bottom: BorderSide(color: Colors.green),
                                    ),
                                    onTap: () {
                                      Get.toNamed('/login');
                                    },
                                  ),
                                ),
                              ],
                            ),
                    )),
                  ],
                ),
              ),
            );
    });
  }
}
