import 'package:card_banner/card_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/buyer_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/cart_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/province_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/review_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/category.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';
import 'package:htql_mua_ban_nong_san/models/product_image.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:intl/intl.dart';

class HomeUserPage extends StatelessWidget {
  const HomeUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    MainController mainController = Get.find<MainController>();

    // RxList<Product> listProduct = <Product>[].obs;
    RxList<Product> topProductBestSeller = <Product>[].obs;
    RxList<Product> topProductNew = <Product>[].obs;
    RxList<Product> topProductRatting = <Product>[].obs;
    RxList<Product> productBought = <Product>[].obs;

    return Obx(() {
      loadData(topProductBestSeller, topProductNew, topProductRatting,
          mainController, productBought);

      return mainController.isLoading.value
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
                          // Icon(Icons.search),
                          Container(
                            margin: EdgeInsets.only(top: Get.width * 0.01),
                            padding: EdgeInsets.only(
                                left: Get.width * 0.02,
                                right: Get.width * 0.02),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white,
                                  style: BorderStyle.solid),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ),
                            width: Get.width * 0.5,
                            child: TextFormField(
                              controller: Get.find<ProductController>()
                                  .searchProductController
                                  .value,
                              onChanged: (value) {
                                // loadData(listProduct);
                                loadData(
                                    topProductBestSeller,
                                    topProductNew,
                                    topProductRatting,
                                    mainController,
                                    productBought);
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                suffixIcon: Get.find<ProductController>()
                                        .searchProductController
                                        .value
                                        .text
                                        .isEmpty
                                    ? null
                                    : InkWell(
                                        child: const Icon(
                                          Icons.search,
                                          color: Colors.white,
                                        ),
                                        onTap: () {
                                          Get.find<ProductController>()
                                              .category
                                              .value = Category.initCategory();
                                          Get.find<ProductController>()
                                              .sortType
                                              .value = '';
                                          Get.toNamed('search_product');
                                        },
                                      ),
                                border: InputBorder.none,
                                hintText: 'Tìm kiếm sản phẩm...',
                                hintStyle: const TextStyle(
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
                                    mainController.isLoading.value = true;
                                    await Get.find<CartController>()
                                        .getCartGroupBySeller();
                                    Get.find<CartController>()
                                        .listCartChoose
                                        .value = [];
                                    mainController.isLoading.value = false;
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
                    // Expanded(
                    //   child: FlexibleGridView(
                    //     axisCount: GridLayoutEnum.twoElementsInRow,
                    //     children: listProduct.map((product) {
                    //       return productDetail(product, currencyFormatter);
                    //     }).toList(),
                    //   ),
                    // ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            // SẢN PHẨM ĐÃ MUA
                            productBought.isEmpty
                                ? const SizedBox()
                                : Container(
                                    color: Colors.green,
                                    padding: const EdgeInsets.all(10),
                                    margin: EdgeInsets.only(
                                      bottom: Get.width * 0.01,
                                      top: Get.width * 0.05,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'SẢN PHẨM ĐÃ MUA GẦN ĐÂY',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                            productBought.isEmpty
                                ? const SizedBox()
                                : SingleChildScrollView(
                                    child: Container(
                                      // height: Get.height * 0.5,
                                      padding: EdgeInsets.only(
                                          left: Get.width * 0.01),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            for (var product in productBought)
                                              productDetail(
                                                  product, currencyFormatter),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                            // SẢN PHẨM MỚI
                            topProductNew.isEmpty
                                ? const SizedBox()
                                : Container(
                                    color: Colors.green,
                                    width: Get.width,
                                    // width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    margin: EdgeInsets.only(
                                      bottom: Get.width * 0.01,
                                      top: Get.width * 0.05,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'SẢN PHẨM MỚI',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                            if (topProductNew.isEmpty)
                              const SizedBox()
                            else
                              SingleChildScrollView(
                                child: Container(
                                  // height: Get.height * 0.5,
                                  padding:
                                      EdgeInsets.only(left: Get.width * 0.01),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        for (var product
                                            in topProductNew.sublist(
                                                0,
                                                topProductNew.length > 5
                                                    ? 5
                                                    : topProductNew.length))
                                          productDetail(
                                              product, currencyFormatter),
                                        InkWell(
                                          child: SizedBox(
                                            width: Get.width * 0.2,
                                            child: Icon(
                                              Icons.chevron_right_sharp,
                                              size: Get.width * 0.15,
                                              color: Colors.green,
                                            ),
                                          ),
                                          onTap: () {
                                            // Get.find<ProductController>()
                                            //     .listProduct
                                            //     .sort((a, b) => b.create_at
                                            //         .compareTo(
                                            //             a.create_at));
                                            Get.find<ProductController>()
                                                    .sortType
                                                    .value ==
                                                'new';
                                            Get.find<ProductController>()
                                                    .category
                                                    .value =
                                                Category.initCategory();
                                            Get.toNamed('search_product');
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            //SẢN PHẨM BÁN CHẠY
                            topProductBestSeller.isEmpty
                                ? const SizedBox()
                                : Container(
                                    color: Colors.green,
                                    width: Get.width,
                                    // width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    margin: EdgeInsets.only(
                                      bottom: Get.width * 0.01,
                                      top: Get.width * 0.05,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'SẢN PHẨM BÁN CHẠY',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                            topProductBestSeller.isEmpty
                                ? const SizedBox()
                                : SingleChildScrollView(
                                    child: Container(
                                      // height: Get.height * 0.5,
                                      padding: EdgeInsets.only(
                                          left: Get.width * 0.01),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            for (var product
                                                in topProductBestSeller.sublist(
                                                    0,
                                                    topProductBestSeller
                                                                .length >
                                                            5
                                                        ? 5
                                                        : topProductBestSeller
                                                            .length))
                                              productDetail(
                                                  product, currencyFormatter),
                                            InkWell(
                                              child: SizedBox(
                                                width: Get.width * 0.2,
                                                child: Icon(
                                                  Icons.chevron_right_sharp,
                                                  size: Get.width * 0.15,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              onTap: () {
                                                // Get.find<ProductController>()
                                                //     .listProduct
                                                //     .sort((a, b) => b.sale_num!
                                                //         .compareTo(
                                                //             a.sale_num!));
                                                Get.find<ProductController>()
                                                        .sortType
                                                        .value ==
                                                    'sell';
                                                Get.find<ProductController>()
                                                        .category
                                                        .value =
                                                    Category.initCategory();
                                                Get.toNamed('search_product');
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            //SẢN PHẨM ĐƯỢC ĐÁNH GIÁ TỐT
                            topProductRatting.isEmpty
                                ? const SizedBox()
                                : Container(
                                    color: Colors.green,
                                    width: Get.width,
                                    padding: const EdgeInsets.all(10),
                                    margin: EdgeInsets.only(
                                      bottom: Get.width * 0.01,
                                      top: Get.width * 0.05,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'SẢN PHẨM ĐƯỢC ĐÁNH GIÁ TỐT',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                            topProductRatting.isEmpty
                                ? const SizedBox()
                                : SingleChildScrollView(
                                    child: Container(
                                      // height: Get.height * 0.5,
                                      padding: EdgeInsets.only(
                                          left: Get.width * 0.01),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            for (var product
                                                in topProductRatting.sublist(
                                                    0,
                                                    topProductRatting.length > 5
                                                        ? 5
                                                        : topProductRatting
                                                            .length))
                                              productDetail(
                                                  product, currencyFormatter),
                                            InkWell(
                                              child: SizedBox(
                                                width: Get.width * 0.2,
                                                child: Icon(
                                                  Icons.chevron_right_sharp,
                                                  size: Get.width * 0.15,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              onTap: () {
                                                // Get.find<ProductController>()
                                                //     .listProduct
                                                //     .sort((a, b) => b.ratting!
                                                //         .compareTo(a.ratting!));
                                                Get.find<ProductController>()
                                                        .sortType
                                                        .value ==
                                                    'ratting';
                                                Get.find<ProductController>()
                                                        .category
                                                        .value =
                                                    Category.initCategory();
                                                Get.toNamed('search_product');
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            );
    });
  }

  void loadData(
      RxList<Product> topProductBestSeller,
      RxList<Product> topProductNew,
      RxList<Product> topProductRatting,
      MainController mainController,
      RxList<Product> productBought) {
    if (Get.find<ProductController>().listProduct.isNotEmpty) {
      topProductBestSeller.value = Get.find<ProductController>()
          .listProduct
          .where((p0) => p0.status == 'active')
          .toList();
      topProductBestSeller.sort((a, b) => b.sale_num!.compareTo(a.sale_num!));

      topProductNew.value = Get.find<ProductController>()
          .listProduct
          .where((p0) => p0.status == 'active')
          .toList();
      topProductNew.sort((a, b) => b.create_at.compareTo(a.create_at));

      topProductRatting.value = Get.find<ProductController>()
          .listProduct
          .where((p0) => p0.status == 'active')
          .toList();
      topProductRatting.sort((a, b) => b.ratting!.compareTo(a.ratting!));

      if (mainController.buyer.value.id != '') {
        productBought.value = Get.find<BuyerController>().listProductBought;
      }
    }
  }

  Widget productDetail(Product pro, NumberFormat currencyFormatter) {
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
            .firstWhereOrNull((element) => element.id == seller.province_id) ??
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
