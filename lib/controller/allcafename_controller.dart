import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/allcafename_model.dart';
import '../utils/constants.dart';

class CafeController extends GetxController {
  var cafes = <AllCafeNameModel>[].obs;
  var cafeNames = <String>[].obs;
  var isLoading = true.obs;
  var selectedCafeId = Rx<int?>(null);
  RxString cafeAddress = ''.obs;
  RxString username = ''.obs;
  RxString email = ''.obs;
  RxString cellNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSelectedCafeId().then((_) => fetchCafes());
  }

  Future<void> fetchCafes({int? cafeId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? cafeIdFromPrefs = prefs.getString('cafe_id');

    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}GetAllCafeUsers'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)[0];
        cafes.value = data.map((item) => AllCafeNameModel.fromJson(item)).toList();

        // Filter cafes based on provided cafeId or saved cafe ID
        final targetCafeId = cafeId ?? int.tryParse(cafeIdFromPrefs ?? '') ?? 0;

        // Update cafeNames with the selected cafe's name
        final selectedCafe = cafes.firstWhereOrNull((cafe) => cafe.cafeId == targetCafeId);
        if (selectedCafe != null) {
          cafeNames.value = [selectedCafe.cafeName ?? 'Unnamed Cafe'];

          // Store the username, cell number, and email in variables
          String userName = selectedCafe.username ?? '';
          String cellNumber = selectedCafe.cellNumber ?? '';
          String email = selectedCafe.email ?? '';

          // Log the saved variables (optional)
          print('Cafe name : ${cafeNames}');
          print('Username: $userName');
          print('Cell Number: $cellNumber');
          print('Email: $email');

          // Save them to SharedPreferences
          await prefs.setString('username', userName);
          await prefs.setString('cell_number', cellNumber);
          await prefs.setString('email', email);
        } else {
          cafeNames.clear(); // Clear if no matching cafe is found
        }

        // Update other observable variables with cafe details
        cafeAddress.value = selectedCafe?.address ?? '';
        username.value = selectedCafe?.username ?? '';
        email.value = selectedCafe?.email ?? '';
        cellNumber.value = selectedCafe?.cellNumber ?? '';
        print('Cafe address: $cafeAddress');
        print('Cell Number: $cellNumber');
      } else {
        throw Exception('Failed to load cafes');
      }
    } catch (e) {
      print('Error fetching cafes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadSelectedCafeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCafeIdString = prefs.getString('cafe_id');
    selectedCafeId.value = savedCafeIdString != null ? int.tryParse(savedCafeIdString) : null;
  }
}