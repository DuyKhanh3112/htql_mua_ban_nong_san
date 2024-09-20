import 'package:card_banner/card_banner.dart';
import 'package:convert_vietnamese/convert_vietnamese.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/cart_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/category_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/province_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';
import 'package:htql_mua_ban_nong_san/models/product_image.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:intl/intl.dart';

class SearchProductPage extends StatelessWidget {
  const SearchProductPage({super.key});
  void loadData(RxList<Product> listProduct) {
    List<String> listCategoryID = [];
    ProductController productController = Get.find<ProductController>();
    if (productController.searchProductController.value.text.isNotEmpty) {
      for (var element in Get.find<CategoryController>()
          .listCategory
          .where((p0) => p0.hide == false)
          .where((p0) =>
              productController.searchProductController.value.text.isEmpty ||
              removeDiacritics(p0.name.toLowerCase()).contains(removeDiacritics(
                  productController.searchProductController.value.text
                      .toLowerCase())))) {
        listCategoryID.add(element.id);
      }

      listProduct.value = Get.find<ProductController>()
          .listProduct
          .where((p0) =>
              p0.status == 'active' &&
              (removeDiacritics(p0.name.toLowerCase()).contains(
                      removeDiacritics(productController
                          .searchProductController.value.text
                          .toLowerCase())) ||
                  listCategoryID.contains(p0.category_id)))
          .toList();
    } else if (productController.category.value.id != '') {
      listProduct.value = Get.find<ProductController>()
          .listProduct
          .where((p0) =>
              p0.status == 'active' &&
              p0.category_id == productController.category.value.id)
          .toList();
    } else {
      listProduct.value = productController.listProduct;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    MainController mainController = Get.find<MainController>();
    RxList<Product> listProduct = <Product>[].obs;

    return Obx(() {
      loadData(listProduct);
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
                            width: Get.width * 0.6,
                            child: TextFormField(
                              controller: Get.find<ProductController>()
                                  .searchProductController
                                  .value,
                              onChanged: (value) {
                                // if (value.isEmpty) {
                                //   loadData(listProduct);
                                // }
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                prefixIcon: InkWell(
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    Get.back();
                                    Get.find<ProductController>()
                                        .searchProductController
                                        .value
                                        .clear();
                                  },
                                ),
                                suffixIcon: InkWell(
                                  child: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    loadData(listProduct);
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

                    // const Divider(),
                    Expanded(
                      child: FlexibleGridView(
                        axisCount: GridLayoutEnum.twoElementsInRow,
                        children: listProduct.map((product) {
                          return productDetail(product, currencyFormatter);
                        }).toList(),
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
        onTap: () {
          Get.find<ProductController>().product.value = product;
          Get.toNamed('/product_detail');
        },
      ),
    );
  }
}
