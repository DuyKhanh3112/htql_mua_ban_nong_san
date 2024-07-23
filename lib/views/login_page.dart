import 'dart:io';

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    MainController mainController = Get.find<MainController>();
    RxString title = 'Đăng Nhập'.obs;
    Rx<TextEditingController> loginController = TextEditingController().obs;
    Rx<TextEditingController> passwordController = TextEditingController().obs;
    RxBool hidePass = true.obs;

    final formKey = GlobalKey<FormState>();

    return Obx(() {
      return mainController.isLoading.value
          ? LoadingPage()
          : SafeArea(
              child: Scaffold(
                body: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(bottom: 20),
                      height: 100,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title.value,
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          // SizedBox(
                          //   height: Get.height / 10,
                          // ),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Xin chào!', style: TextStyle(fontSize: 16)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Chao mung ban den voi  ',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Image(
                                    image: NetworkImage(
                                        'https://gudlogo.com/wp-content/uploads/2019/04/logo-hinh-chu-nhat-8.png'),
                                    // width: 100,
                                    height: 40,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Image(
                                image: NetworkImage(
                                    'https://gudlogo.com/wp-content/uploads/2019/04/logo-hinh-chu-nhat-8.png'),
                                height: 100,
                              )
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
                                top: 50,
                              ),
                              height: Get.height * 2 / 5,
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
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextFormField(
                                    controller: loginController.value,
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
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        await mainController.login(
                                            loginController.value.text,
                                            passwordController.value.text);
                                        if (mainController.isLogin.value) {
                                          Get.toNamed('/');
                                        } else {
                                          // ignore: use_build_context_synchronously
                                          await AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.error,
                                            animType: AnimType.rightSlide,
                                            title: "Đăng nhập không thành công",
                                            desc:
                                                "Tên đăng nhập hoặc mật khẩu không đúng!",
                                            btnOkOnPress: () {},
                                          ).show();
                                        }
                                      }
                                    },
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.green),
                                    ),
                                    child: const Text(
                                      'Đăng nhập',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
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
