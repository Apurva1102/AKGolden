import 'package:ak_golden_project/model/all_product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../controller/orderchekout_controller.dart';

class ProductCard extends StatelessWidget {
  final AllProductModule productModule;

  const ProductCard({required this.productModule});

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
                      child: Image.network(productModule.fullImagePath,),
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
                    "₹${productModule.dealPrice ?? 0}",  // Ensure basePrice has a default value if it's null
                      style: GoogleFonts.alatsi(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,  // Customize the font size based on your requirements
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
      alignment: FractionalOffset.center,
      clipBehavior: Clip.none,
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              show(context);
            },
            child: SizedBox(
              height: 240,
              width: 190,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(3),
                                ),
                              ),
                              child: const Icon(
                                Icons.circle,
                                size: 14,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h,),
                      Padding(
                        padding: const EdgeInsets.only(right: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productModule.name ?? "NA",
                              style: GoogleFonts.alatsi(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              "₹${productModule.basePrice}",
                              style: GoogleFonts.alatsi(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "₹${productModule.dealPrice}",
                            style: GoogleFonts.alatsi(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              orderCheckoutController.addProductToCart(productModule);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffFFF4D0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              'Add to Cart',
                              style: GoogleFonts.alatsi(
                                color: Colors.brown,
                                fontWeight: FontWeight.w400,
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
        ),
        Positioned(
          top: 30,
          width: 130,
          height: 130,
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
                  return Icon(Icons.broken_image, size: 150);
                },
              )
            ),
          ),
        ),
      ],
    );
  }
}

// cartAdd(BuildContext context) {
//     final CartController cartController = Get.put(CartController());
//     final OrderCheckoutController orderCheckoutController = Get.find(); // Get the controller instance
//
//
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Stack(
//           clipBehavior: Clip.none,
//           alignment: Alignment.topCenter,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 6.0),
//               child: IntrinsicHeight(
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(
//                             10),
//                         child: Image.asset('assets/images/cake.png'),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 22),
//                       child: Row(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(Radius.zero),
//                               border: Border.all(color: Colors.green),
//                             ),
//                             child: Icon(
//                               Icons.circle,
//                               size: 18,
//                               color: Colors.green,
//                             ),
//                           ),
//                           SizedBox(
//                             width: 3.w,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               width: 10.w,
//                               // height: 16,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   color: Colors.greenAccent.shade100),
//                               child: Center(
//                                   child: Text(
//                                     "New",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.green.shade600),
//                                   )),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 22),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             productModule.name ?? 'N/A',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {},
//                             icon: Icon(Icons.share),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 22),
//                       child: Row(
//                         children: [
//                           Text(
//                             "₹${productModule.makingPrice}",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 18),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 22),
//                       child: Row(
//                         children: [
//                           Text(
//                             productModule.details ?? "N/A",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 1.h,
//                     ),
//                     Container(
//                       height: 8.h,
//                       decoration: const BoxDecoration(
//                           color: Color(0xffFBEFE3),
//                           borderRadius: BorderRadius.only(
//                               topRight: Radius.circular(20),
//                               topLeft: Radius.circular(20))),
//                       child: Center(
//                         child: SizedBox(
//                           width: 100.w,
//                           height: 5.h,
//                           child: ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.brown.shade50,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // Quantity Selector
//                                 Container(
//                                   height: 4.h,
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 2, vertical: 2),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                         color: Colors.brown.shade200),
//                                     borderRadius: BorderRadius.circular(5),
//                                     color: Colors.brown.shade50,
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       // Decrease button
//                                       IconButton(
//                                         icon: Icon(
//                                           Icons.remove,
//                                           color: Colors.brown,
//                                         ),
//                                         onPressed: () {
//                                           // cartController.decreaseQuantity();
//                                           orderCheckoutController.addProductToCart(AllProductModule());
//                                         },
//                                         iconSize: 20,
//                                       ),
//                                       // Quantity text
//                                       Obx(() => Text(
//                                         "${cartController.quantity}",
//                                         style: TextStyle(
//                                             fontSize: 16.sp,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.brown),
//                                       )),
//                                       // Increase button
//                                       IconButton(
//                                         icon: Icon(
//                                           Icons.add,
//                                           color: Colors.brown,
//                                         ),
//                                         onPressed: () {
//                                           cartController.increaseQuantity();
//                                           // orderCheckoutController.removeProductFromCart(AllProductModule.fromJson);
//                                         },
//                                         iconSize: 20,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(width: 2.w),
//                                 Expanded(
//                                   child: ElevatedButton(
//                                     onPressed: () {
//                                       Get.toNamed('/billdetails');
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.brown,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         // Price
//                                         Obx(() => Text(
//                                           '₹ ${productModule.makingPrice! * cartController.quantity.value}',
//                                           style: TextStyle(
//                                             // fontSize: 14.sp,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         )),
//                                         // Text and Icon
//                                         Row(
//                                           children: [
//                                             Text(
//                                               "View Cart",
//                                               style: TextStyle(
//                                                 // fontSize: 14.sp,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                             SizedBox(width: 2.w),
//                                             Icon(
//                                               Icons.shopping_basket_outlined,
//                                               color: Colors.white,
//                                               // size: 18.sp,
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               top: -50,
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: const CircleAvatar(
//                   radius: 20,
//                   backgroundColor: Colors.white,
//                   child: Icon(Icons.close, color: Colors.grey),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }