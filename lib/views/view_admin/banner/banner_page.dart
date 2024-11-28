// ignore_for_file: invalid_use_of_protected_member

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/banner_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/banner.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/drawer_admin.dart';
import 'package:image_picker/image_picker.dart';

class BannerPage extends StatelessWidget {
  const BannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    BannerController bannerController = Get.find<BannerController>();
    RxList<BannerApp> listBanner = <BannerApp>[].obs;
    RxList listFilePath = [].obs;
    RxBool isChange = false.obs;
    refeshData(listBanner, listFilePath, isChange);
    return Obx(() {
      return bannerController.isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  title: const Text(
                    'Banner',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  foregroundColor: Colors.white,
                  actions: [
                    InkWell(
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        refeshData(listBanner, listFilePath, isChange);
                        // refeshData(listBanner.value, bannerController,
                        //     listFilePath, isChange);
                      },
                      child: const Icon(
                        Icons.refresh,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
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
                          if (pickedFile != null) {
                            listFilePath.add(pickedFile.path);
                            isChange.value = true;
                          }
                        } else if (typeSource.value == 'gallery') {
                          List<XFile> res =
                              await ImagePicker().pickMultiImage();
                          for (var img in res) {
                            listFilePath.add(img.path);
                          }
                          isChange.value = true;
                        } else {
                          return;
                        }
                      },
                      child: const Icon(
                        Icons.add_circle_outline,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                body: ListView(
                  children: [
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    for (var filePath in listFilePath.value)
                      fileBannerItem(filePath, context, listFilePath,
                          listBanner, isChange),
                    for (var banner in listBanner.value)
                      bannerItem(banner, context, listBanner, isChange),
                  ],
                ),
                drawer: const DrawerAdmin(),
                floatingActionButton: !isChange.value
                    ? null
                    : ElevatedButton(
                        onPressed: () async {
                          // await bannerController.createBanner(listFilePath);
                          await bannerController.saveBanner(
                              listBanner.value, listFilePath.value);
                          refeshData(listBanner, listFilePath, isChange);
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
                            'Lưu danh sách banner',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ),
            );
    });
  }

  void refeshData(RxList<BannerApp> listBanner, RxList<dynamic> listFilePath,
      RxBool isChange) {
    listBanner.value = [];
    for (var item in Get.find<BannerController>().listBanner) {
      BannerApp banner =
          BannerApp(id: item.id, image: item.image, create_at: item.create_at);
      listBanner.add(banner);
    }
    listFilePath.value = [];
    listBanner.sort(
      (a, b) => b.create_at.compareTo(a.create_at),
    );
    isChange.value = false;
  }

  Stack bannerItem(BannerApp banner, BuildContext context,
      RxList<BannerApp> listBanner, RxBool isChange) {
    return Stack(
      children: [
        Container(
          // width: Get.width * 0.8,
          height: Get.width * 0.4,
          margin: EdgeInsets.symmetric(
            vertical: Get.width * 0.04,
            horizontal: Get.width * 0.05,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(banner.image),
              fit: BoxFit.fill,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(1, 1),
                blurRadius: 5,
                spreadRadius: 1.0,
              ),
            ],
          ),
        ),
        Positioned(
          top: Get.width * 0.02,
          right: Get.width * 0.02,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: InkWell(
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              onTap: () async {
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
                  dialogType: DialogType.question,
                  animType: AnimType.rightSlide,
                  // title: 'Xác nhận',
                  // desc:
                  //     'Bạn có muốn xóa Banner này không',
                  body: Column(
                    children: [
                      const Text(
                        'Xác nhận xóa banner',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.6,
                        child: const Divider(),
                      ),
                      Container(
                        width: Get.width * 0.6,
                        height: Get.width * 0.3,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(banner.image),
                          ),
                        ),
                      ),
                    ],
                  ),
                  btnOkText: 'Xác nhận',
                  btnCancelText: 'Không',
                  btnOkOnPress: () async {
                    // await bannerController.deleteBanner(banner);
                    listBanner.remove(banner);
                    isChange.value = true;
                  },
                  btnCancelOnPress: () {},
                ).show();
              },
            ),
          ),
        ),
      ],
    );
  }

  Stack fileBannerItem(
    String filePath,
    BuildContext context,
    RxList listFilePath,
    RxList listBanner,
    RxBool isChange,
  ) {
    return Stack(
      children: [
        Container(
          // width: Get.width * 0.8,
          height: Get.width * 0.4,
          margin: EdgeInsets.symmetric(
            vertical: Get.width * 0.04,
            horizontal: Get.width * 0.05,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(filePath)),
              fit: BoxFit.fill,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(1, 1),
                blurRadius: 5,
                spreadRadius: 1.0,
              ),
            ],
          ),
        ),
        Positioned(
          top: Get.width * 0.02,
          right: Get.width * 0.02,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: InkWell(
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              onTap: () async {
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
                  dialogType: DialogType.question,
                  animType: AnimType.rightSlide,
                  // title: 'Xác nhận',
                  // desc:
                  //     'Bạn có muốn xóa Banner này không',
                  body: Column(
                    children: [
                      const Text(
                        'Xác nhận xóa banner',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.6,
                        child: const Divider(),
                      ),
                      Container(
                        width: Get.width * 0.6,
                        height: Get.width * 0.3,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(filePath)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  btnOkText: 'Xác nhận',
                  btnCancelText: 'Không',
                  btnOkOnPress: () async {
                    listFilePath.remove(filePath);
                    if (listFilePath.isEmpty &&
                        listBanner.length ==
                            Get.find<BannerController>().listBanner.length) {
                      isChange.value = false;
                    }
                  },
                  btnCancelOnPress: () {},
                ).show();

                // await AwesomeDialog(
                //   titleTextStyle: const TextStyle(
                //     color: Colors.green,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 22,
                //   ),
                //   descTextStyle: const TextStyle(
                //     color: Colors.green,
                //     fontSize: 16,
                //   ),
                //   context: context,
                //   dialogType: DialogType.question,
                //   animType: AnimType.rightSlide,
                //   // title: 'Xác nhận',
                //   // desc:
                //   //     'Bạn có muốn xóa Banner này không',
                //   body: Column(
                //     children: [
                //       const Text(
                //         'Xác nhận xóa banner',
                //         style: TextStyle(
                //           color: Colors.green,
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       SizedBox(
                //         width: Get.width * 0.6,
                //         child: const Divider(),
                //       ),
                //       Container(
                //         width: Get.width * 0.6,
                //         height: Get.width * 0.3,
                //         decoration: BoxDecoration(
                //           image: DecorationImage(
                //             image: NetworkImage(banner.image),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                //   btnOkText: 'Xác nhận',
                //   btnCancelText: 'Không',
                //   btnOkOnPress: () async {
                //     await bannerController.deleteBanner(banner);
                //   },
                //   btnCancelOnPress: () {},
                // ).show();
              },
            ),
          ),
        ),
      ],
    );
  }
}
