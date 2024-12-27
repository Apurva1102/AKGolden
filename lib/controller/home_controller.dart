import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cafe_orderall_model.dart';
import '../utils/constants.dart';


class HomeController extends GetxController {
  var orders = <Orders>[].obs;
  var filteredOrders = <Orders>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedIndex = (-1).obs;
  var selectedDate = Rx<DateTime?>(null);
  var startDate = Rx<DateTime?>(null);
  var endDate = Rx<DateTime?>(null);

  late TextEditingController startDateController;
  late TextEditingController endDateController;

  var now = DateTime.now();
  late final DateTime firstDayOfMonth;
  late final int totalDaysInMonth;
  late final DateTime firstDayOfDisplayRange;
  late final DateTime lastDayOfDisplayRange;

  @override
  void onInit() {
    super.onInit();
    fetchCafeOrders();
    firstDayOfMonth = DateTime(now.year, now.month, 1);
    totalDaysInMonth = DateTime(now.year, now.month + 1, 0).day;
    firstDayOfDisplayRange = now.subtract(const Duration(days: 10));
    lastDayOfDisplayRange = now.add(const Duration(days: 8));
    startDateController = TextEditingController();
    endDateController = TextEditingController();
  }

  @override
  void onClose() {
    startDateController.dispose();
    endDateController.dispose();
    super.onClose();
  }

  DateTime? parseDate(String? date) {
    if (date == null || date.isEmpty) return null;
    try {
      return DateTime.parse(date);
    } catch (_) {
      return null;
    }
  }

  void selectDateRange(DateTimeRange? picked) {
    if (picked != null) {
      startDate.value = picked.start;
      endDate.value = picked.end;
      filterOrdersByDateRange();
    }
  }

  void filterOrdersByDateRange() {
    if (startDate.value == null || endDate.value == null) {
      filteredOrders.value = orders;
      return;
    }

    filteredOrders.value = orders.where((order) {
      final orderDate = parseDate(order.orderDate);
      return orderDate != null &&
          orderDate.isAfter(startDate.value!) &&
          orderDate.isBefore(endDate.value!);
    }).toList();
  }

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
    selectedDate.value = firstDayOfDisplayRange.add(Duration(days: index));
    filterOrdersByDate();
  }

  Future<void> fetchCafeOrders() async {
    try {
      isLoading(true);

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final cafeIdString = prefs.getString('cafe_id');

      if (token == null || cafeIdString == null) {
        errorMessage.value = "Authentication data is missing.";
        return;
      }

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}GetAllCafeOrders'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final cafeOrders = CafeOrdersModel.fromJson(jsonResponse);

        if (cafeOrders.orders?.isNotEmpty ?? false) {
          final cafeId = int.tryParse(cafeIdString);
          orders.value = cafeOrders.orders!
              .where((order) => order.cafeId == cafeId)
              .toList();

          orders.sort((a, b) {
            final dateA = parseDate(a.orderDate) ??
                DateTime.fromMillisecondsSinceEpoch(0);
            final dateB = parseDate(b.orderDate) ??
                DateTime.fromMillisecondsSinceEpoch(0);
            return dateB.compareTo(dateA);
          });

          filterOrdersByDate();
        } else {
          errorMessage.value = "No orders found.";
        }
      } else {
        errorMessage.value =
        "Failed to fetch data (Status: ${response.statusCode}).";
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading(false);
    }
  }

  void filterOrdersByDate() {
    if (selectedIndex.value < 0) {
      filteredOrders.value = orders;
      return;
    }

    final selectedDate =
    firstDayOfDisplayRange.add(Duration(days: selectedIndex.value));

    filteredOrders.value = orders.where((order) {
      final orderDate = parseDate(order.orderDate);
      return orderDate != null &&
          orderDate.year == selectedDate.year &&
          orderDate.month == selectedDate.month &&
          orderDate.day == selectedDate.day;
    }).toList();

    filteredOrders.sort((a, b) {
      final dateA = parseDate(a.orderDate) ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final dateB = parseDate(b.orderDate) ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return dateB.compareTo(dateA);
    });
  }

  void clearDates() {
    startDateController.clear();
    endDateController.clear();
    startDate.value = null;
    endDate.value = null;
    filteredOrders.value = orders;
  }

  void resetDateFilter() {
    selectedIndex.value = -1;
    filteredOrders.value = orders;
  }
}