import 'package:ak_golden_project/common/repeat_order_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../common/order_form.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
                  Text(
                    "  Wednesday is holiday",
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
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
                    Get.bottomSheet(
                      Container(
                        height: 250,
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20)),
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
                            SizedBox(height: 1.h,),
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
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceEvenly,
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
                                          borderRadius: BorderRadius.zero
                                      )
                                  ),
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
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.clear();
                                    // await clearSharedPreferences();
                                    // Get.off(() => LoginScreen());
                                    Get.offAllNamed('/login',);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(
                                          0xff7B3F00),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero
                                      )
                                  ),
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
              // Container(
              //   height: 5.h,
              //   width: 100.w,
              //   color: const Color(0xffD7BB9E),
              //   child: Padding(
              //     padding: const EdgeInsets.all(10.0),
              //     child: Row(
              //       children: [
              //         const Icon(
              //           Icons.location_on_sharp,
              //           color: Colors.white,
              //         ),
              //         SizedBox(
              //           width: 4.w,
              //         ),
              //         Text(
              //           "AK Golden Crust",
              //           style: GoogleFonts.poppins(
              //             color: Colors.white,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(height: 5.h,),
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
                      text: "New Order",
                    ),
                    Tab(
                      text: "Repeat Order",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h,),
              SizedBox(
                height: 70.h,
                child: TabBarView(
                  children: [
                    NewOrderForm(),
                    RepeatOrder(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
