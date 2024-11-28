import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/buyer_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/cloudinary_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/province_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/buyer.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    Get.put(BuyerController());
    Get.put(SellerController());
    MainController mainController = Get.find<MainController>();
    BuyerController buyerController = Get.find<BuyerController>();
    SellerController sellerController = Get.find<SellerController>();

    // final cloudinary = Cloudinary.signedConfig(
    //   apiKey: Config.apiKey,
    //   apiSecret: Config.apiSecret,
    //   cloudName: Config.cloudName,
    // );

    final formKey = GlobalKey<FormState>();
    final List<String> typeUser = ['Người bán', 'Người mua'];
    RxString typeUserValue = 'Người mua'.obs;

    Rx<TextEditingController> usernameController = TextEditingController().obs;
    Rx<TextEditingController> phoneController = TextEditingController().obs;
    Rx<TextEditingController> emailController = TextEditingController().obs;
    Rx<TextEditingController> nameController = TextEditingController().obs;
    Rx<TextEditingController> passwordController = TextEditingController().obs;
    Rx<TextEditingController> passwordConfController =
        TextEditingController().obs;
    TextEditingController().obs;

    Rx<TextEditingController> addressDetailController =
        TextEditingController().obs;
    Rx<TextEditingController> taxCodeController = TextEditingController().obs;

    RxBool hidePass = true.obs;
    RxBool hidePassConf = true.obs;
    RxString filePath = ''.obs;
    final picker = ImagePicker();

    RxList<Province> listProvince = <Province>[
      Province(id: '0', name: 'Chọn tỉnh thành'),
    ].obs;
    // ignore: invalid_use_of_protected_member
    Rx<Province> province = listProvince.value[0].obs;
    listProvince.addAll(Get.find<ProvinceController>().listProvince);
    return Obx(
      () {
        return buyerController.isLoading.value ||
                mainController.isLoading.value ||
                sellerController.isLoading.value
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
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              label: const Text(''),
                            ),
                            const Text(
                              'ĐĂNG KÝ',
                              style: TextStyle(
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
                            Column(
                              children: [
                                Form(
                                  key: formKey,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    margin: const EdgeInsets.only(
                                      left: 10,
                                      bottom: 10,
                                      right: 10,
                                      top: 30,
                                    ),
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
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'Tạo tài khoản  ',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            DropdownButton(
                                              items: typeUser
                                                  .map((item) =>
                                                      DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(
                                                          item,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.green,
                                                          ),
                                                          // overflow:
                                                          //     TextOverflow.ellipsis,
                                                        ),
                                                      ))
                                                  .toList(),
                                              value: typeUserValue.value,
                                              onChanged: (value) {
                                                typeUserValue.value = value!;
                                              },
                                            ),
                                          ],
                                        ),
                                        TextFormField(
                                          controller: usernameController.value,
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                          ),
                                          decoration: const InputDecoration(
                                            label: Text('Tên đăng nhập'),
                                            labelStyle: TextStyle(
                                              fontSize: 18,
                                              color: Colors.green,
                                            ),
                                            errorStyle: TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Hãy nhập tên đăng nhập';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: nameController.value,
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                          ),
                                          decoration: const InputDecoration(
                                            label: Text('Họ và Tên'),
                                            labelStyle: TextStyle(
                                              fontSize: 18,
                                              color: Colors.green,
                                            ),
                                            errorStyle: TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Hãy nhập họ và tên.';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: phoneController.value,
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                          ),
                                          decoration: const InputDecoration(
                                            label: Text('Số điện thoại'),
                                            labelStyle: TextStyle(
                                              fontSize: 18,
                                              color: Colors.green,
                                            ),
                                            errorStyle: TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Hãy nhập số điện thoại.';
                                            }
                                            final RegExp phoneRegExp = RegExp(
                                                r"(84|0[3|5|7|8|9])+([0-9]{8})\b");
                                            if (!phoneRegExp.hasMatch(value)) {
                                              return 'Số điện thoại không hợp lệ.';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: emailController.value,
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                          ),
                                          decoration: const InputDecoration(
                                            label: Text('Email'),
                                            labelStyle: TextStyle(
                                              fontSize: 18,
                                              color: Colors.green,
                                            ),
                                            errorStyle: TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Hãy nhập email';
                                            }
                                            final RegExp emailRegExp = RegExp(
                                                r"^[\w-\.]+@([\w-]+\.){1,}[\w-]{1,}$");
                                            if (!emailRegExp.hasMatch(value)) {
                                              return 'Email không hợp lệ.';
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
                                            label: const Text('Mật khẩu'),
                                            labelStyle: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.green,
                                            ),
                                            errorStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                            ),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                hidePass.value =
                                                    !hidePass.value;
                                              },
                                              icon: hidePass.value
                                                  ? const Icon(
                                                      Icons
                                                          .remove_red_eye_outlined,
                                                      color: Colors.green,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .remove_red_eye_rounded,
                                                      color: Colors.green,
                                                    ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Hãy nhập mật khẩu';
                                            }
                                            final RegExp passRegExp = RegExp(
                                                r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$");
                                            if (!passRegExp.hasMatch(value)) {
                                              return 'Mật khẩu ít nhất 6 ký tự.\nBao gồm: chữ hoa, chữ thường, số\n và ký tự đặc biệt.';
                                            }
                                            if (passwordConfController
                                                    .value.text.isNotEmpty &&
                                                value !=
                                                    passwordConfController
                                                        .value.text) {
                                              return 'Xác nhận mật khẩu không trùng khớp.';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller:
                                              passwordConfController.value,
                                          obscureText: hidePassConf.value,
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                          ),
                                          decoration: InputDecoration(
                                            label:
                                                const Text('Xác nhận mật khẩu'),
                                            labelStyle: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.green,
                                            ),
                                            errorStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                            ),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                hidePassConf.value =
                                                    !hidePassConf.value;
                                              },
                                              icon: hidePassConf.value
                                                  ? const Icon(
                                                      Icons
                                                          .remove_red_eye_outlined,
                                                      color: Colors.green,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .remove_red_eye_rounded,
                                                      color: Colors.green,
                                                    ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Hãy xác nhận lại mật khẩu';
                                            }
                                            final RegExp passRegExp = RegExp(
                                                r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,}$");
                                            if (!passRegExp.hasMatch(value)) {
                                              return 'Mật khẩu ít nhất 6 ký tự.\nBao gồm: chữ hoa, chữ thường, số\n và ký tự đặc biệt.';
                                            }
                                            if (passwordConfController
                                                    .value.text.isNotEmpty &&
                                                value !=
                                                    passwordController
                                                        .value.text) {
                                              return 'Xác nhận mật khẩu không trùng khớp.';
                                            }
                                            return null;
                                          },
                                        ),
                                        typeUserValue.value == 'Người bán'
                                            ? Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Tỉnh thành phố',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      DropdownButton(
                                                        menuMaxHeight:
                                                            Get.height / 2,
                                                        items: listProvince
                                                            // ignore: invalid_use_of_protected_member
                                                            .value
                                                            .map(
                                                              (Province item) =>
                                                                  DropdownMenuItem<
                                                                      Province>(
                                                                value: item,
                                                                child: Text(
                                                                  item.name,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                            .toList(),
                                                        value: province.value,
                                                        onChanged: (item) {
                                                          province.value =
                                                              item!;
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        addressDetailController
                                                            .value,
                                                    style: const TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 18,
                                                    ),
                                                    minLines: 1,
                                                    maxLines: 5,
                                                    decoration:
                                                        const InputDecoration(
                                                      label: Text('Địa chỉ'),
                                                      labelStyle: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      if (province.value.id ==
                                                          '0') {
                                                        return 'Vui lòng chọn Tỉnh thành phố.';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        taxCodeController.value,
                                                    style: const TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 18,
                                                    ),
                                                    decoration:
                                                        const InputDecoration(
                                                      label: Text('Mã số thuế'),
                                                      labelStyle: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Row(
                                          children: [
                                            Text(
                                              'Ảnh đại diện',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: filePath.value == ''
                                                ? const DecorationImage(
                                                    image: NetworkImage(
                                                      'https://res.cloudinary.com/dg3p7nxyp/image/upload/v1723018608/account_default.png',
                                                    ),
                                                    // fit: BoxFit.fill,
                                                  )
                                                : DecorationImage(
                                                    image: FileImage(
                                                      File(
                                                        filePath.value,
                                                      ),
                                                    ),
                                                    // fit: BoxFit.contain,
                                                  ),
                                          ),
                                          height: 120,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            filePath.value != ''
                                                ? TextButton.icon(
                                                    onPressed: () {
                                                      filePath.value = '';
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.green,
                                                    ),
                                                    label: const Text(
                                                      'Xóa ảnh',
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            TextButton.icon(
                                              onPressed: () async {
                                                final RxString typeSource =
                                                    ''.obs;
                                                final XFile? pickedFile;
                                                await showModalBottomSheet(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SizedBox(
                                                        height: 120,
                                                        width: Get.width,
                                                        child: Column(
                                                          children: [
                                                            TextButton.icon(
                                                              onPressed: () {
                                                                typeSource
                                                                        .value =
                                                                    'gallery';
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: const Icon(
                                                                Icons.image,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              label: const Text(
                                                                'Chọn ảnh từ thư viện',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                            TextButton.icon(
                                                              onPressed: () {
                                                                typeSource
                                                                        .value =
                                                                    'camera';
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .camera_alt_outlined,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              label: const Text(
                                                                'Chụp một ảnh mới',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                                if (typeSource.value ==
                                                    'camera') {
                                                  pickedFile =
                                                      await picker.pickImage(
                                                    source: ImageSource.camera,
                                                    imageQuality: 90,
                                                    preferredCameraDevice:
                                                        CameraDevice.front,
                                                  );
                                                } else if (typeSource.value ==
                                                    'gallery') {
                                                  pickedFile =
                                                      await picker.pickImage(
                                                    source: ImageSource.gallery,
                                                  );
                                                } else {
                                                  return;
                                                }
                                                if (pickedFile != null) {
                                                  filePath.value = pickedFile
                                                      .path
                                                      .toString();
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.green,
                                              ),
                                              label: const Text(
                                                'Chọn ảnh',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 150,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    if (typeUserValue.value ==
                                                        'Người mua') {
                                                      buyerController.isLoading
                                                          .value = true;
                                                      Buyer buyer = Buyer(
                                                        id: '',
                                                        username:
                                                            usernameController
                                                                .value.text,
                                                        email: emailController
                                                            .value.text,
                                                        phone: phoneController
                                                            .value.text,
                                                        password:
                                                            passwordController
                                                                .value.text,
                                                        name: nameController
                                                            .value.text,
                                                        create_at:
                                                            Timestamp.now(),
                                                        status: 'active',
                                                      );
                                                      // ignore: use_build_context_synchronously
                                                      if (await createBuyer(
                                                          buyer,
                                                          buyerController,
                                                          context,
                                                          // cloudinary,
                                                          filePath.value)) {
                                                        clearAll(
                                                            usernameController,
                                                            nameController,
                                                            phoneController,
                                                            emailController,
                                                            passwordController,
                                                            passwordConfController,
                                                            addressDetailController,
                                                            taxCodeController,
                                                            filePath,
                                                            province,
                                                            listProvince);
                                                        Get.toNamed('/login');
                                                      } else {}
                                                    } else {
                                                      sellerController.isLoading
                                                          .value = true;
                                                      Seller seller =
                                                          Seller.initSeller();
                                                      // Seller(id: id, username: username, email: email, phone: phone, password: password, name: name, create_at: create_at, status: status, address_detail: address_detail, province_id: province_id)
                                                      seller.username =
                                                          usernameController
                                                              .value.text;
                                                      seller.email =
                                                          emailController
                                                              .value.text;
                                                      seller.phone =
                                                          phoneController
                                                              .value.text;
                                                      seller.password =
                                                          passwordController
                                                              .value.text;
                                                      seller.name =
                                                          nameController
                                                              .value.text;
                                                      seller.address_detail =
                                                          addressDetailController
                                                              .value.text;
                                                      seller.province_id =
                                                          province.value.id;
                                                      if (await createSeller(
                                                          seller,
                                                          sellerController,
                                                          context,
                                                          filePath.value)) {
                                                        clearAll(
                                                            usernameController,
                                                            nameController,
                                                            phoneController,
                                                            emailController,
                                                            passwordController,
                                                            passwordConfController,
                                                            addressDetailController,
                                                            taxCodeController,
                                                            filePath,
                                                            province,
                                                            listProvince);
                                                        Get.toNamed('/login');
                                                      }
                                                    }
                                                  }
                                                },
                                                style: const ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStatePropertyAll(
                                                    Colors.lightGreen,
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Đăng ký',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  void clearAll(
      Rx<TextEditingController> usernameController,
      Rx<TextEditingController> nameController,
      Rx<TextEditingController> phoneController,
      Rx<TextEditingController> emailController,
      Rx<TextEditingController> passwordController,
      Rx<TextEditingController> passwordConfController,
      Rx<TextEditingController> addressDetailController,
      Rx<TextEditingController> taxCodeController,
      RxString filePath,
      Rx<Province> province,
      RxList<Province> listProvince) {
    usernameController.value.clear();
    nameController.value.clear();
    phoneController.value.clear();
    emailController.value.clear();
    passwordController.value.clear();
    passwordConfController.value.clear();
    addressDetailController.value.clear();
    taxCodeController.value.clear();
    filePath.value = '';
    // ignore: invalid_use_of_protected_member
    province.value = listProvince.value[0];
  }

  Future<bool> createBuyer(Buyer buyer, BuyerController buyerController,
      BuildContext context, String filePath) async {
    if (await buyerController.checkExistUsername(buyer.username) ||
        await Get.find<SellerController>().checkExistUsername(buyer.username)) {
      buyerController.isLoading.value = false;
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
        title: 'Lỗi!',
        desc: 'Tên đăng nhập đã tồn tại.',
        btnOkOnPress: () {},
      ).show();
      return false;
    }
    if (await buyerController.checkExistPhone(buyer.phone)) {
      buyerController.isLoading.value = false;
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
        title: 'Lỗi!',
        desc: 'Số điện thoại đã tồn tại.',
        btnOkOnPress: () {},
      ).show();
      return false;
    }

    if (await buyerController.checkExistEmail(buyer.email) ||
        await Get.find<SellerController>().checkExistEmail(buyer.email)) {
      buyerController.isLoading.value = false;
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
        title: 'Lỗi!',
        desc: 'Email đã tồn tại.',
        btnOkOnPress: () {},
      ).show();
      return false;
    }

    buyer.avatar = await CloudinaryController().uploadImage(
        filePath, '${buyer.username}_avatar', 'seller/${buyer.username}');

    await buyerController.createBuyer(buyer);
    buyerController.isLoading.value = false;
    // ignore: use_build_context_synchronously
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Thành công',
      desc: 'Đăng ký tài khoản người mua thành công.',
      btnOkOnPress: () {},
    ).show();
    return true;
  }

  Future<bool> createSeller(Seller seller, SellerController sellerController,
      BuildContext context, String filePath) async {
    if (await sellerController.checkExistUsername(seller.username) ||
        await Get.find<BuyerController>().checkExistUsername(seller.username)) {
      sellerController.isLoading.value = false;
      // ignore: use_build_context_synchronously
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Lỗi!',
        desc: 'Tên đăng nhập đã tồn tại.',
        btnOkOnPress: () {},
      ).show();
      return false;
    }
    if (await sellerController.checkExistPhone(seller.phone)) {
      sellerController.isLoading.value = false;
      // ignore: use_build_context_synchronously
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Lỗi!',
        desc: 'Số điện thoại đã tồn tại.',
        btnOkOnPress: () {},
      ).show();
      return false;
    }
    if (await sellerController.checkExistEmail(seller.email) ||
        await Get.find<BuyerController>().checkExistEmail(seller.email)) {
      sellerController.isLoading.value = false;
      // ignore: use_build_context_synchronously
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Lỗi!',
        desc: 'Email đã tồn tại.',
        btnOkOnPress: () {},
      ).show();
      return false;
    }
    seller.avatar = await CloudinaryController().uploadImage(
        filePath, '${seller.username}_avatar', 'seller/${seller.username}');
    await sellerController.createSeller(seller);

    sellerController.isLoading.value = false;
    // ignore: use_build_context_synchronously
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Thành công',
      desc: 'Đăng ký tài khoản người bán thành công.',
      btnOkOnPress: () {},
    ).show();
    return true;
  }
}
