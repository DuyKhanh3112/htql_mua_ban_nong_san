import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/admin_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/drawer_admin.dart';
import 'package:image_picker/image_picker.dart';

class AdminInformationPage extends StatelessWidget {
  const AdminInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    MainController mainController = Get.find<MainController>();
    AdminController adminController = Get.find<AdminController>();
    RxString filePathCover = ''.obs;
    RxString filePathAvatar = ''.obs;

    Rx<TextEditingController> nameController =
        TextEditingController(text: mainController.admin.value.name).obs;
    Rx<TextEditingController> phoneController =
        TextEditingController(text: mainController.admin.value.phone).obs;
    return Obx(() {
      return adminController.isLoading.value || mainController.isLoading.value
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
                    InkWell(
                      child: const Icon(Icons.refresh),
                      onTap: () async {
                        mainController.isLoading.value = true;
                        await Future.delayed(const Duration(milliseconds: 500));
                        btnRefesh(filePathAvatar, filePathCover, nameController,
                            mainController, phoneController);
                        mainController.isLoading.value = false;
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                body: Container(
                  padding: EdgeInsets.all(Get.width * 0.03),
                  child: Form(
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
                                      filePathCover.value = pickedFile.path;
                                    }
                                  },
                                  child: Container(
                                    height: Get.width * 0.35,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      // shape: BoxShape.circle,
                                      color: mainController.admin.value.cover ==
                                                  '' &&
                                              filePathCover.value == ''
                                          ? Colors.black12
                                          : null,
                                      image: mainController.admin.value.cover ==
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
                                                      mainController
                                                          .admin.value.cover!),
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
                                                      typeSource.value =
                                                          'camera';
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
                                      } else if (typeSource.value ==
                                          'gallery') {
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
                                        color:
                                            mainController.admin.value.avatar ==
                                                        '' &&
                                                    filePathAvatar.value == ''
                                                ? Colors.black12
                                                : null,
                                        image: mainController
                                                    .admin.value.avatar ==
                                                ''
                                            ? filePathAvatar.value == ''
                                                ? null
                                                : DecorationImage(
                                                    image: FileImage(
                                                      File(
                                                          filePathAvatar.value),
                                                    ),
                                                    fit: BoxFit.fill,
                                                  )
                                            : filePathAvatar.value == ''
                                                ? DecorationImage(
                                                    image: NetworkImage(
                                                        mainController.admin
                                                            .value.avatar!),
                                                    fit: BoxFit.fill,
                                                  )
                                                : DecorationImage(
                                                    image: FileImage(
                                                      File(
                                                          filePathAvatar.value),
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
                                          mainController.admin.value.username,
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '(${mainController.admin.value.email})',
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
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
                                mainController.admin.value.name =
                                    nameController.value.text;
                                mainController.admin.value.phone =
                                    phoneController.value.text;
                                // await adminController
                                //     .updateAdmin(mainController.admin.value);
                                await adminController.updateInformation(
                                    filePathCover.value, filePathAvatar.value);
                                btnRefesh(
                                    filePathAvatar,
                                    filePathCover,
                                    nameController,
                                    mainController,
                                    phoneController);
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
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

  void btnRefesh(
      RxString filePathAvatar,
      RxString filePathCover,
      Rx<TextEditingController> nameController,
      MainController mainController,
      Rx<TextEditingController> phoneController) {
    filePathAvatar.value = '';
    filePathCover.value = '';
    nameController.value.text = mainController.admin.value.name;
    phoneController.value.text = mainController.admin.value.phone;
  }
}
