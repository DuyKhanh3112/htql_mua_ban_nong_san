import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/buyer_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';

class AccountSettingPage extends StatelessWidget {
  const AccountSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    MainController mainController = Get.find<MainController>();
    return Obx(() {
      return mainController.isLoading.value ||
              Get.find<BuyerController>().isLoading.value
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
                              mainController.buyer.value.id == ''
                                  ? const SizedBox()
                                  : SizedBox(
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
                              mainController.buyer.value.id == ''
                                  ? const SizedBox()
                                  : Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image:
                                            mainController.buyer.value.avatar ==
                                                    ''
                                                ? null
                                                : DecorationImage(
                                                    image: NetworkImage(
                                                        mainController.buyer
                                                            .value.avatar!),
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
                        child: mainController.buyer.value.id == ''
                            ? ListView(
                                children: [
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          mainController.isLoading.value = true;
                                          // await mainController.logout();
                                          Get.toNamed('/login');
                                          mainController.isLoading.value =
                                              false;
                                        },
                                        style: const ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  Colors.green),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Đăng nhập',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            : ListView(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.05,
                                      vertical: Get.width * 0.01,
                                    ),
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.playlist_add_check_circle_sharp,
                                        color: Colors.green,
                                      ),
                                      title: const Text(
                                        'Quản lý đơn hàng',
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
                                        Get.find<OrderController>()
                                            .loadOrderByBuyer();
                                        mainController.isLoading.value = false;
                                        Get.toNamed('order');
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.05,
                                      vertical: Get.width * 0.01,
                                    ),
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.account_circle,
                                        color: Colors.green,
                                      ),
                                      title: const Text(
                                        'Quản lý thông tin cá nhân',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.green,
                                        ),
                                      ),
                                      shape: const Border(
                                        bottom: BorderSide(color: Colors.green),
                                      ),
                                      onTap: () {
                                        Get.toNamed('/buyer_information');
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.05,
                                      vertical: Get.width * 0.01,
                                    ),
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.location_on_rounded,
                                        color: Colors.green,
                                      ),
                                      title: const Text(
                                        'Địa chỉ nhận hàng',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.green,
                                        ),
                                      ),
                                      shape: const Border(
                                        bottom: BorderSide(color: Colors.green),
                                      ),
                                      onTap: () {
                                        Get.toNamed('/address');
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.05,
                                      vertical: Get.width * 0.01,
                                    ),
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
                                      onTap: () async {
                                        final formKey = GlobalKey<FormState>();
                                        Rx<TextEditingController>
                                            newPassController =
                                            TextEditingController().obs;
                                        Rx<TextEditingController>
                                            confPassController =
                                            TextEditingController().obs;
                                        RxBool hideOldPass = true.obs;
                                        RxBool hidePass = true.obs;
                                        RxBool hidePassConf = true.obs;
                                        Get.dialog(
                                          Obx(
                                            () => AlertDialog(
                                              title: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Cập nhật mật khẩu',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                      InkWell(
                                                        child: const Icon(
                                                          Icons.close,
                                                          color: Colors.green,
                                                        ),
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(),
                                                ],
                                              ),
                                              content: SizedBox(
                                                width: Get.width * 0.8,
                                                height: Get.height * 0.5,
                                                child: ListView(
                                                  children: [
                                                    Form(
                                                      key: formKey,
                                                      child: Column(
                                                        children: [
                                                          TextFormField(
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 14,
                                                            ),
                                                            // controller: nameController,

                                                            validator: (value) {
                                                              if (value!
                                                                      .isEmpty ||
                                                                  value.trim() ==
                                                                      '') {
                                                                return 'Mật khẩu không được rỗng';
                                                              }
                                                              final RegExp
                                                                  passRegExp =
                                                                  RegExp(
                                                                      r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$");
                                                              if (!passRegExp
                                                                  .hasMatch(
                                                                      value)) {
                                                                return 'Mật khẩu ít nhất 6 ký tự. Bao gồm: \nchữ hoa, chữ thường, số và ký tự đặc biệt.';
                                                              }

                                                              if (value !=
                                                                  Get.find<
                                                                          MainController>()
                                                                      .buyer
                                                                      .value
                                                                      .password) {
                                                                return 'Mật khẩu cũ không đúng';
                                                              }
                                                              return null;
                                                            },
                                                            obscureText:
                                                                hideOldPass
                                                                    .value,
                                                            decoration:
                                                                InputDecoration(
                                                              suffixIcon:
                                                                  IconButton(
                                                                onPressed: () {
                                                                  hideOldPass
                                                                          .value =
                                                                      !hideOldPass
                                                                          .value;
                                                                },
                                                                icon: hideOldPass
                                                                        .value
                                                                    ? const Icon(
                                                                        Icons
                                                                            .remove_red_eye_outlined,
                                                                        color: Colors
                                                                            .green,
                                                                      )
                                                                    : const Icon(
                                                                        Icons
                                                                            .remove_red_eye_rounded,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                              ),
                                                              enabledBorder:
                                                                  const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .green),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                              ),
                                                              focusedBorder:
                                                                  const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .green),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                              ),
                                                              border:
                                                                  const OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                              labelText:
                                                                  'Mật khẩu cũ',
                                                              labelStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: Get.height *
                                                                0.01,
                                                          ),
                                                          TextFormField(
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 14,
                                                            ),
                                                            controller:
                                                                newPassController
                                                                    .value,
                                                            validator: (value) {
                                                              if (value!
                                                                      .isEmpty ||
                                                                  value.trim() ==
                                                                      '') {
                                                                return 'Mật khẩu không được rỗng';
                                                              }
                                                              final RegExp
                                                                  passRegExp =
                                                                  RegExp(
                                                                      r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$");
                                                              if (!passRegExp
                                                                  .hasMatch(
                                                                      value)) {
                                                                return 'Mật khẩu ít nhất 6 ký tự. Bao gồm: \nchữ hoa, chữ thường, số và ký tự đặc biệt.';
                                                              }
                                                              return null;
                                                            },
                                                            obscureText:
                                                                hidePass.value,
                                                            decoration:
                                                                InputDecoration(
                                                              suffixIcon:
                                                                  IconButton(
                                                                onPressed: () {
                                                                  hidePass.value =
                                                                      !hidePass
                                                                          .value;
                                                                },
                                                                icon: hidePass
                                                                        .value
                                                                    ? const Icon(
                                                                        Icons
                                                                            .remove_red_eye_outlined,
                                                                        color: Colors
                                                                            .green,
                                                                      )
                                                                    : const Icon(
                                                                        Icons
                                                                            .remove_red_eye_rounded,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                              ),
                                                              enabledBorder:
                                                                  const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .green),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                              ),
                                                              focusedBorder:
                                                                  const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .green),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                              ),
                                                              border:
                                                                  const OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                              labelText:
                                                                  'Mật khẩu mới',
                                                              labelStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: Get.height *
                                                                0.01,
                                                          ),
                                                          TextFormField(
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 14,
                                                            ),
                                                            controller:
                                                                confPassController
                                                                    .value,
                                                            validator: (value) {
                                                              if (value!
                                                                      .isEmpty ||
                                                                  value.trim() ==
                                                                      '') {
                                                                return 'Mật khẩu không được rỗng';
                                                              }
                                                              final RegExp
                                                                  passRegExp =
                                                                  RegExp(
                                                                      r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$");
                                                              if (!passRegExp
                                                                  .hasMatch(
                                                                      value)) {
                                                                return 'Mật khẩu ít nhất 6 ký tự. Bao gồm: \nchữ hoa, chữ thường, số và ký tự đặc biệt.';
                                                              }
                                                              if (value !=
                                                                  newPassController
                                                                      .value
                                                                      .text) {
                                                                return 'Xác nhận mật khẩu không trùng khớp.';
                                                              }
                                                              return null;
                                                            },
                                                            obscureText:
                                                                hidePassConf
                                                                    .value,
                                                            decoration:
                                                                InputDecoration(
                                                              suffixIcon:
                                                                  IconButton(
                                                                onPressed: () {
                                                                  hidePassConf
                                                                          .value =
                                                                      !hidePassConf
                                                                          .value;
                                                                },
                                                                icon: hidePassConf
                                                                        .value
                                                                    ? const Icon(
                                                                        Icons
                                                                            .remove_red_eye_outlined,
                                                                        color: Colors
                                                                            .green,
                                                                      )
                                                                    : const Icon(
                                                                        Icons
                                                                            .remove_red_eye_rounded,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                              ),
                                                              enabledBorder:
                                                                  const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .green),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                              ),
                                                              focusedBorder:
                                                                  const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .green),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                              ),
                                                              border:
                                                                  const OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                              labelText:
                                                                  'Xác nhận mật khẩu',
                                                              labelStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: Get.width,
                                                  child: ElevatedButton(
                                                    style: const ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStatePropertyAll(
                                                              Colors.green),
                                                      foregroundColor:
                                                          WidgetStatePropertyAll(
                                                              Colors.white),
                                                    ),
                                                    onPressed: () async {
                                                      if (formKey.currentState!
                                                          .validate()) {
                                                        Get.find<MainController>()
                                                                .buyer
                                                                .value
                                                                .password =
                                                            newPassController
                                                                .value.text;
                                                        Get.back();
                                                        await Get.find<
                                                                BuyerController>()
                                                            .updatePassword(
                                                                Get.find<
                                                                        MainController>()
                                                                    .buyer
                                                                    .value);
                                                        // ignore: use_build_context_synchronously
                                                        await AwesomeDialog(
                                                          titleTextStyle:
                                                              const TextStyle(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 22,
                                                          ),
                                                          descTextStyle:
                                                              const TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 16,
                                                          ),
                                                          context: context,
                                                          dialogType: DialogType
                                                              .success,
                                                          animType: AnimType
                                                              .rightSlide,
                                                          title:
                                                              'Cập nhật mật khẩu thành công',
                                                          btnOkOnPress: () {},
                                                        ).show();
                                                      }
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration:
                                                          const BoxDecoration(),
                                                      // width: Get.width * 0.8,
                                                      child: const Text(
                                                        'Cập nhật',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.05,
                                      vertical: Get.width * 0.01,
                                    ),
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
                                        await Get.find<BuyerController>()
                                            .logout();
                                        mainController.isLoading.value = false;
                                        // Get.find<CartController>().listCart.value = [];
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
    });
  }
}
