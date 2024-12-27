import 'package:ak_golden_project/common/addprodut_card.dart';
import 'package:ak_golden_project/screens/bill_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../common/product_card.dart';
import '../controller/bottom_navigation_controller.dart';
import '../controller/orderchekout_controller.dart';

class OrderCheckoutScreen extends StatelessWidget {
  OrderCheckoutScreen({super.key});

  final OrderCheckoutController controller = Get.put(OrderCheckoutController());
  final BottomNavigationController bottomNavController =
      Get.put(BottomNavigationController());

  @override
  Widget build(BuildContext context) {
    // double deviceHeight = MediaQuery.of(context).size.height;

    // final List<Widget> imageSliders = List.generate(4, (index) {
    //   return Container(
    //     margin: const EdgeInsets.all(5.0),
    //     child: ClipRRect(
    //       borderRadius: const BorderRadius.all(Radius.circular(5.0)),
    //       child: Image.asset(
    //         'assets/images/pic.png',
    //         fit: BoxFit.cover,
    //         width: 1000.w,
    //       ),
    //     ),
    //   );
    // });

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        toolbarHeight: 72,
        backgroundColor: const Color(0xff7B3F00),
        title: Padding(
          padding: const EdgeInsets.only(left: 6.0, right: 12.0),
          child: Container(
            height: 35,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(6)),
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
                  " Wednesday is holiday",
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
              child: IconButton(
                  onPressed: () {
                    // Get.toNamed('billdetails');
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
                                      side:
                                          const BorderSide(color: Colors.brown),
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
                  icon: const Icon(Icons.person, color: Colors.brown)),
            ),
          ),
          // SizedBox(width: 2.w),
          // Padding(
          //   padding: const EdgeInsets.only(right: 15),
          //   child: Container(
          //     height: 36,
          //     width: 36,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(6),
          //       color: Colors.white,
          //     ),
          //     child: const Icon(Icons.search, color: Colors.brown),
          //   ),
          // )
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 55.w,
        height: 6.h,
        child: FloatingActionButton(
          onPressed: () {
            PersistentNavBarNavigator.pushNewScreen(context,
                screen: const BillDetails(), withNavBar: true);
          },
          backgroundColor: const Color(0xff7B3F00),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Check Out",
                style: GoogleFonts.alatsi(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 17.sp),
              ),
              SizedBox(width: 2.w,),
              const Icon(
                Icons.double_arrow_outlined,
                color: Colors.white,
                size: 25,
              )
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        reverse: false,
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
            //           " Deliver to Manapa",
            //           style: GoogleFonts.poppins(
            //               color: Colors.white, fontWeight: FontWeight.w400),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(height: 2.h),
            // CarouselSlider(
            //   options: CarouselOptions(
            //     height: 183,
            //     aspectRatio: Device.width,
            //     // aspectRatio: 2.0,
            //     // aspectRatio: deviceWidth > 600 ? 2.5 : 2.0,
            //     enlargeCenterPage: true,
            //     onPageChanged: (index, reason) =>
            //         controller.currentCarouselIndex(index),
            //     autoPlay: true,
            //     autoPlayInterval: const Duration(seconds: 2),
            //   ),
            //   // items: imageSliders,
            // ),
            // Column(
            //   children: [
            //     Obx(
            //       () => buildCarouselIndicator(
            //         controller.currentCarouselIndex.value,
            //         imageSliders.length,
            //         (index) {
            //           controller.currentCarouselIndex(index);
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '   Special Deals',
                  style: GoogleFonts.alatsi(
                      fontWeight: FontWeight.w400, fontSize: 18.sp),
                ),
              ],
            ),
            SizedBox(
                height: 35.h,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.errorMessage.isNotEmpty) {
                    return Center(child: Text(controller.errorMessage.value));
                  } else {
                    return GridView.builder(
                      itemCount: controller
                          .dealProducts.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 0.04,
                        mainAxisSpacing: 1.03,
                        childAspectRatio: 1.7,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {

                          },
                          child: ProductCard(
                            productModule: controller
                                .dealProducts[index], // Use dealProducts here
                          ),
                        );
                      },
                    );
                  }
                })),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '     You may also Like',
                  style: GoogleFonts.alatsi(
                      fontWeight: FontWeight.w400, fontSize: 18.sp),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.errorMessage.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                } else {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: controller.restProducts.length,
                    itemBuilder: (context, index) {
                      return AddprodutCard(
                        productModule: controller.restProducts[index],
                      );
                    },
                  );
                }
              }),
            )
          ],
        ),
      ),
    );
  }

}


Row buildCarouselIndicator(
  int currentCarouselIndex,
  int itemCount,
  void Function(int) onIndicatorTap,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (int i = 0; i < itemCount; i++)
        GestureDetector(
          onTap: () {
            onIndicatorTap(i);
          },
          child: Container(
            width: 16,
            height: 5.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              // shape: BoxShape.rectangle,
              color: currentCarouselIndex == i
                  ? Colors.white
                  : Colors.brown.shade300,
            ),
          ),
        ),
    ],
  );
}
