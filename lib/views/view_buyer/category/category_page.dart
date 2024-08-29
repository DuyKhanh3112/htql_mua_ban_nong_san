import 'package:convert_vietnamese/convert_vietnamese.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/cart_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/category_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/category.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';
import 'package:intl/intl.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    RxDouble quantityCart = 0.0.obs;
    // quantityCart.value = Get.find<CartController>().getQuantityCart();
    quantityCart.value = 0;
    RxList<Category> listCategory = <Category>[].obs;
    Rx<TextEditingController> searchController = TextEditingController().obs;

    loadData(listCategory, searchController);
    return Obx(() {
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
                              controller: searchController.value,
                              onChanged: (value) {
                                loadData(listCategory, searchController);
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                suffixIcon: searchController.value.text.isEmpty
                                    ? null
                                    : InkWell(
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onTap: () {
                                          searchController.value.clear();
                                          loadData(
                                              listCategory, searchController);
                                        },
                                      ),
                                border: InputBorder.none,
                                hintText: 'Tìm kiếm ...',
                                hintStyle: const TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
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
                    Expanded(
                      child: ListView(
                        // children: [
                        //   for (var category
                        //       in Get.find<CategoryController>().listCategory)
                        //     Container(
                        //       height: Get.height * 0.2,
                        //       width: Get.width,
                        //       margin: EdgeInsets.all(Get.width * 0.05),
                        //       decoration: const BoxDecoration(
                        //         color: Colors.amber,
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Colors.grey,
                        //             offset: Offset(4.0, 4.0),
                        //             blurRadius: 10.0,
                        //             spreadRadius: 2.0,
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        // ],
                        children: listCategory
                            .map(
                              (category) => InkWell(
                                onTap: () {
                                  Get.find<ProductController>().category.value =
                                      category;
                                  Get.toNamed('search_product');
                                },
                                child: Container(
                                  height: Get.height * 0.15,
                                  width: Get.width,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: Get.width * 0.05,
                                    vertical: Get.width * 0.02,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Get.find<CategoryController>()
                                                      .listCategory
                                                      .indexOf(category) %
                                                  2 ==
                                              0
                                          ? const SizedBox()
                                          : Container(
                                              width: Get.width * 0.4,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        category.image),
                                                    fit: BoxFit.fill),
                                              ),
                                            ),
                                      Container(
                                        alignment:
                                            Get.find<CategoryController>()
                                                            .listCategory
                                                            .indexOf(category) %
                                                        2 !=
                                                    0
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Get.width * 0.02),
                                        width: Get.width * 0.4,
                                        decoration: const BoxDecoration(),
                                        child: Text(
                                          category.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Get.find<CategoryController>()
                                                      .listCategory
                                                      .indexOf(category) %
                                                  2 !=
                                              0
                                          ? const SizedBox()
                                          : Container(
                                              width: Get.width * 0.4,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        category.image),
                                                    fit: BoxFit.fill),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    // const Divider(),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            );
    });
  }

  void loadData(RxList<Category> listCategory,
      Rx<TextEditingController> searchController) {
    listCategory.value = [];
    listCategory.value = Get.find<ProductController>()
        .listCategory
        .where((p0) =>
            searchController.value.text.isEmpty ||
            removeDiacritics(p0.name.toLowerCase())
                .contains(searchController.value.text))
        .toList();
  }
}
