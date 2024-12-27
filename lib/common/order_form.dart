import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:sizer/sizer.dart';
import '../controller/allcafename_controller.dart';
import '../controller/date_controller.dart';
import '../screens/order_checkout_screen.dart';

class NewOrderForm extends StatelessWidget {
  NewOrderForm({super.key});

  final DateController dateController = Get.put(DateController());
  final CafeController cafeController = Get.put(CafeController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (dateController.selectedDate.isEmpty) {
        dateController.setDate(DateFormat('yyyy-MM-dd').format(DateTime.now()));
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 2.h),
              Obx(() {
                if (cafeController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (cafeController.cafeNames.isNotEmpty) {
                  final selectedCafeName = cafeController.cafeNames.first;
                  final selectedCafeId = cafeController.cafes
                      .firstWhere(
                        (cafe) => cafe.cafeName == selectedCafeName,
                    orElse: () => cafeController.cafes[0],
                  )
                      .cafeId;

                  // Update selectedCafeId in the controller
                  cafeController.selectedCafeId.value = selectedCafeId;

                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      selectedCafeName,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "No cafes available",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
              }),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Obx(() {
                  return TextFormField(
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                        dateController.setDate(formattedDate);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Date',
                      labelStyle: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          fontSize: 16),
                      hintText: 'Select a date',
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.brown, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    controller: TextEditingController(
                      text: dateController.selectedDate.value.isEmpty
                          ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                          : dateController.selectedDate.value,
                    ),
                  );
                }),
              ),
              SizedBox(height: 1.h),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Note",
                    hintText: "Note",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 15.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 2.h, horizontal: 2.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  style: const TextStyle(fontSize: 17),
                ),
              ),

              SizedBox(height: 20.h),
              Center(
                child: SizedBox(
                  width: 342,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (cafeController.cafeNames.isEmpty) {
                        Get.snackbar(
                          'Validation Error',
                          'Please select a cafe before proceeding.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      if (dateController.selectedDate.isEmpty) {
                        Get.snackbar(
                          'Validation Error',
                          'Please select a valid date.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: OrderCheckoutScreen(),
                        withNavBar: true,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff7B3F00),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    child: Text(
                      'Select Products',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
