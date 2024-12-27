import 'package:ak_golden_project/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../controller/date_controller.dart';
import '../model/cafe_orderall_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController _controller = Get.put(HomeController());
  final DateController dateController = Get.put(DateController());

  DateTime? currentBackPressTime;


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 72,
            backgroundColor: const Color(0xff7B3F00),
            title: Padding(
              padding: const EdgeInsets.only(left: 6.0, right: 12.0),
              child: Container(
                height: 35,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 10),
                    //   child: Image.asset(
                    //     'assets/images/pic1.png',
                    //     height: 24,
                    //     width: 24,
                    //   ),
                    // ),
                    Text(
                      "  Wednesday is holiday",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500, fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 45),
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // SystemNavigator.pop();
                      // Get.toNamed('/profile_screen');
                      // Get.find<PersistentTabController>().jumpToTab(4);
                      Get.bottomSheet(
                        Container(
                          height: 250,
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Logout",
                                style: GoogleFonts.alatsi(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Text(
                                "Are you sure you want to logout?",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Dismiss the bottom sheet
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                            color: Colors.brown),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero)),
                                    child: Text(
                                      "Cancel",
                                      style: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.clear();
                                      // await clearSharedPreferences();
                                      // Get.off(() => LoginScreen());
                                      Get.offAllNamed(
                                        '/login',
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff7B3F00),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero)),
                                    child: Text(
                                      "Yes, Logout",
                                      style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        isDismissible: true,
                      );
                    },
                    icon: const Icon(Icons.person, color: Colors.brown),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 3.h),
                Center(
                  child: Obx(() {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _controller.lastDayOfDisplayRange
                              .difference(_controller.firstDayOfDisplayRange)
                              .inDays +
                              1,
                              (index) {
                            final currentDate =
                            _controller.firstDayOfDisplayRange.add(Duration(days: index));
                            final dayName = DateFormat('E').format(currentDate);
                            final isSelected = _controller.selectedIndex.value == index;

                            return GestureDetector(
                              onTap: () {
                                // Check if the same index is tapped again
                                if (isSelected) {
                                  _controller.updateSelectedIndex(-1); // Unselect
                                } else {
                                  _controller.updateSelectedIndex(index); // Select new
                                }
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    dayName.substring(0, 1),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: dayName.isNotEmpty
                                          ? const Color(0xff7B3F00)
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xff7B3F00)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xff7B3F00)
                                            : Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      (currentDate.day).toString().padLeft(2, '0'),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: isSelected ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),

                ),
                SizedBox(height: 2.h),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    "     Track Delivery",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 2.h),
                ]),

          //      Date Range Selection TextFields
          //       Padding(
          //         padding: const EdgeInsets.all(16.0),
          //         child: Row(
          //           children: [
          //             Expanded(
          //               child: TextField(
          //                 controller: _controller.startDateController,
          //                 readOnly: true,
          //                 onTap: () async {
          //                   final DateTime? picked = await showDatePicker(
          //                     context: context,
          //                     initialDate:
          //                         _controller.startDate.value ?? DateTime.now(),
          //                     firstDate: DateTime(2000),
          //                     lastDate: DateTime(2101),
          //                   );
          //                   if (picked != null) {
          //                     _controller.startDate.value = picked;
          //                     _controller.startDateController.text =
          //                         DateFormat('yyyy-MM-dd').format(picked);
          //                     _controller.filterOrdersByDateRange();
          //                   }
          //                 },
          //                 decoration: const InputDecoration(
          //                   hintText: 'Start Date',
          //                   border: OutlineInputBorder(
          //                       borderSide: const BorderSide(color: Colors.brown)
          //                 ),
          //                   focusedBorder: OutlineInputBorder(
          //                     borderSide:  BorderSide(color: Colors.brown),
          //                   ),
          //
          //                 ),
          //               ),
          //             ),
          //             const SizedBox(width: 16),
          //             Expanded(
          //               child: TextField(
          //                 controller: _controller.endDateController,
          //                 readOnly: true,
          //                 onTap: () async {
          //                   final DateTime? picked = await showDatePicker(
          //                     context: context,
          //                     initialDate:
          //                         _controller.endDate.value ?? DateTime.now(),
          //                     firstDate: DateTime(2000),
          //                     lastDate: DateTime(2101),
          //                   );
          //                   if (picked != null) {
          //                     _controller.endDate.value = picked;
          //                     _controller.endDateController.text =
          //                         DateFormat('yyyy-MM-dd').format(picked);
          //                     _controller.filterOrdersByDateRange();
          //                   }
          //                 },
          //                 decoration: const InputDecoration(
          //                   hintText: 'End Date',
          //                   // labelText: "End Date",
          //                   border: OutlineInputBorder(
          //                       borderSide: const BorderSide(color: Colors.brown)
          //                   ),
          //                   focusedBorder: OutlineInputBorder( // Customize focused border
          //                     borderSide:  BorderSide(color: Colors.brown),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             IconButton(
          //               icon: const Icon(Icons.clear),
          //               onPressed: () {
          //                 _controller.startDate.value = null;
          //                 _controller.endDate.value = null;
          //                 _controller.startDateController.clear();
          //                 _controller.endDateController.clear();
          //                 _controller.filterOrdersByDateRange();
          //               },
          //             ),
          //           ],
          //         ),
          //       ),

                SizedBox(height: 2.h),
                Container(
                  width: 322,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xff7B3F00),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.brown,
                    unselectedLabelColor: Colors.white,
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    indicatorPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    tabs: const [
                      Tab(
                        text: "Completed",
                      ),
                      Tab(
                        text: "Pending",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                // Order Cards
                SizedBox(
                  height: 70.h,
                  child: TabBarView(
                    children: [
                      Obx(() {
                        if (_controller.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (_controller.errorMessage.isNotEmpty) {
                          return Center(
                              child: Text(_controller.errorMessage.value));
                        }
                        if (_controller.orders.isEmpty) {
                          return const Center(child: Text("No orders found"));
                        }
                        _controller.orders
                            .where((order) => order.deliveryStatus == 1)
                            .toList();

                        return ListView.builder(
                          // itemCount: completedOrders.length,
                          itemCount: _controller.filteredOrders
                              .where((order) => order.deliveryStatus == 1)
                              .length,
                          itemBuilder: (context, index) {
                            // final order = completedOrders[index];
                            final order = _controller.filteredOrders
                                .where((order) => order.deliveryStatus == 1)
                                .toList()[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  _showOrderDetailsPopup(context, order);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 5,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 90,
                                            height: 65,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              color: Color(0xffF2ECE6),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Order No.",
                                                    style: GoogleFonts.lato(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(
                                                    "${order.orderNumber}",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.brown,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 2.w),
                                      Column(
                                        children: [
                                          Text(
                                            "Date:  ${order.orderDate != null ? DateFormat('dd-MMMM-yyyy').format(DateTime.parse(order.orderDate!)) : 'N/A'}",
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.w400),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "₹ ${order.totalAmount}/-",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xffB60808),
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 3.w),
                                      IconButton(
                                          onPressed: () {
                                            _showOrderDetailsPopup(
                                                context, order);
                                          },
                                          icon: const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.grey,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),

                      Obx(() {
                        if (_controller.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (_controller.errorMessage.isNotEmpty) {
                          return Center(
                              child: Text(_controller.errorMessage.value));
                        }
                        if (_controller.orders.isEmpty) {
                          return const Center(child: Text("No orders found"));
                        }

                        _controller.orders
                            .where((order) => order.deliveryStatus == 0)
                            .toList();

                        return ListView.builder(
                          itemCount: _controller.filteredOrders
                              .where((order) => order.deliveryStatus == 0)
                              .length,
                          itemBuilder: (context, index) {
                            final order = _controller.filteredOrders
                                .where((order) => order.deliveryStatus == 0)
                                .toList()[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 90,
                                          height: 65,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            color: Color(0xffF2ECE6),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Order No.",
                                                  style: GoogleFonts.lato(
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Text(
                                                  "${order.orderNumber}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.brown,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 2.w),
                                    Column(
                                      children: [
                                        Text(
                                          "Date: ${order.orderDate != null ? DateFormat('dd-MMMM-yyyy').format(DateTime.parse(order.orderDate!)) : 'N/A'}",
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "₹ ${order.totalAmount}/-",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffB60808),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 3.w),
                                    IconButton(
                                        onPressed: () {
                                          _showOrderDetailsPopup(
                                              context, order);
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.grey,
                                        )),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
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
}
