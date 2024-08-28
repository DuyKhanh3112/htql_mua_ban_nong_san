// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    MainController mainController = Get.find<MainController>();
    // RxString title = 'Đăng Nhập'.obs;
    Rx<TextEditingController> usernameController = TextEditingController().obs;
    Rx<TextEditingController> passwordController = TextEditingController().obs;
    RxBool hidePass = true.obs;

    final formKey = GlobalKey<FormState>();

    return Obx(() {
      return mainController.isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                body: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(bottom: 20),
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
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: Get.width * 0.1,
                            child: InkWell(
                              onTap: () async {
                                mainController.isLoading.value = true;
                                await Get.find<ProductController>()
                                    .loadAllProduct();
                                mainController.isLoading.value = false;
                                Get.toNamed('/');
                              },
                              child: const Icon(
                                Icons.home,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: Get.width * 0.8,
                            child: const Text(
                              'ĐĂNG NHẬP',
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: NetworkImage(
                                    'https://res.cloudinary.com/dg3p7nxyp/image/upload/v1722935387/app/logo.jpg'),
                                // height: 100,
                                width: 150,
                              ),
                            ],
                          ),
                          Form(
                            key: formKey,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.only(
                                left: 10,
                                bottom: 10,
                                right: 10,
                                top: 40,
                              ),

                              // height: Get.height * 2 / 5,
                              // width: Get.width * 2 / 4,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(4.0, 4.0),
                                    blurRadius: 10.0,
                                    spreadRadius: 1.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceAround,
                                children: [
                                  TextFormField(
                                    controller: usernameController.value,
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 18,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Tên đăng nhập',
                                      icon: Icon(
                                        Icons.account_circle_outlined,
                                        color: Colors.green,
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green,
                                      ),
                                      errorStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Hãy nhập tên đăng nhập';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: passwordController.value,
                                    obscureText: hidePass.value,
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Mật khẩu',
                                      icon: const Icon(
                                        Icons.lock_person_outlined,
                                        color: Colors.green,
                                      ),
                                      hintStyle: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.green,
                                      ),
                                      errorStyle: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          hidePass.value = !hidePass.value;
                                        },
                                        icon: hidePass.value
                                            ? const Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: Colors.green,
                                              )
                                            : const Icon(
                                                Icons.remove_red_eye_rounded,
                                                color: Colors.green,
                                              ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Hãy nhập mật khẩu';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Quên mật khẩu ?',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () async {},
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    // color: Colors.green,
                                    width: Get.width,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          if (await mainController.login(
                                              usernameController.value.text,
                                              passwordController.value.text)) {
                                            // ignore: use_build_context_synchronously
                                            if (mainController.buyer.value.id !=
                                                    '' &&
                                                mainController
                                                        .buyer.value.status !=
                                                    'inactive') {
                                              // Get.toNamed('/');
                                            } else if (mainController
                                                        .buyer.value.id !=
                                                    '' &&
                                                mainController
                                                        .buyer.value.status ==
                                                    'inactive') {
                                              // ignore: use_build_context_synchronously
                                              await AwesomeDialog(
                                                titleTextStyle: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                ),
                                                descTextStyle: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16,
                                                ),
                                                context: context,
                                                dialogType: DialogType.warning,
                                                animType: AnimType.rightSlide,
                                                title:
                                                    'Đăng nhập không thành công!',
                                                desc:
                                                    'Tài khoản của bạn đã bị khóa.',
                                                btnOkOnPress: () {},
                                              ).show();
                                            } else {}
                                          } else {
                                            // ignore: use_build_context_synchronously
                                            await AwesomeDialog(
                                              titleTextStyle: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                              ),
                                              descTextStyle: const TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                              ),
                                              context: context,
                                              dialogType: DialogType.error,
                                              animType: AnimType.rightSlide,
                                              title:
                                                  'Đăng nhập không thành công!',
                                              desc:
                                                  'Tên đăng nhập hoặc Mật khẩu không đúng. Vui lòng kiểm tra lại Tên đăng nhập và Mật khẩu.',
                                              btnOkOnPress: () {},
                                            ).show();
                                          }
                                          usernameController.value.clear();
                                          passwordController.value.clear();
                                        }
                                      },
                                      style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                          Colors.green,
                                        ),
                                      ),
                                      child: const Text(
                                        'Đăng nhập',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 2,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: Get.width,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await mainController.loadAll();
                                        Get.toNamed('/register');
                                      },
                                      style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                          Colors.lightGreen,
                                        ),
                                      ),
                                      child: const Text(
                                        'Tạo tài khoản mới',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
    });
  }
}
