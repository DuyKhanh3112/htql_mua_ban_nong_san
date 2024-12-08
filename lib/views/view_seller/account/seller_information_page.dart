// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:convert_vietnamese/convert_vietnamese.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/province_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/drawer_seller.dart';
import 'package:image_picker/image_picker.dart';

class SellerInformationPage extends StatelessWidget {
  const SellerInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    MainController mainController = Get.find<MainController>();
    RxString filePathCover = ''.obs;
    RxString filePathAvatar = ''.obs;
    Rx<TextEditingController> nameController =
        TextEditingController(text: mainController.seller.value.name).obs;
    Rx<TextEditingController> phoneController =
        TextEditingController(text: mainController.seller.value.phone).obs;
    Rx<TextEditingController> taxCodeController =
        TextEditingController(text: mainController.seller.value.tax_code).obs;
    Rx<TextEditingController> addressDetailController =
        TextEditingController(text: mainController.seller.value.address_detail)
            .obs;

    Rx<Province> province =
        (Get.find<ProvinceController>().listProvince.firstWhereOrNull(
                      (p0) => p0.id == mainController.seller.value.province_id,
                    ) ??
                Province.initProvince())
            .obs;

    Rx<TextEditingController> provinceController = TextEditingController().obs;

    return Obx(() {
      return Get.find<SellerController>().isLoading.value
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
                  actions: [
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'refesh') {
                          await refershData(
                              filePathAvatar,
                              filePathCover,
                              nameController,
                              mainController,
                              phoneController,
                              taxCodeController,
                              province,
                              addressDetailController,
                              provinceController);
                        }
                        if (value == 'fogot_password') {
                          fogotPassword(mainController, context);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'refesh',
                          child: ListTile(
                            leading: Icon(Icons.refresh),
                            title: Text('Làm mới'),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'fogot_password',
                          child: ListTile(
                            leading: Icon(Icons.password),
                            title: Text('Cập nhật mật khẩu'),
                            // onTap: () async {
                            //   fogotPassword(mainController, context);
                            // },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                body: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      Stack(
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  final RxString typeSource = ''.obs;
                                  final XFile? pickedFile;

                                  await showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: 120,
                                          width: Get.width,
                                          child: Column(
                                            children: [
                                              TextButton.icon(
                                                onPressed: () {
                                                  typeSource.value = 'gallery';
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(
                                                  Icons.image,
                                                  color: Colors.green,
                                                ),
                                                label: const Text(
                                                  'Chọn ảnh từ thư viện',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              TextButton.icon(
                                                onPressed: () {
                                                  typeSource.value = 'camera';
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: Colors.green,
                                                ),
                                                label: const Text(
                                                  'Chụp một ảnh mới',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });

                                  if (typeSource.value == 'camera') {
                                    pickedFile = await ImagePicker().pickImage(
                                      source: ImageSource.camera,
                                      imageQuality: 90,
                                      preferredCameraDevice: CameraDevice.front,
                                    );
                                  } else if (typeSource.value == 'gallery') {
                                    pickedFile = await ImagePicker().pickImage(
                                      source: ImageSource.gallery,
                                    );
                                  } else {
                                    return;
                                  }
                                  if (pickedFile != null) {
                                    filePathCover.value = pickedFile.path;
                                  }
                                },
                                child: Container(
                                  height: Get.width * 0.35,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    // shape: BoxShape.circle,
                                    color: Get.find<MainController>()
                                                    .seller
                                                    .value
                                                    .cover ==
                                                '' &&
                                            filePathCover.value == ''
                                        ? Colors.black12
                                        : null,
                                    image: Get.find<MainController>()
                                                .seller
                                                .value
                                                .cover ==
                                            ''
                                        ? filePathCover.value == ''
                                            ? null
                                            : DecorationImage(
                                                image: FileImage(
                                                  File(filePathCover.value),
                                                ),
                                                fit: BoxFit.fill,
                                              )
                                        : filePathCover.value == ''
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                    Get.find<MainController>()
                                                        .seller
                                                        .value
                                                        .cover!),
                                                fit: BoxFit.fill,
                                              )
                                            : DecorationImage(
                                                image: FileImage(
                                                  File(filePathCover.value),
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Get.height * 0.03,
                                width: Get.width,
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            left: Get.width * 0.05,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final RxString typeSource = ''.obs;
                                    final XFile? pickedFile;

                                    await showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SizedBox(
                                            height: 120,
                                            width: Get.width,
                                            child: Column(
                                              children: [
                                                TextButton.icon(
                                                  onPressed: () {
                                                    typeSource.value =
                                                        'gallery';
                                                    Navigator.pop(context);
                                                  },
                                                  icon: const Icon(
                                                    Icons.image,
                                                    color: Colors.green,
                                                  ),
                                                  label: const Text(
                                                    'Chọn ảnh từ thư viện',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                                TextButton.icon(
                                                  onPressed: () {
                                                    typeSource.value = 'camera';
                                                    Navigator.pop(context);
                                                  },
                                                  icon: const Icon(
                                                    Icons.camera_alt_outlined,
                                                    color: Colors.green,
                                                  ),
                                                  label: const Text(
                                                    'Chụp một ảnh mới',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });

                                    if (typeSource.value == 'camera') {
                                      pickedFile =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.camera,
                                        imageQuality: 90,
                                        preferredCameraDevice:
                                            CameraDevice.front,
                                      );
                                    } else if (typeSource.value == 'gallery') {
                                      pickedFile =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.gallery,
                                      );
                                    } else {
                                      return;
                                    }
                                    if (pickedFile != null) {
                                      filePathAvatar.value = pickedFile.path;
                                    }
                                  },
                                  child: Container(
                                    height: Get.width * 0.2,
                                    width: Get.width * 0.2,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Get.find<MainController>()
                                                      .seller
                                                      .value
                                                      .avatar ==
                                                  '' &&
                                              filePathAvatar.value == ''
                                          ? Colors.black12
                                          : null,
                                      image: Get.find<MainController>()
                                                  .seller
                                                  .value
                                                  .avatar ==
                                              ''
                                          ? filePathAvatar.value == ''
                                              ? null
                                              : DecorationImage(
                                                  image: FileImage(
                                                    File(filePathAvatar.value),
                                                  ),
                                                  fit: BoxFit.fill,
                                                )
                                          : filePathAvatar.value == ''
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                      Get.find<MainController>()
                                                          .seller
                                                          .value
                                                          .avatar!),
                                                  fit: BoxFit.fill,
                                                )
                                              : DecorationImage(
                                                  image: FileImage(
                                                    File(filePathAvatar.value),
                                                  ),
                                                  fit: BoxFit.fill,
                                                ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.05,
                                ),
                                SizedBox(
                                  width: Get.width * 0.6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Get.find<MainController>()
                                            .seller
                                            .value
                                            .username,
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '(${Get.find<MainController>().seller.value.email})',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      SizedBox(
                        height: Get.width * 0.05,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.04,
                        ),
                        // margin: EdgeInsets.symmetric(
                        //   vertical: Get.width * 0.05,
                        // ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameController.value,
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
                                if (value!.isEmpty || value.trim() == '') {
                                  return 'Tên không được rỗng';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            TextFormField(
                              controller: phoneController.value,
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                              ),
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                label: Text('Số điện thoại'),
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
                                if (value!.isEmpty || value.trim() == '') {
                                  return 'Số điện thoại không được rỗng';
                                }
                                final RegExp phoneRegExp =
                                    RegExp(r"(84|0[3|5|7|8|9])+([0-9]{8})\b");
                                if (!phoneRegExp.hasMatch(value)) {
                                  return 'Số điện thoại không hợp lệ.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.3,
                                  child: const Text(
                                    'Tỉnh thành phố',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.5,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      value: Get.find<ProvinceController>()
                                          .listProvince
                                          .firstWhereOrNull((element) =>
                                              element.id == province.value.id),
                                      items: Get.find<ProvinceController>()
                                          .listProvince
                                          .map(
                                            (item) => DropdownMenuItem(
                                              value: item,
                                              child: Text(
                                                item.name,
                                                overflow: TextOverflow.ellipsis,
                                                strutStyle: StrutStyle.disabled,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 18,
                                      ),
                                      isExpanded: true,
                                      onChanged: (value) {
                                        province.value = value!;
                                      },
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: Get.height * 0.5,
                                        width: Get.width * 0.75,
                                        // padding: EdgeInsets.all(5),
                                      ),
                                      buttonStyleData: ButtonStyleData(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.green,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(5),
                                      ),
                                      dropdownSearchData: DropdownSearchData(
                                          searchController:
                                              provinceController.value,
                                          searchInnerWidgetHeight:
                                              Get.height * 0.05,
                                          searchInnerWidget: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 8, 0),
                                            child: TextField(
                                              controller:
                                                  provinceController.value,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.red)),
                                                  hintText:
                                                      'Tìm kiếm tỉnh thành theo tên',
                                                  contentPadding:
                                                      const EdgeInsets.all(10)),
                                            ),
                                          ),
                                          searchMatchFn:
                                              (DropdownMenuItem<Province> item,
                                                  searchValue) {
                                            return removeDiacritics(item
                                                    .value!.name
                                                    .toLowerCase())
                                                .contains(removeDiacritics(
                                                    searchValue.toLowerCase()));
                                          }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            TextFormField(
                              controller: addressDetailController.value,
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                              ),
                              decoration: const InputDecoration(
                                label: Text('Địa chỉ'),
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
                                if (province.value.id == '0') {
                                  return 'Vui lòng chọn Tỉnh thành phố.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            TextFormField(
                              controller: taxCodeController.value,
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                              ),
                              decoration: const InputDecoration(
                                label: Text('Mã số thuế'),
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
                              // validator: (value) {
                              //   if (value!.isEmpty || value.trim() == '') {
                              //     return 'Tên không được rỗng';
                              //   }
                              //   return null;
                              // },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.04,
                        ),
                        width: Get.width,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (phoneController.value.text !=
                                  mainController.seller.value.phone) {
                                if (await Get.find<SellerController>()
                                    .checkExistPhone(
                                        phoneController.value.text)) {
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
                                  return;
                                }
                              }
                              mainController.seller.value.name =
                                  nameController.value.text;
                              mainController.seller.value.phone =
                                  phoneController.value.text;
                              mainController.seller.value.province_id =
                                  province.value.id;
                              mainController.seller.value.address_detail =
                                  addressDetailController.value.text;
                              if (taxCodeController.value.text.isEmpty) {
                                mainController.seller.value.tax_code = '';
                              } else {
                                mainController.seller.value.tax_code =
                                    taxCodeController.value.text;
                              }

                              await Get.find<SellerController>()
                                  .updateInformation(filePathAvatar.value,
                                      filePathCover.value);
                              refershData(
                                  filePathAvatar,
                                  filePathCover,
                                  nameController,
                                  mainController,
                                  phoneController,
                                  taxCodeController,
                                  province,
                                  addressDetailController,
                                  provinceController);
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
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Lưu thông tin thành công',
                                btnOkOnPress: () {},
                              ).show();
                            }
                          },
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.green,
                            ),
                          ),
                          child: const Text(
                            'Lưu thông tin',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      // const Divider(
                      //   color: Colors.grey,
                      //   thickness: 2,
                      //   indent: 20,
                      //   endIndent: 20,
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: Get.width * 0.04,
                      //   ),
                      //   width: Get.width,
                      //   child: ElevatedButton(
                      //     onPressed: () async {
                      //       fogotPassword(mainController, context);
                      //     },
                      //     style: const ButtonStyle(
                      //       backgroundColor: WidgetStatePropertyAll(
                      //         Colors.lightGreen,
                      //       ),
                      //     ),
                      //     child: const Text(
                      //       'Cập nhật mật khẩu',
                      //       style: TextStyle(color: Colors.white, fontSize: 18),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                drawer: const DrawerSeller(),
              ),
            );
    });
  }

  void fogotPassword(MainController mainController, BuildContext context) {
    final formKeyPass = GlobalKey<FormState>();
    Rx<TextEditingController> newPassController = TextEditingController().obs;
    Rx<TextEditingController> confPassController = TextEditingController().obs;
    RxBool hideOldPass = true.obs;
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
                    'Cập nhật mật khẩu',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
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
                  key: formKeyPass,
                  child: Column(
                    children: [
                      TextFormField(
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                        ),
                        // controller: nameController,

                        validator: (value) {
                          if (value!.isEmpty || value.trim() == '') {
                            return 'Mật khẩu không được rỗng';
                          }
                          final RegExp passRegExp = RegExp(
                              r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$");
                          if (!passRegExp.hasMatch(value)) {
                            return 'Mật khẩu ít nhất 6 ký tự. Bao gồm: \nchữ hoa, chữ thường, số và ký tự đặc biệt.';
                          }

                          if (value !=
                              Get.find<MainController>()
                                  .seller
                                  .value
                                  .password) {
                            return 'Mật khẩu cũ không đúng';
                          }
                          return null;
                        },
                        obscureText: hideOldPass.value,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              hideOldPass.value = !hideOldPass.value;
                            },
                            icon: hideOldPass.value
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
                          labelText: 'Mật khẩu cũ',
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
                  backgroundColor: WidgetStatePropertyAll(Colors.green),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                onPressed: () async {
                  if (formKeyPass.currentState!.validate()) {
                    Get.find<MainController>().seller.value.password =
                        newPassController.value.text;
                    Get.back();
                    await Get.find<SellerController>()
                        .updatePassword(mainController.seller.value);
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
                      dialogType: DialogType.success,
                      animType: AnimType.rightSlide,
                      title: 'Cập nhật mật khẩu thành công',
                      btnOkOnPress: () {},
                    ).show();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(),
                  // width: Get.width * 0.8,
                  child: const Text(
                    'Cập nhật',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> refershData(
      RxString filePathAvatar,
      RxString filePathCover,
      Rx<TextEditingController> nameController,
      MainController mainController,
      Rx<TextEditingController> phoneController,
      Rx<TextEditingController> taxCodeController,
      Rx<Province> province,
      Rx<TextEditingController> addressDetailController,
      Rx<TextEditingController> provinceController) async {
    filePathAvatar.value = '';
    filePathCover.value = '';
    nameController.value.text = mainController.seller.value.name;
    phoneController.value.text = mainController.seller.value.phone;
    taxCodeController.value.text = mainController.seller.value.tax_code ?? '';
    province.value =
        Get.find<ProvinceController>().listProvince.firstWhereOrNull(
                  (p0) => p0.id == mainController.seller.value.province_id,
                ) ??
            Province.initProvince();
    addressDetailController.value.text =
        mainController.seller.value.address_detail;

    provinceController.value.text = '';
    Get.find<SellerController>().isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    Get.find<SellerController>().isLoading.value = false;
  }
}
