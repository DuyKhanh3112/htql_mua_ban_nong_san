import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:convert_vietnamese/convert_vietnamese.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/category_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/cloudinary_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/category.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/main_drawer.dart';
import 'package:image_picker/image_picker.dart';

class CategoryHomePage extends StatelessWidget {
  const CategoryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController categoryController = Get.find<CategoryController>();

    Rx<TextEditingController> searchController = TextEditingController().obs;

    RxList<Category> listCategory = <Category>[].obs;

    return Obx(() {
      if (searchController.value.text.isEmpty) {
        listCategory.value = categoryController.listCategory;
      } else {
        listCategory.value = categoryController.listCategory
            .where((e) => removeDiacritics(e.name.toLowerCase()).contains(
                removeDiacritics(searchController.value.text.toLowerCase())))
            .toList();
      }
      return categoryController.isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  title: const Text(
                    'Loại Sản phẩm',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  foregroundColor: Colors.white,
                  actions: [
                    InkWell(
                      onTap: () {
                        widgetCreateCategory(context);
                      },
                      child: const Icon(
                        Icons.add_circle_outline,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: const Icon(Icons.refresh),
                            onTap: () async {
                              categoryController.isLoading.value = true;
                              await categoryController.loadCategory();
                              categoryController.isLoading.value = false;
                            },
                          ),
                          SizedBox(
                            width: Get.width / 2,
                            child: Column(
                              children: [
                                TextFormField(
                                  onChanged: (value) {
                                    if (searchController.value.text == '') {
                                      listCategory.value =
                                          categoryController.listCategory;
                                    } else {
                                      listCategory.value = categoryController
                                          .listCategory
                                          .where((e) => removeDiacritics(
                                                  e.name.toLowerCase())
                                              .contains(removeDiacritics(
                                                  searchController.value.text
                                                      .toLowerCase())))
                                          .toList();
                                    }
                                  },
                                  controller: searchController.value,
                                  decoration: InputDecoration(
                                    hintText: 'Tìm kiếm ...',
                                    hintStyle: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      borderSide: BorderSide(
                                          color: Colors.green,
                                          style: BorderStyle.solid),
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                      left: 10,
                                      top: 0,
                                      bottom: 0,
                                      right: 10,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        if (searchController.value.text == '') {
                                          listCategory.value =
                                              categoryController.listCategory;
                                        } else {
                                          listCategory.value =
                                              categoryController.listCategory
                                                  .where((e) => e.name.contains(
                                                      searchController
                                                          .value.text))
                                                  .toList();
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.search,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     widgetCreateCategory(context);
                          //   },
                          //   child: const Icon(
                          //     Icons.add_circle_outline,
                          //     size: 35,
                          //     color: Colors.green,
                          //   ),
                          // ),
                          // TextButton.icon(
                          //   onPressed: () {},
                          //   icon: const Icon(
                          //     Icons.add_circle_outline,
                          //     size: 35,
                          //     color: Colors.green,
                          //   ),
                          //   label: const Text(
                          //     'Thêm loại sản phẩm',
                          //     style:
                          //         TextStyle(color: Colors.green, fontSize: 16,),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount:
                              // ignore: invalid_use_of_protected_member
                              listCategory.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            Category category =
                                // ignore: invalid_use_of_protected_member
                                listCategory.value[index];
                            return categoryDetail(category, context);
                          }),
                    ),
                  ],
                ),
                drawer: const DrawerAdmin(),
              ),
            );
    });
  }

  Widget categoryDetail(Category category, BuildContext context) {
    return Container(
      // height: Get.height / 10,
      // width: Get.width/4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(1, 1),
            blurRadius: 5,
            spreadRadius: 1.0,
          ),
        ],
      ),
      padding: EdgeInsets.all(Get.width * 0.01),
      margin: EdgeInsets.only(
        left: Get.width * 0.01,
        right: Get.width * 0.01,
        top: 5,
        bottom: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              updateCategory(category, context);
            },
            child: Row(
              children: [
                Container(
                  width: Get.width / 4,
                  height: Get.height / 10,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    // color: Colors.amber,
                    image: DecorationImage(
                      image: NetworkImage(category.image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                SizedBox(
                  width: Get.width / 2,
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            child: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onTap: () async {
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
                      dialogType: DialogType.question,
                      animType: AnimType.rightSlide,
                      title: 'Bạn có muốn xóa loại sản phẩm này không?',
                      // desc: 'Bạn có muốn xóa loại sản phẩm này không?',
                      btnOkText: 'Xóa',
                      btnCancelText: 'Không',
                      btnOkOnPress: () async {
                        Get.put(CategoryController());
                        CategoryController categoryController =
                            Get.find<CategoryController>();
                        categoryController.isLoading.value = true;
                        await CloudinaryController()
                            .deleteImage(category.id, 'category');
                        await categoryController.deleteCategory(category);
                        categoryController.isLoading.value = false;
                      },
                      btnCancelOnPress: () {})
                  .show();
            },
          ),
        ],
      ),
    );
  }

