import 'package:d_chart/d_chart.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/report_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/drawer_seller.dart';
import 'package:intl/intl.dart';

class ReportSellSellerPage extends StatelessWidget {
  const ReportSellSellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    ReportController reportController = Get.find<ReportController>();
    RxInt i = 0.obs;
    return Obx(() {
      return reportController.isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Thống kê bán hàng',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                body: ListView(
                  padding: EdgeInsets.all(Get.width * 0.01),
                  children: [
                    Container(
                      padding: EdgeInsets.all(Get.width * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              final DateTimeRange? picked =
                                  await showDateRangePicker(
                                context: context,
                                firstDate:
                                    DateTime(DateTime.now().year - 100, 1, 1),
                                lastDate:
                                    DateTime(DateTime.now().year + 100, 1, 1),
                                initialDateRange: reportController
                                    .selectedDateRangeOrder.value,
                                builder: (context, child) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: Get.height * 0.75,
                                        width: Get.width * 0.9,
                                        child: Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                                primary: Colors
                                                    .green, // Màu của tiêu đề
                                                onPrimary: Colors
                                                    .white, // Màu của văn bản tiêu đề
                                                onSurface: Colors
                                                    .green, // Màu của các ngày trong lịch
                                                surface: Colors.white,
                                              ),
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors
                                                      .blue, // Màu nút "Save"
                                                ),
                                              ),
                                            ),
                                            child: child!),
                                      )
                                    ],
                                  );
                                },
                              );
                              if (picked != null) {
                                reportController.selectedDateRangeOrder.value =
                                    picked;
                              }
                            },
                            child: Container(
                              width: Get.width * 0.6,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                // color: Colors.white,
                                border: Border.all(
                                  color: Colors.green,
                                ),
                              ),
                              padding: EdgeInsets.all(Get.width * 0.02),
                              child: Text(
                                "${DateFormat('dd/MM/yyyy').format(reportController.selectedDateRangeOrder.value.start)} - ${DateFormat('dd/MM/yyyy').format(reportController.selectedDateRangeOrder.value.end)}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.3,
                            child: ElevatedButton(
                              onPressed: () async {
                                await reportController.showReportOrder();
                              },
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  Colors.green,
                                ),
                              ),
                              child: const Text(
                                'Báo cáo',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    reportController.reportOrderStatus.isEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: Get.width * 0.8,
                                // padding: EdgeInsets.all(Get.width * 0.02),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Không có dữ liệu',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.green,
                                  ),
                                ),
                              )
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(Get.width * 0.05),
                                margin: EdgeInsets.all(Get.width * 0.02),
                                decoration: const BoxDecoration(
                                  // border: Border.all(),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Colors.white,
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
                                    const Text(
                                      'Tỉ lệ đơn hàng theo trạng thái',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    AspectRatio(
                                      aspectRatio: 1.5,
                                      child: DChartPieO(
                                        data:
                                            reportController.reportOrderStatus,
                                        animate: true,
                                        customLabel: (ordinalData, index) {
                                          return NumberFormat
                                                  .decimalPercentPattern(
                                                      decimalDigits: 2)
                                              .format(
                                                  ordinalData.other['rate']);
                                        },
                                        configRenderPie: ConfigRenderPie(
                                          arcLabelDecorator: ArcLabelDecorator(
                                            insideLabelStyle: const LabelStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                            outsideLabelStyle: const LabelStyle(
                                              color: Colors.green,
                                              fontSize: 12,
                                            ),
                                            showLeaderLines: true,
                                            leaderLineStyle:
                                                const ArcLabelLeaderLineStyle(
                                              color: Colors.black,
                                              length: 20,
                                              thickness: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: Get.width * 0.8,
                                      height: Get.width * 0.2,
                                      alignment: Alignment.center,
                                      child: FlexibleGridView(
                                        axisCount:
                                            GridLayoutEnum.twoElementsInRow,
                                        children: Get.find<OrderController>()
                                            .listStatus
                                            .map(
                                          (item) {
                                            i++;
                                            return Row(
                                              children: [
                                                i % 2 == 0
                                                    ? const SizedBox()
                                                    : Container(
                                                        width: Get.width * 0.05,
                                                        height:
                                                            Get.width * 0.05,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: item['color'],
                                                        ),
                                                      ),
                                                Container(
                                                  width: Get.width * 0.3,
                                                  padding: EdgeInsets.only(
                                                    left: Get.width * 0.02,
                                                    right: Get.width * 0.02,
                                                  ),
                                                  alignment: i % 2 == 0
                                                      ? Alignment.centerRight
                                                      : Alignment.centerLeft,
                                                  child: Text(
                                                    item['label'],
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      // fontStyle: FontStyle.italic,
                                                    ),
                                                  ),
                                                ),
                                                i % 2 != 0
                                                    ? const SizedBox()
                                                    : Container(
                                                        width: Get.width * 0.05,
                                                        height:
                                                            Get.width * 0.05,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: item['color'],
                                                        ),
                                                      ),
                                              ],
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(Get.width * 0.05),
                                margin: EdgeInsets.all(Get.width * 0.02),
                                decoration: const BoxDecoration(
                                  // border: Border.all(),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Colors.white,
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
                                    const Text(
                                      'Số lượng đơn hàng theo trạng thái',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: DChartBarCustom(
                                        valueAlign: Alignment.topCenter,
                                        showDomainLine: true,
                                        showDomainLabel: true,
                                        showMeasureLine: true,
                                        showMeasureLabel: true,
                                        spaceDomainLabeltoChart: 10,
                                        spaceMeasureLabeltoChart: 10,

                                        // spaceDomainLinetoChart: 15,
                                        spaceMeasureLinetoChart:
                                            Get.width * 0.02,
                                        spaceBetweenItem: 10,
                                        radiusBar: const BorderRadius.only(
                                          bottomRight: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        measureLabelStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.green,
                                        ),
                                        domainLabelStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.green,
                                          overflow: TextOverflow.clip,
                                        ),
                                        measureLineStyle: const BorderSide(
                                            color: Colors.green, width: 2),
                                        domainLineStyle: const BorderSide(
                                            color: Colors.green, width: 2),
                                        // max: 25,
                                        verticalDirection: true,
                                        listData: reportController
                                            .reportOrderStatus
                                            .map(
                                              (item) => DChartBarDataCustom(
                                                value: item.measure.toDouble(),
                                                label: item.domain,
                                                showValue: true,
                                                valueTooltip:
                                                    '${item.measure} đơn hàng',
                                                color:
                                                    item.color!.withOpacity(1),
                                                valueStyle: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.05,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
                drawer: const DrawerSeller(),
              ),
            );
    });
  }
}
