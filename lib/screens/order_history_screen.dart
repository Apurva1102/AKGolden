import 'package:ak_golden_project/controller/order_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../controller/date_controller.dart';
import '../model/cafe_orderall_model.dart';

class OrderHistoryScreen extends StatelessWidget {
  final DateController dateController = Get.put(DateController());
  final OrderHistoryController orderHistoryController =
      Get.put(OrderHistoryController());
  final TextEditingController searchController = TextEditingController();

  OrderHistoryScreen({super.key});

  void _filterOrders(String query) {
    orderHistoryController.filterOrdersBySearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 72,
        backgroundColor: const Color(0xff7B3F00),
        title: Text(
          "Order History",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w400,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.brown),
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
                                    backgroundColor: const Color(0xff7B3F00),
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
        leading: IconButton(
            onPressed: () {
              Get.find<PersistentTabController>().jumpToTab(0);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Obx(() => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Total Pending Amount: ₹ ${orderHistoryController.totalPendingAmount.value}/-",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                )),

            SizedBox(height: 3.h),
            _buildSearchBar(context),
            SizedBox(height: 2.h),
            const Divider(
              height: 2,
              color: Color(0xffF2ECE6),
              thickness: 2,
            ),
            SizedBox(height: 2.h),

            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Container(
                      width: 35.w,
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
                                ? 'Order Date'
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
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                                    selectableDayPredicate: (DateTime date) {
                                      return true ;
                                    },
                                  );

                                  if (pickedDate != null) {
                                    String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                    dateController.setDate(formattedDate);

                                    int newIndex = pickedDate
                                        .difference(orderHistoryController.firstDayOfMonth)
                                        .inDays;
                                    orderHistoryController.updateSelectedIndex(newIndex);
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
                                    orderHistoryController.updateSelectedIndex(-1);
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
                  ),
                ],
              );
            }),

            SizedBox(height: 2.h),

            _buildOrderList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                if (value.isEmpty) {
                  // Reset to show all orders when the search box is cleared
                  orderHistoryController
                      .resetFilter(); // Call to reset filter logic
                } else {
                  _filterOrders(value); // Apply search filter
                }
              },
              onSubmitted: (_) {
                // Dismiss the keyboard when the 'Done' key is pressed
                FocusScope.of(context).requestFocus(FocusNode());
              },
              decoration: InputDecoration(
                hintText: "Search by Order Number",
                hintStyle: GoogleFonts.lato(
                    color: Colors.grey, fontWeight: FontWeight.w400),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // Reset the search field and filters when back button is pressed
              searchController.clear();
              orderHistoryController.resetFilter(); // Reset all filters
            },
            child: const Icon(Icons.close, color: Colors.grey, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() {
        if (orderHistoryController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (orderHistoryController.errorMessage.isNotEmpty) {
          return Center(child: Text(orderHistoryController.errorMessage.value));
        }

        // Check filtered orders and fallback to all orders if no filter is applied
        final ordersToDisplay = orderHistoryController.filteredOrders.isNotEmpty
            ? orderHistoryController.filteredOrders
            : orderHistoryController.orders;

        if (ordersToDisplay.isEmpty) {
          return const Center(child: Text("No orders found"));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ordersToDisplay.length,
          itemBuilder: (context, index) {
            final order = ordersToDisplay[index];
            final isSelected =
                orderHistoryController.selectedIndex.value == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GestureDetector(
                onTap: () {
                  // Toggle the selected index on tap
                  orderHistoryController.selectedIndex.value =
                      orderHistoryController.selectedIndex.value == index
                          ? -1
                          : index;
                  _showOrderDetailsPopup(context, order);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xffF2ECE6) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Order Number Container
                      Container(
                        width: 90,
                        height: 70,
                        padding: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          color: isSelected
                              ? Colors.white
                              : const Color(0xffF2ECE6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Order No.",
                              style:
                                  GoogleFonts.lato(fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order.orderNumber ?? 'N/A',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Order Date and Amount
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date: ${order.orderDate != null ? DateFormat('dd-MMM-yyyy').format(DateTime.parse(order.orderDate!)) : 'N/A'}",
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "₹ ${order.totalAmount}/-",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      // Payment Status
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            order.paymentStatus == 0 ? "Unpaid" : "Paid",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: order.paymentStatus == 0
                                  ? Colors.red
                                  : Colors.green,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
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
