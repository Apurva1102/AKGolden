import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../controller/allcafename_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final CafeController controller = Get.put(CafeController());

  Future<void> clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
       // toolbarHeight: 20,
        backgroundColor: const Color(0xff7B3F00),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   height: 5.h,
            //   // width: double.infinity,
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
            //           width: 3.w,
            //         ),
            //         Text(
            //           "AK Golden Crust",
            //           style: GoogleFonts.poppins(
            //               color: Colors.white,
            //               fontWeight: FontWeight.w400,
            //               fontSize: 14),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(height: 15.h,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    // width: 26.w,
                    // height: 4.h,
                    child: ElevatedButton(
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
                                        await clearSharedPreferences();
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

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff7B3F00),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.brown),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Log Out",
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          const Icon(
                            Icons.arrow_circle_right,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Center(
                child: Column(
                  children: [
                    Text(
                      "Complete Your Profile",
                      style: GoogleFonts.alatsi(
                          fontSize: 24, fontWeight: FontWeight.w400),
                    ),
                    // SizedBox(height: 1.h,),
                    Text(
                      "Don’t worry, only you can see your personal \n data. No one else will be able to see it.",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                    SizedBox(height: 2.h,),
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xffF3F3F3),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Color(0xff7B3F00),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.brown.shade200,
                            child: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Color(0xff7B3F00),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h,),
                  ],
                )
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Username",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                  TextFormField(
                    readOnly: true,
                    // keyboardType: TextInputType.emailAddress,
                    decoration:  InputDecoration(
                      hintText: '${controller.username}',
                      hintStyle:
                      const TextStyle(color: Colors.black26),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.brown, width: 2),
                        borderRadius: BorderRadius.all(
                            Radius.circular(5)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.all(
                            Radius.circular(5)),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h,),
                  Text(
                    "Phone Number",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                  TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration:  InputDecoration(
                      hintText: '${controller.cellNumber}',
                      hintStyle:
                      const TextStyle(color: Colors.black26),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.brown, width: 2),
                        borderRadius: BorderRadius.all(
                            Radius.circular(5)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.all(
                            Radius.circular(5)),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h,),
                  Text(
                    "Email",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                  TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration:  InputDecoration(
                      hintText: '${controller.email}',
                      hintStyle:
                      const TextStyle(color: Colors.black26),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.brown, width: 2),
                        borderRadius: BorderRadius.all(
                            Radius.circular(5)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.all(
                            Radius.circular(5)),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h,),
                  // SizedBox(
                  //   width: 90.w,
                  //   height: 6.h,
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor:
                  //       const Color(0xff7B3F00),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius:
                  //         BorderRadius.circular(3),
                  //       ),
                  //     ),
                  //     child: Text(
                  //       "Complete Profile",
                  //       style: GoogleFonts.poppins(
                  //         fontWeight: FontWeight.w600,
                  //         color: Colors.white,
                  //         fontSize: 16.sp,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
