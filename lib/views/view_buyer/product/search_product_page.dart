// ignore_for_file: invalid_use_of_protected_member

import 'package:card_banner/card_banner.dart';
import 'package:convert_vietnamese/convert_vietnamese.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/cart_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/category_controller.dart';
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

class SearchProductPage extends StatelessWidget {
  const SearchProductPage({super.key});
  void loadData(RxList<Product> listProduct, RxString sortType) {
    if (sortType.value == 'new') {
      Get.find<ProductController>()
          .listProduct
          .value
          .sort((a, b) => b.create_at.compareTo(a.create_at));
    }
    if (sortType.value == 'sell') {
      Get.find<ProductController>()
          .listProduct
          .value
          .sort((a, b) => b.sale_num!.compareTo(a.sale_num!));
    }
    if (sortType.value == 'ratting') {
      Get.find<ProductController>()
          .listProduct
          .value
          .sort((a, b) => b.ratting!.compareTo(a.ratting!));
    }
    if (sortType.value == 'price_asc') {
      Get.find<ProductController>()
          .listProduct
          .value
          .sort((a, b) => a.price.compareTo(b.price));
    }
    if (sortType.value == 'price_desc') {
      Get.find<ProductController>()
          .listProduct
          .value
          .sort((a, b) => b.price.compareTo(a.price));
    }
    // List<String> listCategoryID = [];
    ProductController productController = Get.find<ProductController>();
    // if (productController.searchProductController.value.text.isNotEmpty) {
    //   for (var element in Get.find<CategoryController>()
    //       .listCategory
    //       .where((p0) => p0.hide == false)
    //       .where((p0) =>
    //           productController.searchProductController.value.text.isEmpty ||
    //           removeDiacritics(p0.name.toLowerCase()).contains(removeDiacritics(
    //               productController.searchProductController.value.text
    //                   .toLowerCase())))) {
    //     listCategoryID.add(element.id);
    //   }
    //   listProduct.value = Get.find<ProductController>()
    //       .listProduct
    //       .where((p0) =>
    //           p0.status == 'active' &&
    //           (removeDiacritics(p0.name.toLowerCase()).contains(
    //                   removeDiacritics(productController
    //                       .searchProductController.value.text
    //                       .toLowerCase())) ||
    //               listCategoryID.contains(p0.category_id)))
    //       .toList();
    // } else if (productController.category.value.id != '') {
    //   listProduct.value = Get.find<ProductController>()
    //       .listProduct
    //       .where((p0) =>
    //           p0.status == 'active' &&
    //           p0.category_id == productController.category.value.id)
    //       .toList();
    // } else {
    //   listProduct.value = productController.listProduct;
    // }
    listProduct.value = productController.listProduct
        .where(
          (p0) => p0.status == 'active',
        )
        .toList();
    if (productController.searchProductController.value.text.isNotEmpty) {
      listProduct.value = Get.find<ProductController>()
          .listProduct
          .where((p0) =>
              p0.status == 'active' &&
              (removeDiacritics(p0.name.toLowerCase()).contains(
                  removeDiacritics(productController
                      .searchProductController.value.text
                      .toLowerCase()))))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    MainController mainController = Get.find<MainController>();
    RxList<Product> listProduct = <Product>[].obs;
    TextEditingController categoryController = TextEditingController();
    TextEditingController provinceController = TextEditingController();
    Rx<Category> category = Category.initCategory().obs;
    Rx<Province> province = Province.initProvince().obs;
    List<dynamic> listSortType = [
      {'value': 'new', 'label': 'Mới nhất'},
      {'value': 'sell', 'label': 'Bán chạy nhất'},
      {'value': 'ratting', 'label': 'Đánh giá cao nhất'},
      {'value': 'price_asc', 'label': 'Giá tăng dần'},
      {'value': 'price_desc', 'label': 'Giá giảm dần'},
    ];
    RxString sortType = ''.obs;
    category.value = Get.find<ProductController>().category.value;

    return Obx(() {
      loadData(listProduct, sortType);
      if (category.value.id != '') {
        listProduct.value = listProduct
            .where(
              (p0) => p0.category_id == category.value.id,
            )
            .toList();
      }
      if (province.value.id != '') {
        List<Seller> listSeller = Get.find<SellerController>()
            .listSeller
            .where((seller) => seller.province_id == province.value.id)
            .toList();
        listProduct.value = listProduct
            .where(
              (p0) => listSeller
                  .map(
                    (e) => e.id,
                  )
                  .contains(p0.seller_id),
            )
            .toList();
      }
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
                                    loadData(listProduct, sortType);
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
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: Get.width * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: Get.width * 0.3,
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Loại sản phẩm',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    value: Get.find<CategoryController>()
                                        .listCategory
                                        .firstWhereOrNull((element) =>
                                            element.id == category.value.id),
                                    items: [
                                      DropdownMenuItem(
                                        value: Category.initCategory(),
                                        child: const Text(
                                          'Tất cả',
                                          overflow: TextOverflow.ellipsis,
                                          strutStyle: StrutStyle.disabled,
                                        ),
                                      ),
                                      for (var category
                                          in Get.find<CategoryController>()
                                              .listCategory
                                              .where(
                                                  (element) => !element.hide))
                                        DropdownMenuItem(
                                          value: category,
                                          child: Text(
                                            category.name,
                                            overflow: TextOverflow.ellipsis,
                                            strutStyle: StrutStyle.disabled,
                                          ),
                                        ),
                                    ],
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                    ),
                                    isExpanded: true,
                                    onChanged: (value) {
                                      category.value = value!;
                                    },
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: Get.height / 2,
                                      width: Get.width * 0.75,
                                      // padding: EdgeInsets.all(5),
                                    ),
                                    buttonStyleData: ButtonStyleData(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.green,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                    ),
                                    dropdownSearchData: DropdownSearchData(
                                        searchController: categoryController,
                                        searchInnerWidgetHeight:
                                            Get.height * 0.05,
                                        searchInnerWidget: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 8, 8, 0),
                                          child: TextField(
                                            controller: categoryController,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.red)),
                                                hintText:
                                                    'Tìm kiếm loại sản phẩm theo tên',
                                                contentPadding:
                                                    const EdgeInsets.all(10)),
                                          ),
                                        ),
                                        searchMatchFn:
                                            (DropdownMenuItem<Category> item,
                                                searchValue) {
                                          return removeDiacritics(item
                                                  .value!.name
                                                  .toLowerCase())
                                              .contains(removeDiacritics(
                                                  searchValue.toLowerCase()));
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: Get.width * 0.3,
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tỉnh thành',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    value: Get.find<ProvinceController>()
                                        .listProvince
                                        .firstWhereOrNull((element) =>
                                            element.id == province.value.id),
                                    items: [
                                      DropdownMenuItem(
                                        value: Province.initProvince(),
                                        child: const Text(
                                          'Tất cả',
                                          overflow: TextOverflow.ellipsis,
                                          strutStyle: StrutStyle.disabled,
                                        ),
                                      ),
                                      for (var province
                                          in Get.find<ProvinceController>()
                                              .listProvince)
                                        DropdownMenuItem(
                                          value: province,
                                          child: Text(
                                            province.name,
                                            overflow: TextOverflow.ellipsis,
                                            strutStyle: StrutStyle.disabled,
                                          ),
                                        ),
                                    ],
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                    ),
                                    isExpanded: true,
                                    onChanged: (value) {
                                      province.value = value!;
                                    },
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: Get.height / 2,
                                      width: Get.width * 0.75,
                                      // padding: EdgeInsets.all(5),
                                    ),
                                    buttonStyleData: ButtonStyleData(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.green,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                    ),
                                    dropdownSearchData: DropdownSearchData(
                                        searchController: provinceController,
                                        searchInnerWidgetHeight:
                                            Get.height * 0.05,
                                        searchInnerWidget: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 8, 8, 0),
                                          child: TextField(
                                            controller: provinceController,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.red)),
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
                              ],
                            ),
                          ),
                          Container(
                            width: Get.width * 0.3,
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Sắp xếp',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    value: listSortType.firstWhereOrNull(
                                        (item) =>
                                            item['value'] == sortType.value),
                                    items: listSortType
                                        .map(
                                          (item) => DropdownMenuItem(
                                            value: item,
                                            child: Text(
                                              item['label'],
                                              overflow: TextOverflow.ellipsis,
                                              strutStyle: StrutStyle.disabled,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                    ),
                                    isExpanded: true,
                                    onChanged: (item) {
                                      if (item != null) {
                                        Map<String, dynamic> data =
                                            item as Map<String, dynamic>;
                                        sortType.value = data["value"];
                                      }
                                    },
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: Get.height / 2,
                                      width: Get.width * 0.75,
                                      // padding: EdgeInsets.all(5),
                                    ),
                                    buttonStyleData: ButtonStyleData(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.green,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
