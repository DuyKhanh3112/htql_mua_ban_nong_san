import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/article_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/article.dart';
import 'package:htql_mua_ban_nong_san/models/article_image.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/drawer_admin.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/drawer_seller.dart';

class ArticleAdminPage extends StatelessWidget {
  const ArticleAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Get.find<ArticleController>().isLoading.value
          ? const LoadingPage()
          : DefaultTabController(
              initialIndex: 0,
              length: Get.find<ArticleController>().listStatus.length,
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
                  bottom: TabBar(
                    isScrollable: true,
                    labelColor: Colors.yellow,
                    unselectedLabelColor: Colors.white,
                    dividerColor: Colors.transparent,
                    tabs: <Widget>[
                      for (var item in Get.find<ArticleController>().listStatus)
                        Tab(
                          text:
                              '${item['label']} (${Get.find<ArticleController>().listArticle.where((p0) => p0.status == item['value']).length})',
                        ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    for (var item in Get.find<ArticleController>().listStatus)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: Get.find<ArticleController>()
                                .listArticle
                                .where((p0) => p0.status == item['value'])
                                .map((article) {
                              List<ArticleImage> listArticleImage =
                                  Get.find<ArticleController>()
                                      .listArticleImage
                                      .where(
                                          (p0) => p0.article_id == article.id)
                                      .toList();
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(4.0, 4.0),
                                      blurRadius: 10.0,
                                      spreadRadius: 2.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                // height: Get.height * 0.2,
                                width: Get.width,
                                padding: EdgeInsets.all(Get.width * 0.035),
                                margin: EdgeInsets.all(Get.height * 0.01),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.9,
                                      child: Text(
                                        article.content,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.01,
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.9,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          // scrollDirection: Axis.horizontal,
                                          children: listArticleImage
                                              .map(
                                                (img) => Container(
                                                  width: Get.width * 0.2,
                                                  height: Get.width * 0.3,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal:
                                                          Get.width * 0.02),
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
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            Get.find<ArticleController>()
                                                    .article
                                                    .value =
                                                Get.find<ArticleController>()
                                                        .listArticle
                                                        .firstWhereOrNull(
                                                            (element) =>
                                                                element.id ==
                                                                article.id) ??
                                                    Article.initArticle();
                                            Get.toNamed('/article_form');
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(),
                                            width: Get.width * 0.3,
                                            // height: Get.height * 0.05,
                                            child: const Text(
                                              'Chi tiết',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        item['value'] == 'draft'
                                            ? ElevatedButton(
                                                onPressed: () async {
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
                                                    dialogType:
                                                        DialogType.question,
                                                    animType:
                                                        AnimType.rightSlide,
                                                    title:
                                                        'Xác nhận bài viết được duyệt',
                                                    // desc: 'Bạn có muốn xóa loại sản phẩm này không?',
                                                    btnOkText: 'Xác nhận',
                                                    btnCancelText: 'Không',
                                                    btnOkOnPress: () async {
                                                      article.status = 'active';
                                                      article.update_at =
                                                          Timestamp.now();
                                                      Get.find<
                                                              ArticleController>()
                                                          .article
                                                          .value = article;
                                                      await Get.find<
                                                              ArticleController>()
                                                          .updateArticle([],
                                                              listArticleImage);

                                                      Get.find<ArticleController>()
                                                              .article
                                                              .value =
                                                          Article.initArticle();
                                                      // product.status = 'active';
                                                      // product.create_at = Timestamp.now();
                                                      // await productController.updateProduct(product);
                                                    },
                                                    btnCancelOnPress: () {},
                                                  ).show();
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  decoration:
                                                      const BoxDecoration(),
                                                  width: Get.width * 0.3,
                                                  // height: Get.height * 0.05,
                                                  child: const Text(
                                                    'Duyệt',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                  ],
                ),
                drawer: const DrawerAdmin(),
              ),
            );
    });
  }
}
