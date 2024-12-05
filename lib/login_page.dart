// import 'package:awesome_dialog/awesome_dialog.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/buyer_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/buyer.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';

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
                                Get.find<ProductController>()
                                    .loadProductActive();
                                mainController.isLoading.value = false;
                                mainController.numPage.value = 0;
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
                                    'https://res.cloudinary.com/dg3p7nxyp/image/upload/v1722935387/app/logo_remove_bg.png'),
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
                                    onTap: () async {
                                      showFormEmail(context);

                                      // await Get.find<MainController>().sendMail(
                                      //     'emailSeller',
                                      //     'subject',
                                      //     'text',
                                      //     'html');
                                    },
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
                                            if (mainController.buyer.value.id !=
                                                    '' &&
                                                mainController
                                                        .buyer.value.status !=
                                                    'inactive') {
                                              Get.toNamed('/');
                                            } else if (mainController
                                                        .buyer.value.id !=
                                                    '' &&
                                                mainController
                                                        .buyer.value.status ==
                                                    'inactive') {
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
                                              mainController.buyer.value =
                                                  Buyer.initBuyer();
                                              mainController.seller.value =
                                                  Seller.initSeller();
                                            } else {}
                                          } else {
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
                                        backgroundColor: WidgetStatePropertyAll(
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
                                        // await mainController.loadAll();
                                        Get.toNamed('/register');
                                      },
                                      style: const ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
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

  void showFormEmail(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    TextEditingController emailController = TextEditingController();
    var keyForgot = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quên mật khẩu',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.green,
                  ),
                )
              ],
            ),
            const Divider(),
          ],
        ),
        content: Container(
          width: Get.width * 0.9,
          height: Get.height * 0.15,
          decoration: const BoxDecoration(),
          child: Form(
            key: keyForgot,
            child: ListView(
              children: [
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == '' || value!.isEmpty) {
                      return 'Hãy nhập email';
                    }
                    final RegExp emailRegExp =
                        RegExp(r"^[\w-\.]+@([\w-]+\.){1,}[\w-]{1,}$");
                    if (!emailRegExp.hasMatch(value)) {
                      return 'Email không hợp lệ.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (keyForgot.currentState!.validate()) {
                if (await Get.find<BuyerController>()
                    .checkExistEmail(emailController.text)) {
                  mainController.typeForgot.value = 'buyer';
                } else if (await Get.find<SellerController>()
                    .checkExistEmail(emailController.text)) {
                  mainController.typeForgot.value = 'seller';
                } else {
                  mainController.typeForgot.value = '';
                }
                if (mainController.typeForgot.value == '') {
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
                    title: 'Lỗi!',
                    desc: 'Email không tồn tại.',
                    btnOkOnPress: () {},
                  ).show();
                } else {
                  Get.back();
                  mainController.sendOtp(emailController.text);
                  showFormOTP(emailController.text);
                }
              }
            },
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.green),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(),
              height: Get.width * 0.1,
              width: Get.width * 0.8,
              child: const Text(
                'Gửi mã OTP',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showFormOTP(String email) {
    MainController mainController = Get.find<MainController>();
    TextEditingController otpController = TextEditingController();
    var keyOTP = GlobalKey<FormState>();
    Get.dialog(
      AlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quên mật khẩu',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.green,
                  ),
                )
              ],
            ),
            const Divider(),
          ],
        ),
        content: Container(
          width: Get.width * 0.9,
          height: Get.height * 0.15,
          decoration: const BoxDecoration(),
          child: Form(
            key: keyOTP,
            child: ListView(
              children: [
                TextFormField(
                  controller: otpController,
                  validator: (value) {
                    if (value == '' || value!.isEmpty) {
                      return 'Hãy nhập mã OTP';
                    }
                    if (value != mainController.otpCode.value) {
                      return 'Mã OTP không đúng';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    labelText: 'Mã OTP',
                    labelStyle: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (keyOTP.currentState!.validate()) {
                Get.back();
                showFormChangePassword(email);
              }
            },
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.green),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(),
              height: Get.width * 0.1,
              width: Get.width * 0.8,
              child: const Text(
                'Xác nhận',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showFormChangePassword(String email) {
    var keyFormPass = GlobalKey<FormState>();
    Rx<TextEditingController> newPassController = TextEditingController().obs;
    Rx<TextEditingController> confPassController = TextEditingController().obs;
    RxBool hidePass = true.obs;
    RxBool hidePassConf = true.obs;
    Get.dialog(
      Obx(
        () => AlertDialog(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quên mật khẩu',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
              const Divider(),
            ],
          ),
          content: Container(
            width: Get.width * 0.9,
            height: Get.height * 0.2,
            decoration: const BoxDecoration(),
            child: Form(
                key: keyFormPass,
                child: ListView(
                  children: [
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                      ),
                      controller: newPassController.value,
                      validator: (value) {
                        if (value!.isEmpty || value.trim() == '') {
                          return 'Mật khẩu không được rỗng';
                        }
                        final RegExp passRegExp = RegExp(
                            r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$");
                        if (!passRegExp.hasMatch(value)) {
                          return 'Mật khẩu ít nhất 6 ký tự. Bao gồm: \nchữ hoa, chữ thường, số và ký tự đặc biệt.';
                        }
                        return null;
                      },
                      obscureText: hidePass.value,
                      decoration: InputDecoration(
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
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: 'Mật khẩu mới',
                        labelStyle: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                      ),
                      controller: confPassController.value,
                      validator: (value) {
                        if (value!.isEmpty || value.trim() == '') {
                          return 'Mật khẩu không được rỗng';
                        }
                        final RegExp passRegExp = RegExp(
                            r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$");
                        if (!passRegExp.hasMatch(value)) {
                          return 'Mật khẩu ít nhất 6 ký tự. Bao gồm: \nchữ hoa, chữ thường, số và ký tự đặc biệt.';
                        }
                        if (value != newPassController.value.text) {
                          return 'Xác nhận mật khẩu không trùng khớp.';
                        }
                        return null;
                      },
                      obscureText: hidePassConf.value,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            hidePassConf.value = !hidePassConf.value;
                          },
                          icon: hidePassConf.value
                              ? const Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.remove_red_eye_rounded,
                                  color: Colors.green,
                                ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: 'Xác nhận mật khẩu',
                        labelStyle: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (keyFormPass.currentState!.validate()) {
                  Get.back();
                  Get.find<MainController>().isLoading.value = true;
                  if (Get.find<MainController>().typeForgot.value == 'buyer') {
                    await Get.find<BuyerController>()
                        .forgotPassword(email, newPassController.value.text);
                  } else if (Get.find<MainController>().typeForgot.value ==
                      'seller') {
                    await Get.find<SellerController>()
                        .forgotPassword(email, newPassController.value.text);
                  }

                  Get.find<MainController>().isLoading.value = false;
                }
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.green),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(),
                height: Get.width * 0.1,
                width: Get.width * 0.8,
                child: const Text(
                  'Cập nhật mật khẩu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
