import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/article_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/cart_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/article_image.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:intl/intl.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Get.find<MainController>().isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
              body: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    // height: 100,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: Get.width * 0.01),
                          padding: EdgeInsets.only(
                              left: Get.width * 0.02, right: Get.width * 0.02),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(40),
                            ),
                          ),
                          width: Get.width * 0.5,
                          child: TextFormField(
                            // controller: searchController.value,
                            onChanged: (value) {
                              // loadData(listCategory, searchController);
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Tìm kiếm sản phẩm...',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Get.find<MainController>().buyer.value.id == ''
                            ? const SizedBox()
                            : InkWell(
                                onTap: () async {
                                  Get.find<MainController>().isLoading.value =
                                      true;
                                  await Get.find<CartController>()
                                      .getCartGroupBySeller();
                                  Get.find<CartController>()
                                      .listCartChoose
                                      .value = [];
                                  Get.find<MainController>().isLoading.value =
                                      false;
                                  Get.toNamed('/cart');
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.1),
                                  child: Get.find<CartController>()
                                              .countCart
                                              .value ==
                                          0
                                      ? const Icon(
                                          Icons.shopping_cart,
                                          color: Colors.white,
                                          size: 35,
                                        )
                                      : Badge(
                                          label: Text(
                                            NumberFormat.decimalPattern()
                                                .format(
                                                    Get.find<CartController>()
                                                        .countCart
                                                        .value),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                          child: const Icon(
                                            Icons.shopping_cart,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: Get.find<ArticleController>()
                            .listArticle
                            .where((p0) => p0.status == 'active')
                            .map((article) {
                          Seller seller = Get.find<SellerController>()
                                  .listSeller
                                  .firstWhereOrNull(
                                      (p0) => p0.id == article.seller_id) ??
                              Seller.initSeller();

                          List<ArticleImage> listArticleImage =
                              Get.find<ArticleController>()
                                  .listArticleImage
                                  .where((p0) => p0.article_id == article.id)
                                  .toList();
                          final CarouselSliderController controller =
                              CarouselSliderController();
                          RxInt currentImg = 0.obs;
                          RxBool isShow = false.obs;

                          return Obx(() {
                            return Container(
                              width: Get.width,
                              margin: EdgeInsets.all(Get.width * 0.03),
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
                                  InkWell(
                                    onTap: () async {
                                      Get.toNamed('/view_seller');
                                      await Get.find<SellerController>()
                                          .getSeller(seller.id);
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: Get.width * 0.01,
                                        ),
                                        Container(
                                          width: Get.width * 0.1,
                                          height: Get.width * 0.1,
                                          margin:
                                              EdgeInsets.all(Get.width * 0.01),
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
                                            image: seller.avatar == ''
                                                ? null
                                                : DecorationImage(
                                                    image: NetworkImage(
                                                      seller.avatar!,
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
                                            seller.name,
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  SizedBox(
                                    width: Get.width * 0.9,
                                    child: Text(
                                      DateFormat('HH:mm dd-MM-yyyy')
                                          .format(article.update_at.toDate()),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        // fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.05,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      isShow.value = !isShow.value;
                                    },
                                    child: SizedBox(
                                      width: Get.width * 0.9,
                                      child: Text(
                                        article.content,
                                        overflow: isShow.value
                                            ? TextOverflow.clip
                                            : TextOverflow.ellipsis,
                                        maxLines: isShow.value ? null : 4,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // listArticleImage.isEmpty
                                  //     ? SizedBox()
                                  //     : const Divider(),
                                  SizedBox(
                                    height: Get.height * 0.01,
                                  ),
                                  listArticleImage.isEmpty
                                      ? SizedBox()
                                      : CarouselSlider(
                                          items: listArticleImage
                                              .map(
                                                (item) => Container(
                                                  margin: EdgeInsets.all(
                                                      Get.width * 0.01),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                40)),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(40),
                                                        ),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              item.image),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          options: CarouselOptions(
                                            enlargeCenterPage: true,
                                            height: Get.height * 0.3,
                                            onPageChanged: (index, reson) {
                                              currentImg.value = index;
                                            },
                                            autoPlay: true,
                                          ),
                                          carouselController: controller,
                                        ),
                                  listArticleImage.isEmpty
                                      ? SizedBox()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: listArticleImage
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            return GestureDetector(
                                              onTap: () => controller
                                                  .animateToPage(entry.key),
                                              child: Container(
                                                width: 12.0,
                                                height: 12.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 4.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: (Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? Colors.white
                                                            : Colors.black)
                                                        .withOpacity(
                                                            currentImg.value ==
                                                                    entry.key
                                                                ? 0.9
                                                                : 0.4)),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                ],
                              ),
                            );
                          });
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ));
    });
  }
}
