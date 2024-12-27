import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_pages.dart';
import '../service/api.dart';
import 'allcafename_controller.dart';


class AuthController extends GetxController {
  var isLoading = false.obs;

  var isPasswordVisible = false.obs;
  var isCreatePasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

//   Login screen
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController createPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _loginKey = GlobalKey<FormState>();
  GlobalKey<FormState> get loginFormKey => _loginKey;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Toggle visibility for the create password field
  void toggleCreatePasswordVisibility() {
    isCreatePasswordVisible.value = !isCreatePasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  final ApiService apiService = ApiService();

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // Validate input fields
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Username and password cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final body = {'username': username, 'password': password};

      // Make API call
      final response = await apiService.post('loginCafeUser', body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['token'] != null) {
          final token = responseData['token'];

          // Decode the token to extract the cafeId
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          String cafeId = decodedToken['cafe_id'].toString();

          // Save token, cafeId, and login status in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('cafe_id', cafeId);  // Save the cafeId
          await prefs.setBool('isLoggedIn', true);   // Mark as logged in

          // Show success snackbar before navigation
          Get.snackbar(
            'Success',
            'Login successful!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(milliseconds: 1500),
          );

          // Delay slightly to ensure snackbar is visible
          await Future.delayed(Duration(milliseconds: 500));

          // Navigate to the bottom screen (home screen)
          await Get.toNamed(AppPages.BOTTOM_SCREEN);

          // Fetch cafes or other necessary data after login
          await Get.find<CafeController>().fetchCafes(cafeId: int.parse(cafeId));
        } else {
          Get.snackbar(
            'Error',
            'Token not found in the response.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        final responseData = json.decode(response.body);
        Get.snackbar(
          'Error',
          responseData['message'] ?? 'Invalid username or password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}