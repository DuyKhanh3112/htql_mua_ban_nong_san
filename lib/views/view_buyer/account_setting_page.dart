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
                    Container(
                      padding: const EdgeInsets.all(5),
                      height: 75,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(4.0, 4.0),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                // width: Get.width / 3,
                                child: Text(
                                  mainController.buyer.value.name,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        mainController.buyer.value.avatar!),
                                  ),
                                ),
                                height: 75,
                                width: 75,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(20),
                          child: ListView(
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
                                    mainController.isLoading.value = true;
                                    await mainController.logout();
                                    Get.toNamed('/login');
                                    mainController.isLoading.value = false;
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            );
    });
  }
}
