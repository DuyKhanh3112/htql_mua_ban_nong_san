import 'package:card_banner/card_banner.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/article_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/province_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/review_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/article_image.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';
import 'package:htql_mua_ban_nong_san/models/product_image.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:intl/intl.dart';

class SellerPage extends StatelessWidget {
  const SellerPage({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   MainController mainController = Get.find<MainController>();
  //   SellerController sellerController = Get.find<SellerController>();
  //   return Obx(() {
  //     return mainController.isLoading.value || sellerController.isLoading.value
  //         ? const LoadingPage()
  //         : Scaffold(
  //             appBar: AppBar(
  //               backgroundColor: Colors.green,
  //               iconTheme: const IconThemeData(
  //                 color: Colors.white,
  //               ),
  //               title: Container(
  //                 width: Get.width * 0.75,
  //                 decoration: const BoxDecoration(),
  //                 child: Row(
  //                   children: [
  //                     Text(
  //                       "${sellerController.seller.value.name} (${sellerController.seller.value.username})",
  //                       style: const TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               // toolbarHeight: Get.width * 0.5,
  //             ),
  //           );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    SellerController sellerController = Get.find<SellerController>();
    RxInt index = 0.obs;
    return Obx(() {
      return mainController.isLoading.value || sellerController.isLoading.value
          ? const LoadingPage()
          : Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    //header
                    Container(
                      width: Get.width,
                      padding: EdgeInsets.only(
                        top: Get.width * 0.05,
                        right: Get.width * 0.02,
                        left: Get.width * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        image: sellerController.seller.value.cover == ''
                            ? null
                            : DecorationImage(
                                image: NetworkImage(
                                    sellerController.seller.value.cover!),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              // left: Get.width * 0.05,
                              // right: Get.width * 0.02,
                              top: Get.width * 0.01,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.1,
                                  child: InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: const Icon(
                                      Icons.arrow_back,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: Get.width * 0.15,
                                  width: Get.width * 0.15,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: sellerController
                                                .seller.value.avatar ==
                                            ''
                                        ? null
                                        : DecorationImage(
                                            image: NetworkImage(sellerController
                                                .seller.value.avatar!),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Container(
                                  width: Get.width * 0.7,
                                  decoration: const BoxDecoration(),
                                  child: Text(
                                    "${sellerController.seller.value.name} (${sellerController.seller.value.username})",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: Get.width * 0.15,
                              right: Get.width * 0.02,
                              top: Get.width * 0.02,
                              bottom: Get.width * 0.02,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: Get.width * 0.3,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Lượt bán: ${NumberFormat.decimalPatternDigits(decimalDigits: 0).format(sellerController.getSaleNum())}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                                sellerController.getRatting() == 0
                                    ? SizedBox(
                                        width: Get.width * 0.45,
                                        child: const Text(
                                          'Chưa có đánh giá',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerRight,
                                            width: Get.width * 0.3,
                                            child: RatingBarIndicator(
                                              rating:
                                                  sellerController.getRatting(),
                                              itemBuilder: (context, index) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              unratedColor: Colors.grey,
                                              itemCount: 5,
                                              itemSize: Get.width * 0.05,
                                              direction: Axis.horizontal,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: Get.width * 0.1,
                                            child: Text(
                                              '(${NumberFormat.decimalPatternDigits(decimalDigits: 1).format(sellerController.getRatting())})',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.green,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold,
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
                    //body
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    index.value == 0
                        ? viewProduct(sellerController)
                        : viewArticle(sellerController, context),
                  ],
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                elevation: 15,
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 15,
                unselectedFontSize: 12,
                selectedIconTheme: const IconThemeData(
                  size: 25,
                ),
                unselectedIconTheme: const IconThemeData(
                  size: 20,
                ),
                showUnselectedLabels: true,
                backgroundColor: Colors.green,
                unselectedItemColor: Colors.white,
                unselectedLabelStyle: const TextStyle(color: Colors.white),
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                selectedItemColor: Colors.yellowAccent,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Sản phẩm',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.newspaper_rounded),
                    label: 'Bài viết',
                  ),
                ],
                currentIndex: index.value,
                onTap: (i) {
                  index.value = i;
                },
              ),
            );
    });
  }

  Expanded viewArticle(
      SellerController sellerController, BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: Get.find<ArticleController>()
              .listArticle
              .where((p0) =>
                  p0.status == 'active' &&
                  p0.seller_id == sellerController.seller.value.id)
              .map((article) {
            Seller seller = Get.find<SellerController>().seller.value;

            List<ArticleImage> listArticleImage = Get.find<ArticleController>()
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
                    Row(
                      children: [
                        SizedBox(
                          width: Get.width * 0.01,
                        ),
                        Container(
                          width: Get.width * 0.1,
                          height: Get.width * 0.1,
                          margin: EdgeInsets.all(Get.width * 0.01),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
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
                    listArticleImage.isEmpty
                        ? const SizedBox()
                        : Column(
                            children: [
                              const Divider(),
                              CarouselSlider(
                                items: listArticleImage
                                    .map(
                                      (item) => Container(
                                        margin:
                                            EdgeInsets.all(Get.width * 0.01),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(40)),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(40),
                                              ),
                                              image: DecorationImage(
                                                image: NetworkImage(item.image),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: listArticleImage
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  return GestureDetector(
                                    onTap: () =>
                                        controller.animateToPage(entry.key),
                                    child: Container(
                                      width: 12.0,
                                      height: 12.0,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black)
                                              .withOpacity(
                                                  currentImg.value == entry.key
                                                      ? 0.9
                                                      : 0.4)),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                  ],
                ),
              );
            });
          }).toList(),
        ),
      ),
    );
  }

  Expanded viewProduct(SellerController sellerController) {
    return Expanded(
      child: FlexibleGridView(
        axisCount: GridLayoutEnum.twoElementsInRow,
        children: Get.find<ProductController>()
            .listProduct
            .where((p0) =>
                p0.seller_id == sellerController.seller.value.id &&
                p0.status == 'active')
            .map((product) {
          return productDetail(product);
        }).toList(),
      ),
    );
  }

  Widget productDetail(Product pro) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    Product product = Get.find<ProductController>()
            .listProduct
            .firstWhereOrNull((element) => element.id == pro.id) ??
        Product.initProduct();
    Seller seller = Get.find<SellerController>()
            .listSeller
            .firstWhereOrNull((element) => element.id == product.seller_id) ??
        Seller.initSeller();
    ProductImage? imgUrl = Get.find<ProductController>()
        .listProductImage
        .firstWhereOrNull(
            (p0) => p0.product_id == product.id && p0.is_default == true);
    Province province = Get.find<ProvinceController>()
            .listProvince
            .firstWhereOrNull((element) => element.id == product.province_id) ??
        Province.initProvince();
    return Container(
      width: Get.width * 0.5,
      // height: Get.height * 0.5,
      margin: EdgeInsets.only(
        left: Get.width * 0.02,
        right: Get.width * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(2.0, 2.0),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: InkWell(
        child: Column(
          children: [
            CardBanner(
              text: '${seller.name} ',
              color: Colors.green,
              textStyle: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              edgeSize: 18,
              edgeColor: Colors.green.shade800,
              radius: 15,
              child: Container(
                height: Get.width * 0.5,
                // width: Get.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: imgUrl == null
                      ? null
                      : DecorationImage(
                          image: NetworkImage(imgUrl.image),
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
              alignment: Alignment.centerLeft,
              child: Text(
                product.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
              alignment: Alignment.centerLeft,
              child: Text(
                '${currencyFormatter.format(product.price)}/${product.unit}',
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_sharp,
                    color: Colors.green,
                    size: 20,
                  ),
                  SizedBox(
                    width: Get.width * 0.3,
                    child: Text(
                      province.name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
              alignment: Alignment.centerRight,
              width: Get.width * 0.5,
              child: product.ratting == 0
                  ? const Text(
                      'Chưa có đánh giá',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          width: Get.width * 0.3,
                          child: RatingBarIndicator(
                            rating: product.ratting ?? 0,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: Get.width * 0.05,
                            direction: Axis.horizontal,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          width: Get.width * 0.1,
                          child: Text(
                            '(${NumberFormat.decimalPatternDigits(decimalDigits: 1).format(product.ratting)})',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
              alignment: Alignment.centerRight,
              width: Get.width * 0.5,
              child: Text(
                'Đã bán: ${NumberFormat.decimalPattern().format(product.sale_num)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
          ],
        ),
        onTap: () async {
          Get.find<ProductController>().product.value = product;
          Get.toNamed('/product_detail');
          await Get.find<ReviewController>().loadReviewByProductID(product.id);
        },
      ),
    );
  }
}
