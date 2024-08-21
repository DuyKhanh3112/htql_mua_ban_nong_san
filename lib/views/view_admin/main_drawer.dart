import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/admin_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/category_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    Get.put(AdminController());
    AdminController adminController = Get.find<AdminController>();
    MainController mainController = Get.find<MainController>();
    RxBool ischange = false.obs;
    RxBool isEdit = false.obs;
    Rx<TextEditingController> nameController = TextEditingController().obs;
    return Obx(() {
      if (mainController.admin.value.id != '') {
        nameController.value.text = mainController.admin.value.name;
      }
      return mainController.isLoading.value || adminController.isLoading.value
          ? const LoadingPage()
          : Container(
              width: Get.width * 2 / 3,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    // color: Colors.white,
                    height: 150,
                    width: Get.width * 2 / 3,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                          // bottomLeft: Radius.circular(40),
                          // bottomRight: Radius.circular(40),
                          ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 10,
                            left: 5,
                            right: 5,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: Get.width / 5,
                                height: 100,
                                // margin: const EdgeInsets.all(10),
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
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      mainController.admin.value.avatar != ''
                                          ? mainController.admin.value.avatar!
                                          : 'https://res.cloudinary.com/dg3p7nxyp/image/upload/v1723018608/account_default.png',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    // color: Colors.amber,
                                    width: Get.width * 0.35,
                                    child: Text(
                                      mainController.admin.value.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          BoxShadow(
                                            color: Colors.grey.shade400,
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    child: Icon(
                                        isEdit.value ? null : Icons.edit,
                                        color: Colors.white,
                                        shadows: [
                                          BoxShadow(
                                            color: Colors.grey.shade400,
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ]),
                                    onTap: () async {
                                      isEdit.value = true;
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  isEdit.value
                      ? Container(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 10,
                          ),
                          child: TextFormField(
                            controller: nameController.value,
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                            ),
                            onChanged: (value) {
                              ischange.value = true;
                            },
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: '',
                              hintStyle: const TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                              ),
                              errorStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  // hidePass.value = !hidePass.value;
                                  if (ischange.value) {
                                    mainController.admin.value.name =
                                        nameController.value.text;
                                    await adminController.updateAdmin(
                                        mainController.admin.value);
                                    ischange.value = false;
                                    isEdit.value = false;
                                  }
                                },
                                icon: ischange.value
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : const Icon(null),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Không được bỏ trống';
                              }
                              return null;
                            },
                          ),
                        )
                      : const SizedBox(),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Image.asset(
                            'assets/images/personal_info_icon.png',
                            width: 40,
                          ),
                          title: const Text(
                            'Thông tin cá nhân',
                            style: TextStyle(color: Colors.green, fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/images/category_icon.png',
                            width: 40,
                          ),
                          title: const Text(
                            'Loại sản phẩm',
                            style: TextStyle(color: Colors.green, fontSize: 18),
                          ),
                          onTap: () async {
                            Get.put(CategoryController());
                            CategoryController categoryController =
                                Get.find<CategoryController>();
                            await categoryController.loadCategory();
                            Get.toNamed('/category');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
    });
  }
}
