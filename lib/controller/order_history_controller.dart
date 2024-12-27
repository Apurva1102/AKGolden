import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cafe_orderall_model.dart';
import '../utils/constants.dart';

class OrderHistoryController extends GetxController {
  var orders = <Orders>[].obs;
  var _filteredOrders = <Orders>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedIndex = (-1).obs;
  var selectedDate = Rx<DateTime?>(null);

  var selectIndex = 0.obs;
  final now = DateTime.now();
  late final DateTime firstDayOfMonth;
  late final int totalDaysInMonth;

  var pendingOrders = <Orders>[].obs;
  var totalPendingAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCafeOrders();
    firstDayOfMonth = DateTime(now.year, now.month, 1);
    totalDaysInMonth = DateTime(now.year, now.month + 1, 0).day;
  }

  // Fetching the cafe orders
  Future<void> fetchCafeOrders() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? savedCafeIdString = prefs.getString('cafe_id');
      print('Cafe Id from fetchCafeOrders: $savedCafeIdString');

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}GetAllCafeOrders'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final cafeOrders = CafeOrdersModel.fromJson(jsonResponse);
        print("response.body: ${response.body}");

        if (cafeOrders.orders != null && cafeOrders.orders!.isNotEmpty) {
          // Filter orders using the savedCafeIdString variable
          orders.value = cafeOrders.orders!
              .where((order) => order.cafeId == int.parse(savedCafeIdString!))
              .toList();

          // Sort orders in descending order based on orderDate
          orders.sort((a, b) {
            final dateA = a.orderDate != null ? DateTime.parse(a.orderDate!) : DateTime.fromMillisecondsSinceEpoch(0);
            final dateB = b.orderDate != null ? DateTime.parse(b.orderDate!) : DateTime.fromMillisecondsSinceEpoch(0);
            return dateB.compareTo(dateA); // Descending order
          });

          // Filter orders based on the selected date
          filterOrdersByDate();
          updateTotalPendingAmount(); // Call here after fetching and filtering

        } else {
          errorMessage.value = "No orders found in the API response.";
        }
      } else {
        errorMessage.value = "Failed to fetch data. Status code: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading(false);
    }
  }

  // Method to update the selected index and filter orders by date
  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
    selectedDate.value = firstDayOfMonth.add(Duration(days: index));
    filterOrdersByDate();
  }

  // Filter orders by selected date
  void filterOrdersByDate() {
    if (selectedIndex.value < 0) {
      // If no valid date is selected, show all orders
      _filteredOrders.value = orders;
      updateTotalPendingAmount(); // Call here after filtering

      return;
    }

    // Calculate the selected date based on the index
    DateTime selectedDate = firstDayOfMonth.add(Duration(days: selectedIndex.value));

    // Filter orders by comparing the order date with the selected date
    _filteredOrders.value = orders.where((order) {
      if (order.orderDate == null || order.orderDate!.isEmpty) {
        return false; // Skip orders with null or empty dates
      }

      try {
        DateTime orderDate = DateTime.parse(order.orderDate!);
        return orderDate.year == selectedDate.year &&
            orderDate.month == selectedDate.month &&
            orderDate.day == selectedDate.day;
      } catch (e) {
        return false; // Skip invalid dates
      }
    }).toList();

    // Sort the filtered orders in descending order based on orderDate
    _filteredOrders.sort((a, b) {
      final dateA = a.orderDate != null ? DateTime.parse(a.orderDate!) : DateTime.fromMillisecondsSinceEpoch(0);
      final dateB = b.orderDate != null ? DateTime.parse(b.orderDate!) : DateTime.fromMillisecondsSinceEpoch(0);
      return dateB.compareTo(dateA); // Descending order
    });
  }



  void resetFilter() {
    filteredOrders.assignAll(orders); // Reset to original list
  }

  // Reset the date filter and show all orders
  void resetDateFilter() {
    selectedIndex.value = -1; // Reset the selected date index
    _filteredOrders.value = orders; // Show all orders
  }

  // Method to filter orders based on the search query (order number)
  void filterOrdersBySearch(String query) {
    if (query.isEmpty) {
      _filteredOrders.value = orders;
    } else {
      _filteredOrders.value = orders.where((order) {
        return order.orderNumber?.toLowerCase().contains(query.toLowerCase()) ??
            false;
      }).toList();
    }

    _filteredOrders.sort((a, b) {
      final dateA = a.orderDate != null
          ? DateTime.parse(a.orderDate!)
          : DateTime.fromMillisecondsSinceEpoch(0);
      final dateB = b.orderDate != null
          ? DateTime.parse(b.orderDate!)
          : DateTime.fromMillisecondsSinceEpoch(0);
      return dateB.compareTo(dateA); // Descending order
    });
    updateTotalPendingAmount(); // Call here after filtering

  }
  // Get the filtered orders for display
  List<Orders> get filteredOrders => _filteredOrders.toList();


  void updateTotalPendingAmount() {
    totalPendingAmount.value = orders.where((order) => order.paymentStatus == 0).map((order) => order.totalAmount).fold(0.0, (a, b) => a + b!);
  }

  void addOrder(Orders newOrder) {
    orders.add(newOrder);
    updateTotalPendingAmount();
    update(); // or refresh() to trigger UI update
  }

}
