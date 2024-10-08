import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/admin_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/drawer_admin.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/drawer_seller.dart';

class AdminInformationPage extends StatelessWidget {
  const AdminInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Obx(() {
      return Get.find<AdminController>().isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Thông tin cá nhân',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                body: Container(
                  padding: EdgeInsets.all(Get.width * 0.03),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              // Container(
                              //   width: Get.width * 0.6,
                              //   decoration: const BoxDecoration(),
                              //   child: TextFormField(
                              //     readOnly: true,
                              //     style: const TextStyle(
                              //       color: Colors.green,
                              //       fontSize: 16,
                              //     ),
                              //     controller: TextEditingController(
                              //         text: Get.find<MainController>()
                              //             .seller
                              //             .value
                              //             .username),
                              //     validator: (value) {
                              //       return null;
                              //     },
                              //     decoration: const InputDecoration(
                              //       enabledBorder: OutlineInputBorder(
                              //         borderSide:
                              //             BorderSide(color: Colors.green),
                              //         borderRadius: BorderRadius.all(
                              //           Radius.circular(20),
                              //         ),
                              //       ),
                              //       focusedBorder: OutlineInputBorder(
                              //         borderSide:
                              //             BorderSide(color: Colors.green),
                              //         borderRadius: BorderRadius.all(
                              //           Radius.circular(20),
                              //         ),
                              //       ),
                              //       border: OutlineInputBorder(
                              //         borderRadius: BorderRadius.all(
                              //           Radius.circular(20),
                              //         ),
                              //         borderSide:
                              //             BorderSide(color: Colors.green),
                              //       ),
                              //       labelText: 'Giá sản phẩm',
                              //       labelStyle: TextStyle(
                              //         color: Colors.green,
                              //         fontSize: 16,
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: Get.width * 0.35,
                                        width: Get.width * 0.35,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: Get.find<MainController>()
                                                      .admin
                                                      .value
                                                      .avatar ==
                                                  null
                                              ? null
                                              : DecorationImage(
                                                  image: NetworkImage(
                                                      Get.find<MainController>()
                                                          .admin
                                                          .value
                                                          .avatar!),
                                                  fit: BoxFit.fill,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Get.height * 0.05,
                              ),
                              TextFormField(
                                controller: TextEditingController(
                                    text: Get.find<MainController>()
                                        .admin
                                        .value
                                        .name),
                                readOnly: true,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                ),
                                decoration: const InputDecoration(
                                  label: Text('Tên'),
                                  labelStyle: TextStyle(color: Colors.green),
                                  fillColor: Colors.green,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  // if (value!.isEmpty || value.trim() == '') {
                                  //   return 'Hãy nhập tên loại sản phẩm';
                                  // }
                                  return null;
                                },
                              ),
                              // SizedBox(
                              //   height: Get.height * 0.02,
                              // ),
                              // TextFormField(
                              //   controller: TextEditingController(
                              //       text: Get.find<MainController>()
                              //           .seller
                              //           .value
                              //           .name),
                              //   readOnly: true,
                              //   style: const TextStyle(
                              //     color: Colors.green,
                              //     fontSize: 18,
                              //   ),
                              //   decoration: const InputDecoration(
                              //     label: Text('Tên'),
                              //     labelStyle: TextStyle(color: Colors.green),
                              //     fillColor: Colors.green,
                              //     border: OutlineInputBorder(
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(20),
                              //       ),
                              //     ),
                              //     enabledBorder: OutlineInputBorder(
                              //       borderSide: BorderSide(color: Colors.green),
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(20),
                              //       ),
                              //     ),
                              //     focusedBorder: OutlineInputBorder(
                              //       borderSide: BorderSide(color: Colors.green),
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(20),
                              //       ),
                              //     ),
                              //   ),
                              //   validator: (value) {
                              //     // if (value!.isEmpty || value.trim() == '') {
                              //     //   return 'Hãy nhập tên loại sản phẩm';
                              //     // }
                              //     return null;
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                drawer: const DrawerAdmin(),
              ),
            );
    });
  }
}
