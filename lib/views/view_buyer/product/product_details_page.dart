import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/buyer_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/cart_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/review_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/buyer.dart';
import 'package:htql_mua_ban_nong_san/models/cart.dart';
import 'package:htql_mua_ban_nong_san/models/order.dart';
import 'package:htql_mua_ban_nong_san/models/product_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:htql_mua_ban_nong_san/models/review.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:intl/intl.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    ProductController productController = Get.find<ProductController>();
    List<ProductImage> listImageUrl = Get.find<ProductController>()
        .listProductImage
        .where((p0) => p0.product_id == productController.product.value.id)
        .toList();
    Seller seller = Get.find<SellerController>().listSeller.firstWhereOrNull(
            (p0) => p0.id == productController.product.value.seller_id) ??
        Seller.initSeller();
    final CarouselSliderController controller = CarouselSliderController();
    RxInt currentImg = 0.obs;
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return Obx(() {
      // print(Get.find<ReviewController>().listReview.length);
      return mainController.isLoading.value ||
              Get.find<ReviewController>().isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  actions: [
                    Get.find<MainController>().buyer.value.id == ''
                        ? const SizedBox()
                        : InkWell(
                            onTap: () async {
                              mainController.isLoading.value = true;
                              await Get.find<CartController>()
                                  .getCartGroupBySeller();
                              Get.find<CartController>().listCartChoose.value =
                                  [];
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
                                        NumberFormat.decimalPattern().format(
                                            Get.find<CartController>()
                                                .countCart
                                                .value),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
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
                body: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          //Image Product
                          Column(
                            children: [
                              CarouselSlider(
                                items: listImageUrl
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
                                  height: Get.height * 0.5,
                                  onPageChanged: (index, reson) {
                                    currentImg.value = index;
                                  },
                                  autoPlay: true,
                                ),
                                carouselController: controller,
                              ),
                              Container(
                                margin: EdgeInsets.all(Get.width * 0.01),
                                height: Get.height * 0.075,
                                child: ListView.builder(
                                  // This next line does the trick.
                                  scrollDirection: Axis.horizontal,

                                  itemCount: listImageUrl.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        controller.animateToPage(index);
                                      },
                                      child: Container(
                                        width: Get.width * 0.2,
                                        margin:
                                            EdgeInsets.all(Get.width * 0.001),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: currentImg.value == index
                                              ? Border.all(
                                                  style: BorderStyle.solid,
                                                  color: Colors.green,
                                                  width: 3)
                                              : null,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              listImageUrl[index].image,
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                          boxShadow: currentImg.value == index
                                              ? [
                                                  const BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(4.0, 4.0),
                                                    blurRadius: 10.0,
                                                    spreadRadius: 2.0,
                                                  ),
                                                ]
                                              : [],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    listImageUrl.asMap().entries.map((entry) {
                                  return GestureDetector(
                                    onTap: () =>
                                        controller.animateToPage(entry.key),
                                    child: Container(
                                      // width: 12.0,
                                      // height: 12.0,
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
                          // Price
                          Container(
                            alignment: Alignment.centerLeft,
                            width: Get.width * 0.8,
                            margin: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.05,
                            ),
                            // height: Get.height * 0.075,
                            child: Text(
                              '${currencyFormatter.format(productController.product.value.price)}/${productController.product.value.unit}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                          //Product Name
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.05,
                            ),
                            // height: Get.height * 0.075,
                            child: Text(
                              productController.product.value.name,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                // alignment: Alignment.centerLeft,
                                width: Get.width * 0.4,
                                margin: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.05,
                                ),
                                // height: Get.height * 0.075,
                                child: Text(
                                  'Đã bán: ${productController.product.value.sale_num == 0 ? 0 : NumberFormat.decimalPatternDigits(decimalDigits: 0).format(productController.product.value.sale_num)}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * 0.02),
                                alignment: Alignment.centerRight,
                                width: Get.width * 0.5,
                                child: productController
                                            .product.value.ratting ==
                                        0
                                    ? const Text(
                                        'Chưa có đánh giá',
                                        style: TextStyle(
                                          fontSize: 14,
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
                                              rating: productController
                                                      .product.value.ratting ??
                                                  0,
                                              itemBuilder: (context, index) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              itemCount: 5,
                                              itemSize: Get.width * 0.055,
                                              direction: Axis.horizontal,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: Get.width * 0.1,
                                            child: Text(
                                              '(${NumberFormat.decimalPatternDigits(decimalDigits: 1).format(productController.product.value.ratting)})',
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
                            ],
                          ),
                          Divider(
                            thickness: Get.height * 0.01,
                            color: Colors.grey[200],
                          ),
                          //shop
                          Container(
                            width: Get.width,
                            decoration: const BoxDecoration(
                                // color: Colors.white30,
                                // border: Border.symmetric(
                                //   horizontal: BorderSide(
                                //       color: Colors.grey.shade100,
                                //       style: BorderStyle.solid),
                                // ),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.grey,
                                //     offset: Offset(0, 0),
                                //     blurRadius: 10.0,
                                //     spreadRadius: 0,
                                //   ),
                                // ],
                                ),
                            margin: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.05,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: Get.width * 0.01,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: Get.width * 0.15,
                                  width: Get.width * 0.15,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(seller.avatar ?? ''),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: Get.width * 0.15,
                                  width: Get.width * 0.45,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    seller.name,
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  // height: Get.width * 0.15,
                                  width: Get.width * 0.25,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: const ButtonStyle(
                                      shape: MaterialStatePropertyAll(
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
                                      child: const Text(
                                        'Xem',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: Get.height * 0.01,
                            color: Colors.grey[200],
                          ),
                          productController.product.value.expripy_date == null
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: Get.width * 0.05,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Hạn sử dụng',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            '${NumberFormat.decimalPattern().format(productController.product.value.expripy_date ?? 0)} ngày',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: Get.height * 0.01,
                                      color: Colors.grey[200],
                                    ),
                                  ],
                                ),
                          // description
                          Container(
                            padding: EdgeInsets.only(
                                bottom: Get.width * 0.01,
                                top: Get.width * 0.01),
                            alignment: Alignment.bottomCenter,
                            child: const Text(
                              'Mô tả: ',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(Get.width * 0.03),
                            padding: EdgeInsets.all(Get.width * 0.03),
                            height: Get.height * 0.35,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              // border: Border.all(
                              //   color: Colors.grey.shade300,
                              // ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(4.0, 4.0),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView(
                                    children: [
                                      Text(
                                        '${productController.product.value.description}',
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.green),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Get.find<ReviewController>().listReview.isEmpty
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Divider(
                                      thickness: Get.height * 0.01,
                                      color: Colors.grey[200],
                                    ),
                                    // review
                                    Container(
                                      // height: Get.width * 0.15,
                                      // width: Get.width * 0.8,
                                      padding: EdgeInsets.only(
                                          bottom: Get.width * 0.01,
                                          top: Get.width * 0.01),
                                      alignment: Alignment.bottomCenter,
                                      child: const Text(
                                        'Đánh giá: ',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Get.width * 0.02),
                                          alignment: Alignment.centerRight,
                                          width: Get.width * 0.5,
                                          child: productController
                                                      .product.value.ratting ==
                                                  0
                                              ? const Text(
                                                  'Chưa có đánh giá',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.green,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Row(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      width: Get.width * 0.3,
                                                      child: RatingBarIndicator(
                                                        rating:
                                                            productController
                                                                    .product
                                                                    .value
                                                                    .ratting ??
                                                                0,
                                                        itemBuilder:
                                                            (context, index) =>
                                                                const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        itemCount: 5,
                                                        itemSize:
                                                            Get.width * 0.055,
                                                        direction:
                                                            Axis.horizontal,
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      width: Get.width * 0.1,
                                                      child: Text(
                                                        '(${NumberFormat.decimalPatternDigits(decimalDigits: 1).format(productController.product.value.ratting)})',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.green,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          width: Get.width * 0.4,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: Get.width * 0.05,
                                          ),
                                          child: Text(
                                            '${Get.find<ReviewController>().listReview.length} lượt đánh giá',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(Get.width * 0.03),
                                      padding: EdgeInsets.all(Get.width * 0.03),
                                      height: Get.height * 0.35,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        // border: Border.all(
                                        //   color: Colors.grey.shade300,
                                        // ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(4.0, 4.0),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ListView(
                                              children:
                                                  Get.find<ReviewController>()
                                                      .listReview
                                                      .map(
                                                (item) {
                                                  return reviewDetail(item);
                                                },
                                              ).toList(),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    Get.find<MainController>().buyer.value.id == ''
                        ? const SizedBox()
                        : Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.05,
                            ),
                            width: Get.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    Rx<TextEditingController>
                                        quantityController =
                                        TextEditingController(text: '1').obs;
                                    ProductImage productImage =
                                        productController.listProductImage
                                                .firstWhereOrNull((item) =>
                                                    item.product_id ==
                                                        productController
                                                            .product.value.id &&
                                                    item.is_default) ??
                                            ProductImage.initProductImage();

                                    final formKey = GlobalKey<FormState>();
                                    await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom, // Thêm khoảng cách để tránh bị bàn phím che
                                            ),
                                            child: SizedBox(
                                              height: Get.height * 0.4,
                                              width: Get.width,
                                              child: Form(
                                                key: formKey,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  Get.width *
                                                                      0.05),
                                                          width:
                                                              Get.width * 0.2,
                                                          height:
                                                              Get.width * 0.3,
                                                          decoration:
                                                              BoxDecoration(
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    productImage
                                                                        .image)),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  20),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          // height: Get.width * 0.25,
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                width:
                                                                    Get.width *
                                                                        0.6,
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal:
                                                                      Get.width *
                                                                          0.05,
                                                                ),
                                                                // height: Get.height * 0.075,
                                                                child: Text(
                                                                  productController
                                                                      .product
                                                                      .value
                                                                      .name,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .clip,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                width:
                                                                    Get.width *
                                                                        0.6,
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal:
                                                                      Get.width *
                                                                          0.05,
                                                                ),
                                                                // height: Get.height * 0.075,
                                                                child: Text(
                                                                  '${currencyFormatter.format(productController.product.value.price)}/${productController.product.value.unit}',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .clip,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                width:
                                                                    Get.width *
                                                                        0.6,
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal:
                                                                      Get.width *
                                                                          0.05,
                                                                ),
                                                                // height: Get.height * 0.075,
                                                                child: Text(
                                                                  "Kho: ${productController.product.value.quantity} ${productController.product.value.unit}",
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .clip,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const Divider(),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  Get.width *
                                                                      0.05),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            "Số lượng:",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                Get.width * 0.5,
                                                            child: Row(
                                                              children: [
                                                                InkWell(
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .remove_circle_outline,
                                                                    size: 30,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                  onTap: () {
                                                                    if (int.parse(quantityController
                                                                            .value
                                                                            .text) >
                                                                        0) {
                                                                      quantityController
                                                                          .value
                                                                          .text = '${int.parse(quantityController.value.text) - 1}';
                                                                    }
                                                                  },
                                                                ),
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width:
                                                                      Get.width *
                                                                          0.2,
                                                                  child:
                                                                      TextFormField(
                                                                    validator:
                                                                        (value) {
                                                                      if (double.parse(
                                                                              value!) <=
                                                                          0) {
                                                                        return 'Số lượng phải lớn hơn 0';
                                                                      }
                                                                      if (double.parse(
                                                                              value) >
                                                                          productController
                                                                              .product
                                                                              .value
                                                                              .quantity) {
                                                                        return 'Số lượng trong kho không đủ';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    controller:
                                                                        quantityController
                                                                            .value,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    inputFormatters: [
                                                                      FilteringTextInputFormatter
                                                                          .digitsOnly
                                                                    ],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                    ),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        color: Colors
                                                                            .green),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .add_circle_outline,
                                                                    size: 30,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                  onTap: () {
                                                                    quantityController
                                                                            .value
                                                                            .text =
                                                                        '${int.parse(quantityController.value.text) + 1}';
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        if (formKey
                                                            .currentState!
                                                            .validate()) {
                                                          Cart cart = Cart(
                                                            id: '',
                                                            buyer_id: Get.find<
                                                                    MainController>()
                                                                .buyer
                                                                .value
                                                                .id,
                                                            product_id:
                                                                productController
                                                                    .product
                                                                    .value
                                                                    .id,
                                                            quantity:
                                                                double.parse(
                                                              quantityController
                                                                  .value.text,
                                                            ),
                                                            create_at:
                                                                Timestamp.now(),
                                                          );
                                                          // Get.back();
                                                          await Get.find<
                                                                  CartController>()
                                                              .createCart(cart);
                                                          // // ignore: use_build_context_synchronously
                                                          // await AwesomeDialog(
                                                          //   titleTextStyle:
                                                          //       const TextStyle(
                                                          //     color: Colors.green,
                                                          //     fontWeight:
                                                          //         FontWeight.bold,
                                                          //     fontSize: 22,
                                                          //   ),
                                                          //   descTextStyle:
                                                          //       const TextStyle(
                                                          //     color: Colors.green,
                                                          //     fontSize: 16,
                                                          //   ),
                                                          //   context: context,
                                                          //   dialogType: DialogType
                                                          //       .success,
                                                          //   animType: AnimType
                                                          //       .rightSlide,
                                                          //   title:
                                                          //       'Thêm giỏ hàng thành công',
                                                          //   btnOkOnPress: () {},
                                                          // ).show();
                                                          Get.back();
                                                        }
                                                      },
                                                      style: const ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                Colors.green),
                                                        shape:
                                                            MaterialStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  20),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            const BoxDecoration(),
                                                        // height: Get.width * 0.1,
                                                        width: Get.width * 0.8,
                                                        child: const Text(
                                                          'Thêm giỏ hàng',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.green),
                                    shape: MaterialStatePropertyAll(
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
                                    // height: Get.width * 0.1,
                                    width: Get.width * 0.3,
                                    child: const Text(
                                      'Thêm giỏ hàng',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Rx<TextEditingController>
                                        quantityController =
                                        TextEditingController(text: '1').obs;

                                    ProductImage productImage =
                                        productController.listProductImage
                                                .firstWhereOrNull((item) =>
                                                    item.product_id ==
                                                        productController
                                                            .product.value.id &&
                                                    item.is_default) ??
                                            ProductImage.initProductImage();

                                    await showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Obx(
                                            () => SizedBox(
                                              height: Get.height * 0.4,
                                              width: Get.width,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.all(
                                                            Get.width * 0.05),
                                                        width: Get.width * 0.2,
                                                        height: Get.width * 0.3,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  productImage
                                                                      .image)),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(20),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        // height: Get.width * 0.25,
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              width: Get.width *
                                                                  0.6,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    Get.width *
                                                                        0.05,
                                                              ),
                                                              // height: Get.height * 0.075,
                                                              child: Text(
                                                                productController
                                                                    .product
                                                                    .value
                                                                    .name,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              width: Get.width *
                                                                  0.6,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    Get.width *
                                                                        0.05,
                                                              ),
                                                              // height: Get.height * 0.075,
                                                              child: Text(
                                                                '${currencyFormatter.format(productController.product.value.price)}/${productController.product.value.unit}',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              width: Get.width *
                                                                  0.6,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    Get.width *
                                                                        0.05,
                                                              ),
                                                              // height: Get.height * 0.075,
                                                              child: Text(
                                                                "Kho: ${productController.product.value.quantity} ${productController.product.value.unit}",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                Get.width *
                                                                    0.05),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          "Số lượng:",
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              Get.width * 0.5,
                                                          child: Row(
                                                            children: [
                                                              InkWell(
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .remove_circle_outline,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                                onTap: () {
                                                                  if (int.parse(quantityController
                                                                          .value
                                                                          .text) >
                                                                      0) {
                                                                    quantityController
                                                                            .value
                                                                            .text =
                                                                        '${int.parse(quantityController.value.text) - 1}';
                                                                  }
                                                                },
                                                              ),
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width:
                                                                    Get.width *
                                                                        0.2,
                                                                child:
                                                                    TextFormField(
                                                                  onChanged:
                                                                      (value) {},
                                                                  controller:
                                                                      quantityController
                                                                          .value,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  inputFormatters: [
                                                                    FilteringTextInputFormatter
                                                                        .digitsOnly
                                                                  ],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                  ),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .green),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .add_circle_outline,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                                onTap: () {
                                                                  quantityController
                                                                          .value
                                                                          .text =
                                                                      '${int.parse(quantityController.value.text) + 1}';
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Get.find<CartController>()
                                                          .listCartChoose
                                                          .value = [];
                                                      Get.find<CartController>()
                                                          .listCartChoose
                                                          .add(
                                                            Cart(
                                                                id: '',
                                                                buyer_id: Get.find<
                                                                        MainController>()
                                                                    .buyer
                                                                    .value
                                                                    .id,
                                                                product_id:
                                                                    productController
                                                                        .product
                                                                        .value
                                                                        .id,
                                                                quantity: int.parse(
                                                                        quantityController
                                                                            .value
                                                                            .text)
                                                                    .toDouble(),
                                                                create_at:
                                                                    Timestamp
                                                                        .now()),
                                                          );
                                                      // print(Get.find<
                                                      //         CartController>()
                                                      //     .listCartChoose
                                                      //     .length);
                                                      Get.toNamed('checkout');
                                                    },
                                                    style: const ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.green),
                                                      shape:
                                                          MaterialStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(20),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration:
                                                          const BoxDecoration(),
                                                      // height: Get.width * 0.1,
                                                      width: Get.width * 0.8,
                                                      child: const Text(
                                                        'Đặt hàng',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.green),
                                    shape: MaterialStatePropertyAll(
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
                                    // height: Get.width * 0.1,
                                    width: Get.width * 0.3,
                                    child: const Text(
                                      'Mua hàng',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                  ],
                ),
              ),
            );
    });
  }

  Container reviewDetail(Review item) {
    Orders order = Get.find<OrderController>()
            .listOrder
            .firstWhereOrNull((element) => element.id == item.order_id) ??
        Orders.initOrder();
    Buyer buyer = Get.find<BuyerController>()
            .listBuyer
            .firstWhereOrNull((element) => element.id == order.buyer_id) ??
        Buyer.initBuyer();
    return Container(
      margin: EdgeInsets.only(
        bottom: Get.height * 0.015,
      ),
      decoration: const BoxDecoration(
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
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Get.width,
            margin: EdgeInsets.symmetric(
              horizontal: Get.width * 0.02,
            ),
            padding: EdgeInsets.symmetric(
              vertical: Get.width * 0.01,
              horizontal: Get.width * 0.01,
            ),
            child: Row(
              children: [
                Container(
                  height: Get.width * 0.1,
                  width: Get.width * 0.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: buyer.avatar!.isEmpty
                        ? null
                        : DecorationImage(
                            image: NetworkImage(buyer.avatar ?? ''),
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.02,
                ),
                Container(
                  // height: Get.width * 0.1,
                  width: Get.width * 0.6,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    buyer.name,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                alignment: Alignment.centerRight,
                width: Get.width * 0.85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          width: Get.width * 0.15,
                          child: RatingBarIndicator(
                            rating: item.ratting,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: Get.width * 0.03,
                            direction: Axis.horizontal,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          width: Get.width * 0.1,
                          child: Text(
                            '(${NumberFormat.decimalPatternDigits(decimalDigits: 1).format(item.ratting)})',
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
                    Container(
                      alignment: Alignment.centerRight,
                      width: Get.width * 0.5,
                      child: Text(
                        DateFormat('kk:mm a - dd/MM/yyyy')
                            .format(item.create_at.toDate()),
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
            ],
          ),
          const Divider(),
          Container(
            width: Get.width * 0.9,
            // padding: EdgeInsets.symmetric(
            //   horizontal: Get.width * 0.02,
            //   vertical: Get.width * 0.02,
            // ),
            padding: EdgeInsets.only(
              bottom: Get.width * 0.02,
              right: Get.width * 0.02,
              left: Get.width * 0.02,
            ),
            child: Text(
              item.comment,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
