import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cafe_orderall_model.dart';
import '../utils/constants.dart';

class RepeatOrderController extends GetxController {
  var orders = <Orders>[].obs;
  var filteredOrders = <Orders>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedIndex = (-1).obs;
  var selectedDate = Rx<DateTime?>(null);


  var selectIndex = 0.obs;
  final now = DateTime.now();
  late final DateTime firstDayOfMonth;
  late final int totalDaysInMonth;



  @override
  void onInit() {
    super.onInit();
    fetchCafeOrders();
    firstDayOfMonth = DateTime(now.year, now.month, 1);
    totalDaysInMonth = DateTime(now.year, now.month + 1, 0).day;
  }

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
    selectedDate.value = firstDayOfMonth.add(Duration(days: index));
    filterOrdersByDate();
  }


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
print(Uri.base);
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
        } else {
          errorMessage.value = "No orders found in the API response.";
        }
      } else {
        errorMessage.value =
        "Failed to fetch data. Status code: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading(false);
    }
  }

  void filterOrdersByDate() {
    if (selectedIndex.value < 0) {
      // If no valid date is selected, show all orders
      filteredOrders.value = orders;
      return;
    }

    // Calculate the selected date based on the index
    DateTime selectedDate =
    firstDayOfMonth.add(Duration(days: selectedIndex.value));

    // Filter orders by comparing the order date with the selected date
    filteredOrders.value = orders.where((order) {
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
    filteredOrders.sort((a, b) {
      final dateA = a.orderDate != null ? DateTime.parse(a.orderDate!) : DateTime.fromMillisecondsSinceEpoch(0);
      final dateB = b.orderDate != null ? DateTime.parse(b.orderDate!) : DateTime.fromMillisecondsSinceEpoch(0);
      return dateB.compareTo(dateA); // Descending order
    });

  }
  void resetDateFilter() {
    selectedIndex.value = -1; // Reset the selected date index
    filteredOrders.value = orders; // Show all orders
  }
}
