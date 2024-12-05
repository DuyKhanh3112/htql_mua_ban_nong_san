import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convert_vietnamese/convert_vietnamese.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/category_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/province_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/category.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';
import 'package:htql_mua_ban_nong_san/models/product_image.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProductSellerFormPage extends StatelessWidget {
  const ProductSellerFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find<ProductController>();

    final formKey = GlobalKey<FormState>();

    TextEditingController searchCategory = TextEditingController();
    TextEditingController searchprovince = TextEditingController();

    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController expripyDateController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController unitController = TextEditingController();

    RxList<dynamic> listFilePath = <dynamic>[].obs;
    RxList<ProductImage> listImageUrl = <ProductImage>[].obs;
    Rx<Category> category = Category.initCategory().obs;
    Rx<Province> province = Province.initProvince().obs;

    final picker = ImagePicker();

    loadData(
        productController,
        category,
        province,
        nameController,
        descriptionController,
        expripyDateController,
        priceController,
        quantityController,
        unitController,
        listImageUrl);

    return Obx(() {
      return productController.isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  title: Text(
                    Get.find<MainController>().seller.value.id == ''
                        ? 'Thông tin sản phẩm'
                        : productController.product.value.id == ''
                            ? 'Thêm sản phẩm'
                            : "Cập nhật sản phẩm",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  foregroundColor: Colors.white,
                ),
                body: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Container(
                      padding: EdgeInsets.all(Get.width * 0.05),
                      child: Column(
                        children: [
                          TextFormField(
                            readOnly:
                                Get.find<MainController>().seller.value.id ==
                                    '',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                            ),
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty || value.trim() == '') {
                                return 'Hãy nhập tên sản phẩm';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              // fillColor: Colors.amber,

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
                              labelText: 'Tên sản phẩm',
                              labelStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Get.width * 0.44,
                                // padding: const EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Loại sản phẩm',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        value: Get.find<CategoryController>()
                                            .listCategory
                                            .firstWhereOrNull((element) =>
                                                element.id ==
                                                    category.value.id &&
                                                element.hide == false),
                                        items: Get.find<CategoryController>()
                                            .listCategory
                                            .where((p0) => p0.hide == false)
                                            .map(
                                              (category) => DropdownMenuItem(
                                                value: category,
                                                child: Text(
                                                  category.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  strutStyle:
                                                      StrutStyle.disabled,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 18,
                                        ),
                                        isExpanded: true,
                                        onChanged: Get.find<MainController>()
                                                    .seller
                                                    .value
                                                    .id ==
                                                ''
                                            ? null
                                            : (value) {
                                                if (value == null) {
                                                  category.value =
                                                      Category.initCategory();
                                                } else {
                                                  // print(value);
                                                  category.value =
                                                      value as Category;
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.all(5),
                                        ),
                                        dropdownSearchData: DropdownSearchData(
                                            searchController: searchCategory,
                                            searchInnerWidgetHeight:
                                                Get.height * 0.05,
                                            searchInnerWidget: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 8, 8, 0),
                                              child: TextField(
                                                controller: searchCategory,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .red)),
                                                    hintText:
                                                        'Tìm kiếm loại sản phẩm theo tên',
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10)),
                                              ),
                                            ),
                                            searchMatchFn:
                                                (DropdownMenuItem<Category>
                                                        item,
                                                    searchValue) {
                                              return removeDiacritics(item
                                                      .value!.name
                                                      .toLowerCase())
                                                  .contains(removeDiacritics(
                                                      searchValue
                                                          .toLowerCase()));
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.44,
                                // padding: const EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Xuất xứ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        value: Get.find<ProvinceController>()
                                            .listProvince
                                            .firstWhereOrNull((element) =>
                                                element.id ==
                                                province.value.id),
                                        items: Get.find<ProvinceController>()
                                            .listProvince
                                            .map(
                                              (province) => DropdownMenuItem(
                                                value: province,
                                                child: Text(
                                                  province.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  strutStyle:
                                                      StrutStyle.disabled,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 18,
                                        ),
                                        isExpanded: true,
                                        onChanged: Get.find<MainController>()
                                                    .seller
                                                    .value
                                                    .id ==
                                                ''
                                            ? null
                                            : (value) {
                                                if (value == null) {
                                                  province.value =
                                                      Province.initProvince();
                                                } else {
                                                  province.value =
                                                      value as Province;
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.all(5),
                                        ),
                                        dropdownSearchData: DropdownSearchData(
                                            searchController: searchprovince,
                                            searchInnerWidgetHeight:
                                                Get.height * 0.05,
                                            searchInnerWidget: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 8, 8, 0),
                                              child: TextField(
                                                controller: searchprovince,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .red)),
                                                    hintText:
                                                        'Tìm kiếm tỉnh thành theo tên',
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10)),
                                              ),
                                            ),
                                            searchMatchFn:
                                                (DropdownMenuItem<Province>
                                                        item,
                                                    searchValue) {
                                              return removeDiacritics(item
                                                      .value!.name
                                                      .toLowerCase())
                                                  .contains(removeDiacritics(
                                                      searchValue
                                                          .toLowerCase()));
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Get.width * 0.44,
                                child: TextFormField(
                                  readOnly: Get.find<MainController>()
                                          .seller
                                          .value
                                          .id ==
                                      '',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                  controller: priceController,
                                  validator: (value) {
                                    if (value!.isEmpty || value.trim() == '') {
                                      return 'Hãy nhập giá sản phẩm';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d*')),
                                  ],
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                    labelText: 'Giá sản phẩm',
                                    labelStyle: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.44,
                                child: TextFormField(
                                  readOnly: Get.find<MainController>()
                                          .seller
                                          .value
                                          .id ==
                                      '',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                  controller: quantityController,
                                  validator: (value) {
                                    if (value!.isEmpty || value.trim() == '') {
                                      return 'Hãy nhập số lượng sản phẩm';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                    labelText: 'Số lượng sản phẩm',
                                    labelStyle: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Get.width * 0.44,
                                child: TextFormField(
                                  readOnly: Get.find<MainController>()
                                          .seller
                                          .value
                                          .id ==
                                      '',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                  controller: unitController,
                                  validator: (value) {
                                    if (value!.isEmpty || value.trim() == '') {
                                      return 'Hãy nhập đơn vị tính';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                    labelText: 'Đơn vị tính',
                                    labelStyle: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.44,
                                child: TextFormField(
                                  readOnly: Get.find<MainController>()
                                          .seller
                                          .value
                                          .id ==
                                      '',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                  controller: expripyDateController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d*')),
                                  ],
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                    labelText: 'Số ngày hết hạn',
                                    labelStyle: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                    ),
                                    suffix: Text('Ngày'),
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
                            controller: descriptionController,
                            minLines: 2,
                            maxLines: 4,
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
                              labelText: 'Mô tả',
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
                                        listFilePath.add({
                                          'path': pickedFile.path,
                                          'is_defalut': listFilePath.isEmpty &&
                                              listImageUrl.isEmpty
                                        });
                                      }
                                    } else if (typeSource.value == 'gallery') {
                                      List<XFile> res =
                                          await picker.pickMultiImage();
                                      for (var img in res) {
                                        // listFilePath.add(img.path);
                                        listFilePath.add({
                                          'path': img.path,
                                          'is_defalut': listFilePath.isEmpty &&
                                              listImageUrl.isEmpty
                                        });
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
                                      for (var urlIndex = 0;
                                          urlIndex < listImageUrl.length;
                                          urlIndex++)
                                        Stack(
                                          alignment: Alignment.bottomCenter,
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
                                              child: Container(
                                                // height: Get.height * 0.1,

                                                width: Get.width * 0.2,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        listImageUrl[urlIndex]
                                                            .image),
                                                    fit: BoxFit.fill,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(20),
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
                                                : listImageUrl[urlIndex]
                                                        .is_default
                                                    ? Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: InkWell(
                                                          onTap: () {},
                                                          child: Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: const Icon(
                                                                Icons
                                                                    .check_circle,
                                                                color: Colors
                                                                    .green,
                                                              )),
                                                        ),
                                                      )
                                                    : Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: InkWell(
                                                          onTap: () {
                                                            // listFilePath
                                                            //     .removeAt(pathIndex);
                                                            listImageUrl
                                                                .removeAt(
                                                                    urlIndex);
                                                          },
                                                          child: Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              child: const Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ),
                                                      )
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
                                                            pathIndex]['path']),
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
                                            listFilePath[pathIndex]
                                                    ['is_defalut']
                                                ? Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: InkWell(
                                                      onTap: () {},
                                                      child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.white,
                                                          ),
                                                          child: const Icon(
                                                            Icons.check_circle,
                                                            color: Colors.green,
                                                          )),
                                                    ),
                                                  )
                                                : Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: InkWell(
                                                      onTap: () {
                                                        listFilePath.removeAt(
                                                            pathIndex);
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
                        ],
                      ),
                    ),
                  ),
                ),
                // drawer: const DrawerSeller(),
                floatingActionButton: Get.find<MainController>()
                            .seller
                            .value
                            .id ==
                        ''
                    ? null
                    : FloatingActionButton.extended(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            Category? categorySubmit =
                                Get.find<CategoryController>()
                                    .listCategory
                                    .firstWhereOrNull((p0) =>
                                        p0.id == category.value.id &&
                                        p0.hide == false);
                            Province? provinceSubmit =
                                Get.find<ProvinceController>()
                                    .listProvince
                                    .firstWhereOrNull((element) =>
                                        element.id == province.value.id);
                            if (provinceSubmit == null) {
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
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Hãy chọn tỉnh thành',
                                btnOkOnPress: () {},
                              ).show();
                            } else if (listFilePath.isEmpty &&
                                listImageUrl.isEmpty) {
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
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Hãy chọn ảnh cho sản phẩm',
                                desc: 'Ít nhất là 1 ảnh.',
                                btnOkOnPress: () {},
                              ).show();
                            } else {
                              Product? pro = productController.listProduct
                                  .firstWhereOrNull((p0) =>
                                      p0.id ==
                                      productController.product.value.id);
                              if (pro == null) {
//them
                                productController.product.value = Product(
                                    id: '',
                                    name: nameController.text,
                                    category_id: categorySubmit!.id,
                                    seller_id: Get.find<MainController>()
                                        .seller
                                        .value
                                        .id,
                                    price: double.parse(priceController.text),
                                    description: descriptionController.text,
                                    province_id: provinceSubmit.id,
                                    quantity:
                                        double.parse(quantityController.text),
                                    status: 'draft',
                                    expripy_date:
                                        expripyDateController.text.isEmpty
                                            ? null
                                            : double.parse(
                                                expripyDateController.text),
                                    unit: unitController.text,
                                    create_at: Timestamp.now());
                                await createProduct(
                                    productController, listFilePath, context);
                                clearAll(
                                    productController,
                                    nameController,
                                    priceController,
                                    quantityController,
                                    unitController,
                                    expripyDateController,
                                    descriptionController,
                                    listFilePath);
                                Get.back();
                              } else {
                                productController.product.value.name =
                                    nameController.text;
                                productController.product.value.category_id =
                                    categorySubmit!.id;
                                productController.product.value.province_id =
                                    provinceSubmit.id;
                                productController.product.value.price =
                                    double.parse(priceController.text
                                        .replaceAll(',', ''));
                                productController.product.value.quantity =
                                    double.parse(quantityController.text
                                        .replaceAll(',', ''));
                                productController.product.value.unit =
                                    unitController.text;
                                productController.product.value.expripy_date =
                                    expripyDateController.text.isEmpty
                                        ? null
                                        : double.parse(expripyDateController
                                            .text
                                            .replaceAll(',', ''));
                                productController.product.value.description =
                                    descriptionController.text;

                                if (productController.product.value.status ==
                                    'lock') {
                                  productController.product.value.status =
                                      'draft';
                                }

                                if (listFilePath.isNotEmpty) {
                                  await productController.createProductImage(
                                      listFilePath.value, pro.id);
                                }
                                if (listImageUrl.length <
                                    productController.listProductImage
                                        .where(
                                          (p0) => p0.product_id == pro.id,
                                        )
                                        .length) {
                                  for (var proImg in productController
                                      .listProductImage
                                      .where(
                                    (p0) =>
                                        p0.product_id == pro.id &&
                                        !listImageUrl
                                            .map(
                                              (element) => element.id,
                                            )
                                            .toList()
                                            .contains(p0.id),
                                  )) {
                                    productController.deleteProductImg(proImg);
                                  }
                                }
                                await productController.updateProduct(
                                    productController.product.value);

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
                                  title: 'Cập nhật sản phẩm thành công',
                                  btnOkOnPress: () async {},
                                ).show();
                              }
                            }
                          }
                        },
                        label: const Text(
                          'Lưu sản phẩm',
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
              ),
            );
    });
  }

  void loadData(
      ProductController productController,
      Rx<Category> category,
      Rx<Province> province,
      TextEditingController nameController,
      TextEditingController descriptionController,
      TextEditingController expripyDateController,
      TextEditingController priceController,
      TextEditingController quantityController,
      TextEditingController unitController,
      RxList<ProductImage> listImageUrl) {
    var pro = productController.listProduct
        .firstWhereOrNull((p0) => p0.id == productController.product.value.id);
    if (pro != null) {
      category.value = Get.find<CategoryController>()
              .listCategory
              .firstWhereOrNull((element) =>
                  element.id == pro.category_id && element.hide == false) ??
          Category.initCategory();
      province.value = Get.find<ProvinceController>()
              .listProvince
              .firstWhereOrNull((element) => element.id == pro.province_id) ??
          Province.initProvince();
      nameController.text = pro.name;
      descriptionController.text = pro.description ?? '';
      expripyDateController.text = pro.expripy_date != null
          ? NumberFormat.decimalPatternDigits(decimalDigits: 0)
              .format(pro.expripy_date)
              .toString()
              .toString()
          : '';
      // priceController.text = NumberFormat.decimalPatternDigits(decimalDigits: 0)
      //     .format(pro.price)
      //     .toString();
      priceController.text = pro.price.toString().replaceAll('.0', '');
      quantityController.text =
          NumberFormat.decimalPatternDigits(decimalDigits: 0)
              .format(pro.quantity)
              .toString();
      unitController.text = pro.unit;
      for (var img in productController.listProductImage
          .where((p0) => p0.product_id == pro.id)) {
        listImageUrl.add(img);
      }
    } else {
      Seller? sell = Get.find<SellerController>().listSeller.firstWhereOrNull(
          (p0) => p0.id == Get.find<MainController>().seller.value.id);
      if (sell != null) {
        province.value = Get.find<ProvinceController>()
                .listProvince
                .firstWhereOrNull(
                    (element) => element.id == sell.province_id) ??
            Province.initProvince();
      }
    }
  }

  Future<void> createProduct(ProductController productController,
      RxList<dynamic> listFilePath, BuildContext context) async {
    await productController
        // ignore: invalid_use_of_protected_member
        .createProduct(listFilePath.value);
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
      title: 'Thêm sản phẩm thành công',
      btnOkOnPress: () {},
    ).show();
  }

  void clearAll(
      ProductController productController,
      TextEditingController nameController,
      TextEditingController priceController,
      TextEditingController quantityController,
      TextEditingController unitController,
      TextEditingController expripyDateController,
      TextEditingController descriptionController,
      RxList<dynamic> listFilePath) {
    productController.category.value = Category.initCategory();
    productController.province.value = Province.initProvince();
    nameController.clear();
    priceController.clear();
    quantityController.clear();
    unitController.clear();
    expripyDateController.clear();
    descriptionController.clear();
    listFilePath.value = [];
  }
}
