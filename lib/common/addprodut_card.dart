import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../controller/orderchekout_controller.dart';
import '../model/all_product_model.dart';

class AddprodutCard extends StatelessWidget {
  final AllProductModule productModule;

  const AddprodutCard({super.key, required this.productModule});

  void show(BuildContext context) {
    final OrderCheckoutController orderCheckoutController = Get.find();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            IntrinsicHeight(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(productModule.fullImagePath),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.zero),
                            border: Border.all(color: Colors.green),
                          ),
                          child: const Icon(
                            Icons.circle,
                            size: 18,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 10.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.greenAccent.shade100),
                            child: Center(
                                child: Text(
                              "New",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700),
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          productModule.name ?? "NA",
                          style: GoogleFonts.alatsi(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Row(
                      children: [
                        Text(
                          "₹${productModule.basePrice ?? 0}", // Ensure basePrice has a default value if it's null
                          style: GoogleFonts.alatsi(
                            fontWeight: FontWeight.w400,
                            fontSize: 14
                                .sp, // Customize the font size based on your requirements
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Row(
                      children: [
                        Text(
                          productModule.details ?? "NA",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Container(
                    height: 8.h,
                    decoration: const BoxDecoration(
                        color: Color(0xffFBEFE3),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20))),
                    child: Center(
                      child: SizedBox(
                        width: 82.w,
                        height: 5.h,
                        child: ElevatedButton(
                          onPressed: () {
                            // Get.back();
                            orderCheckoutController
                                .addProductToCart(productModule);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              padding: const EdgeInsets.all(8),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.zero))),
                          child: Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -50,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.grey),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final OrderCheckoutController orderCheckoutController = Get.find();

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: 8.w),
          child: GestureDetector(
            onTap: () {
              show(context);
            },
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 12.w),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: ShapeDecoration(
                                  shape: Border.all(color: Colors.green),
                                ),
                                child: const Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 14,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                productModule.name ?? "NA",
                                style: GoogleFonts.alatsi(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h),
                    // Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "₹${productModule.basePrice}",
                          style: GoogleFonts.alatsi(
                              fontWeight: FontWeight.w400, fontSize: 16.sp),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            orderCheckoutController
                                .addProductToCart(productModule);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffE8EBED),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'Add cart',
                            style: GoogleFonts.alatsi(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Circular Image
        Positioned(
          top: 0,
          width: 133,
          height: 133,
          child: GestureDetector(
            onTap: () {
              show(context);
            },
            child: ClipOval(
                child: Image.network(
              productModule.fullImagePath,
              height: 27.h,
              width: 27.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 150);
              },
            )),
          ),
        )
      ],
    );
  }
}
