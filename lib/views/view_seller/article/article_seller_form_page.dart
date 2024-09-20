import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/article_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/article.dart';
import 'package:htql_mua_ban_nong_san/models/article_image.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:image_picker/image_picker.dart';

class ArticleSellerFormPage extends StatelessWidget {
  const ArticleSellerFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    ArticleController articleController = Get.find<ArticleController>();
    TextEditingController contentController = TextEditingController();
    RxList<dynamic> listFilePath = <dynamic>[].obs;
    RxList<ArticleImage> listImageUrl = <ArticleImage>[].obs;
    Rx<Seller> seller = Seller.initSeller().obs;
    final picker = ImagePicker();

    contentController.text = articleController.article.value.content;
    if (articleController.article.value.id != '') {
      listImageUrl.value = articleController.listArticleImage
          .where((p0) => p0.article_id == articleController.article.value.id)
          .toList();
    }
    if (Get.find<MainController>().admin.value.id != '') {
      seller.value = Get.find<SellerController>().listSeller.firstWhereOrNull(
              (p0) => p0.id == articleController.article.value.seller_id) ??
          Seller.initSeller();
      // print(seller.value.toJson());
    }

    return Obx(() {
      return articleController.isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Bài viết',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Container(
                      padding: EdgeInsets.all(Get.width * 0.05),
                      child: Column(
                        children: [
                          Get.find<MainController>().admin.value.id == ''
                              ? SizedBox()
                              : Row(
                                  children: [
                                    Container(
                                      width: Get.width * 0.15,
                                      height: Get.width * 0.15,
                                      // margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        shape: BoxShape.circle,
                                        image: seller.value.avatar == ''
                                            ? null
                                            : DecorationImage(
                                                image: NetworkImage(
                                                  seller.value.avatar!,
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.05,
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.5,
                                      child: Text(
                                        seller.value.name,
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          TextFormField(
                            readOnly:
                                Get.find<MainController>().seller.value.id ==
                                    '',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                            ),
                            minLines: 5,
                            maxLines: 10,
                            controller: contentController,
                            validator: (value) {
                              if (value!.isEmpty || value.trim() == '') {
                                return 'Hãy nhập nội dung bài viết k';
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
                              labelText: 'Nội dung bài viết',
                              labelStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          Get.find<MainController>().seller.value.id == ''
                              ? const SizedBox()
                              : InkWell(
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
                                      pickedFile = await picker.pickImage(
                                        source: ImageSource.camera,
                                        imageQuality: 90,
                                        preferredCameraDevice:
                                            CameraDevice.front,
                                      );
                                      if (pickedFile != null) {
                                        listFilePath.add(pickedFile.path);
                                      }
                                    } else if (typeSource.value == 'gallery') {
                                      List<XFile> res =
                                          await picker.pickMultiImage();
                                      for (var img in res) {
                                        listFilePath.add(img.path);
                                      }
                                    } else {
                                      return;
                                    }
                                  },
                                  child: DottedBorder(
                                    color: Colors.green,
                                    strokeWidth: 2,
                                    dashPattern: const [
                                      5,
                                      5,
                                    ],
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.all(5),
                                      height: Get.width * 0.2,
                                      width: Get.width * 0.4,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/upload_file_icon.png'),
                                          // fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          listFilePath.isEmpty && listImageUrl.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: Get.height * 0.15,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      for (var img in listImageUrl)
                                        Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(
                                                  Get.width * 0.02),
                                              decoration: const BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      offset: Offset(2.0, 2.0),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 2.0,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  width: Get.width * 0.2,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          img.image),
                                                      fit: BoxFit.fill,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Get.find<MainController>()
                                                        .seller
                                                        .value
                                                        .id ==
                                                    ''
                                                ? const SizedBox()
                                                : Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: InkWell(
                                                      onTap: () {
                                                        listImageUrl
                                                            .removeWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    img.id);
                                                        listImageUrl.value =
                                                            // ignore: invalid_use_of_protected_member
                                                            listImageUrl.value;
                                                      },
                                                      child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.red,
                                                          ),
                                                          child: const Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                          )),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      for (var pathIndex = 0;
                                          pathIndex < listFilePath.length;
                                          pathIndex++)
                                        Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(
                                                  Get.width * 0.02),
                                              decoration: const BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      offset: Offset(2.0, 2.0),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 2.0,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  width: Get.width * 0.2,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: FileImage(
                                                        File(listFilePath[
                                                            pathIndex]),
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Get.find<MainController>()
                                                        .seller
                                                        .value
                                                        .id ==
                                                    ''
                                                ? const SizedBox()
                                                : Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: InkWell(
                                                      onTap: () {
                                                        listFilePath.removeAt(
                                                            pathIndex);

                                                        listFilePath.value =
                                                            // ignore: invalid_use_of_protected_member
                                                            listFilePath.value;
                                                      },
                                                      child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.red,
                                                          ),
                                                          child: const Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                          )),
                                                    ),
                                                  )
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          Get.find<MainController>().seller.value.id == ''
                              ? const SizedBox()
                              : FloatingActionButton.extended(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      if (articleController.article.value.id ==
                                          '') {
                                        articleController.article.value
                                            .content = contentController.text;
                                        articleController
                                                .article.value.seller_id =
                                            Get.find<MainController>()
                                                .seller
                                                .value
                                                .id;
                                        //them
                                        await articleController
                                            .createArticle(listFilePath);
                                        articleController.article.value =
                                            Article.initArticle();
                                      } else {
                                        //update
                                        articleController.article.value
                                            .content = contentController.text;
                                        articleController.article.value.status =
                                            'draft';
                                        articleController.article.value
                                            .update_at = Timestamp.now();

                                        await articleController.updateArticle(
                                            listFilePath, listImageUrl.value);
                                      }
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
                                        dialogType: DialogType.success,
                                        animType: AnimType.rightSlide,
                                        title: 'Lưu bài viết thành công',
                                        btnOkOnPress: () {},
                                      ).show();
                                      Get.back();
                                    }
                                  },
                                  label: const Text(
                                    'Lưu bài viết',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  elevation: 10,
                                  backgroundColor: Colors.green,
                                  shape: const StadiumBorder(),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
    });
  }

  void loadData(TextEditingController contentController,
      ArticleController articleController) {
    contentController.text = articleController.article.value.content;
  }
}
