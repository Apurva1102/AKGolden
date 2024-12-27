import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../controller/date_controller.dart';
import '../controller/orderchekout_controller.dart';
import '../controller/repeat_order_controller.dart';
import '../model/cafe_orderall_model.dart';

class RepeatOrder extends StatelessWidget {
  final RepeatOrderController controller = Get.put(RepeatOrderController());
  final DateController dateController = Get.put(DateController());
  final OrderCheckoutController orderCheckoutController = Get.put(OrderCheckoutController()); // Initialize here

  RepeatOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 4.w, right: 4.w),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3.h),
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 34.w,
                        height: 5.h,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dateController.selectedDate.value.isEmpty
                                  ? 'Date'
                                  : dateController.selectedDate.value,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),

                                    );

                                    if (pickedDate != null) {
                                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                      dateController.setDate(formattedDate);

                                      // Calculate the new selectedIndex based on the pickedDate
                                      int newIndex = pickedDate.difference(controller.firstDayOfMonth).inDays;
                                      controller.updateSelectedIndex(newIndex);
                                    }
                                  },
                                  child: const Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                ),
                                if (dateController.selectedDate.value.isNotEmpty)
                                  InkWell(
                                    onTap: () {
                                      dateController.setDate('');
                                      controller.updateSelectedIndex(-1);
                                    },
                                    child: const Icon(
                                      Icons.clear,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                SizedBox(height: 2.h),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.errorMessage.isNotEmpty) {
                    return Center(child: Text(controller.errorMessage.value));
                  }

                  if (controller.filteredOrders.isEmpty) {
                    return const Center(child: Text("No orders found"));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = controller.filteredOrders[index];

                      return GestureDetector(
                        onTap: () {
                          controller.selectedIndex.value =
                          controller.selectedIndex.value == index ? -1 : index;
                          _showOrderDetailsPopup(context, order);
                        },
                        child: Obx(() {
                          final isSelected = controller.selectedIndex.value == index;

                          return Card(
                            color: isSelected ? const Color(0xFFF7E7DB) : Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8.0)), //
                                        child: Text(
                                          "Order No.\n${order.orderNumber ?? 'N/A'}",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.brown,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Date: ${order.orderDate != null ? DateFormat('dd-MMM-yyyy').format(DateTime.parse(order.orderDate!)) : 'N/A'}",
                                        style: GoogleFonts.lato(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      orderCheckoutController.repeatOrder(order);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isSelected
                                          ? const Color(0xff7B3F00)
                                          : Colors.white,
                                      foregroundColor: isSelected
                                          ? Colors.white
                                          : const Color(0xff7B3F00),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: const BorderSide(color: Colors.brown),
                                      ),
                                    ),
                                    child: Text(
                                      'Repeat',
                                      style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOrderDetailsPopup(BuildContext context, Orders order) {
    // Calculate total quantities and total amount
    final int totalProducts = order.products
        ?.fold<int>(0, (sum, product) => sum + (product.quantity ?? 0).toInt()) ??
        0; // Total quantity of all products

    final double totalAmount = order.products?.fold<double>(
        0.0, (sum, product) => sum + (product.subTotalAmount ?? 0.0).toDouble()) ??
        0.0; // Total amount

    showDialog(
      context: context,
      builder: (context) {
        // Local state to track the selected product index
        ValueNotifier<int?> selectedIndex = ValueNotifier<int?>(null);

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titlePadding: EdgeInsets.zero,
          title: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Order Details",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: const Color(0xff7B3F00),
                  ),
                ),
                const Divider(
                  color: Color(0xffD7BB9E),
                  thickness: 1,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  child: ValueListenableBuilder<int?>(
                    valueListenable: selectedIndex,
                    builder: (context, selected, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Per Item products
                          ...order.products!
                              .where((product) => product.priceScale == 'Per Item')
                              .toList()
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key;
                            var product = entry.value;

                            return GestureDetector(
                              onTap: () {
                                selectedIndex.value =
                                (selectedIndex.value == index) ? null : index;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selected == index
                                      ? const Color(0xffF5E1C0)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 8.0),
                                margin: const EdgeInsets.symmetric(vertical: 2.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${product.name} [${product.quantity ?? 0} Piece]",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Price
                                    Text(
                                      "₹ ${product.subTotalAmount}",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: const Color(0xff7B3F00),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                          // Per kg products
                          ...order.products!
                              .where((product) => product.priceScale == 'Per kg')
                              .toList()
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key;
                            var product = entry.value;

                            return GestureDetector(
                              onTap: () {
                                selectedIndex.value =
                                (selectedIndex.value == index) ? null : index;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selected == index
                                      ? const Color(0xffF5E1C0)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 8.0),
                                margin: const EdgeInsets.symmetric(vertical: 2.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${product.name} [${product.quantity ?? 0} KG]",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Price
                                    Text(
                                      "₹ ${product.subTotalAmount}",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: const Color(0xff7B3F00),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Divider(
                              color: Color(0xffD7BB9E),
                              thickness: 1,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Quantity\n$totalProducts",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Total Amount\n₹ $totalAmount/-",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: const Color(0xff7B3F00),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }}