  void updateCategory(Category category, BuildContext context) {
    Rx<TextEditingController> nameController =
        TextEditingController(text: category.name).obs;

    RxString filePath = ''.obs;
    final picker = ImagePicker();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Obx(
        () => AlertDialog(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cập nhật loại sản phẩm',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
              const Divider(),
            ],
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 20,
                    ),
                    width: Get.width * 2 / 3,
                    child: TextFormField(
                      controller: nameController.value,
                      decoration: const InputDecoration(
                        label: Text('Tên loại sản phẩm'),
                        labelStyle: TextStyle(color: Colors.green),
                        fillColor: Colors.green,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.trim() == '') {
                          return 'Hãy nhập tên loại sản phẩm';
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
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
                            height: Get.width * 0.3,
                            width: Get.width * 0.4,
                            decoration: BoxDecoration(
                              image: filePath.value != ''
                                  ? DecorationImage(
                                      image: FileImage(File(filePath.value)),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: NetworkImage(category.image),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
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
                                          typeSource.value = 'gallery';
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
                              preferredCameraDevice: CameraDevice.front,
                            );
                          } else if (typeSource.value == 'gallery') {
                            pickedFile = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                          } else {
                            return;
                          }
                          if (pickedFile != null) {
                            filePath.value = pickedFile.path.toString();
                          }
                        },
                      ),
                    ],
                  ),
                  filePath.value == ''
                      ? const SizedBox()
                      : Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              filePath.value = '';
                            },
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.green),
                            ),
                            child: const Text(
                              'Xóa ảnh',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          actions: [
            Column(
              children: [
                const Divider(),
                InkWell(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      CategoryController categoryController =
                          Get.find<CategoryController>();
                      category.name = nameController.value.text;
                      if (filePath.value != '') {
                        category.image = (await CloudinaryController()
                            .uploadImage(
                                filePath.value, category.id, 'category'))!;
                      }
                      Get.back();
                      await categoryController.updateCategory(category);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green),
                    child: const Text(
                      'Cập nhật',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void widgetCreateCategory(BuildContext context) {
    Rx<TextEditingController> nameController = TextEditingController().obs;

    RxString filePath = ''.obs;
    final picker = ImagePicker();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Obx(
        () => AlertDialog(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thêm loại sản phẩm',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
              const Divider(),
            ],
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 20,
                    ),
                    width: Get.width * 2 / 3,
                    child: TextFormField(
                      controller: nameController.value,
                      decoration: const InputDecoration(
                        label: Text('Tên loại sản phẩm'),
                        labelStyle: TextStyle(color: Colors.green),
                        fillColor: Colors.green,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.trim() == '') {
                          return 'Hãy nhập tên loại sản phẩm';
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
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
                                          typeSource.value = 'gallery';
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
                              preferredCameraDevice: CameraDevice.front,
                            );
                          } else if (typeSource.value == 'gallery') {
                            pickedFile = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                          } else {
                            return;
                          }
                          if (pickedFile != null) {
                            filePath.value = pickedFile.path.toString();
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
                            height: Get.width / 4,
                            width: Get.width / 2,
                            decoration: BoxDecoration(
                              image: filePath.value == ''
                                  ? const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/upload_file_icon.png'),
                                      // fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: FileImage(
                                        File(filePath.value),
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  filePath.value == ''
                      ? const SizedBox()
                      : Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              filePath.value = '';
                            },
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.green),
                            ),
                            child: const Text(
                              'Xóa ảnh',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          actions: [
            Column(
              children: [
                const Divider(),
                InkWell(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      CategoryController categoryController =
                          Get.find<CategoryController>();
                      Category category = Category(
                          id: '', name: nameController.value.text, image: '');
                      category.image = (await CloudinaryController()
                          .uploadImage(
                              filePath.value,
                              categoryController.categoryCollection.id,
                              'category'))!;
                      Get.back();
                      await categoryController.createCategory(category);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green),
                    child: const Text(
                      'Thêm mới',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
