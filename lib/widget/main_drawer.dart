import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    MainController mainController = Get.find<MainController>();
    return Obx(() {
      return mainController.isLoading.value
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
                    decoration: BoxDecoration(
                      color: Colors.green.shade300,
                      borderRadius: const BorderRadius.only(
                          // bottomLeft: Radius.circular(40),
                          // bottomRight: Radius.circular(40),
                          ),
                      image: mainController.admin.value.cover != ''
                          ? const DecorationImage(
                              image: NetworkImage(
                                  'https://res.cloudinary.com/dg3p7nxyp/image/upload/v1723018608/account_default.png'),
                            )
                          : null,
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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: Get.width / 5,
                                height: Get.height / 10,
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
                                  // color: Colors.amber,
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      'https://res.cloudinary.com/dg3p7nxyp/image/upload/v1723018608/account_default.png',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                // color: Colors.amber,
                                width: Get.width * 0.3,

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
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                child: Icon(Icons.edit,
                                    color: Colors.white,
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.grey.shade400,
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ]),
                                onTap: () async {},
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
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
                      ],
                    ),
                  ),
                ],
              ),
            );
    });
  }
}
