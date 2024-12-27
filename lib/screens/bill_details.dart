import 'package:ak_golden_project/screens/order_checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:sizer/sizer.dart';
import '../controller/allcafename_controller.dart';
import '../controller/orderchekout_controller.dart';
import '../model/all_product_model.dart';

class BillDetails extends StatefulWidget {
  const BillDetails({super.key});

  @override
  State<BillDetails> createState() => _BillDetailsState();
}

class _BillDetailsState extends State<BillDetails> {
  @override
  Widget build(BuildContext context) {
    final cafeController = Get.find<CafeController>();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff7B3F00),
          title: Column(
            children: [
              Text(
                "Ak Golden Crust",
                style: GoogleFonts.alatsi(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Obx(() => Text(
                  "  ${cafeController.cafeAddress.value}",
                  style: GoogleFonts.alatsi(fontWeight: FontWeight.w400,color: Colors.white,fontSize: 14.sp),
                )),

              )
            ],
          ),
        ),
        body: SingleChildScrollView(
            reverse: false,
            child: Column(
              children: [
                Container(
                  height: 5.h,
                  width: 100.w,
                  color: const Color(0xffD7BB9E),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_sharp,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Obx(() {
                          final cafeName = cafeController.cafes
                                  .firstWhereOrNull(
                                    (cafe) =>
                                        cafe.cafeId ==
                                        cafeController.selectedCafeId.value,
                                  )
                                  ?.cafeName ??
                              'Unnamed Cafe';

                          return Text(
                            "Deliver to $cafeName",
                            style: GoogleFonts.alatsi(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    children: [
                      _buildAddressSection(),
                      _buildDivider(),
                      _buildItemsSection(),
                      SizedBox(
                        height: 1.h,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Get.toNamed('/ordercheckout_screen');
                          // Get.back();
                          // Get.find<PersistentTabController>().jumpToTab(1); // Assuming BillDetails is at index 3
                          PersistentNavBarNavigator.pushNewScreen(context,
                              screen: OrderCheckoutScreen(), withNavBar: true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff7B3F00),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 5,
                          textStyle: TextStyle(fontSize: 14.sp),
                        ),
                        child: Text(
                          'Add more',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      _buildBillDetailsSection(),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
                _buildPlaceOrderButton(),
              ],
            )));
  }



  Widget _buildAddressSection() {
    final CafeController cafeController = Get.find();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 2.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "  Delivery Address:",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Obx(() => Text(
                        // Use Obx to update when cafeAddress changes
                        "  ${cafeController.cafeAddress.value}",
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    final orderCheckoutController = Get.put(OrderCheckoutController());

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
        child: Text(
          "    Items Added",
          style: GoogleFonts.alatsi(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
      Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          color: Colors.white,
        ),
        child: Obx(() {
          final selectedProducts = orderCheckoutController.selectedProducts;

          if (selectedProducts.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "No products in the cart.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: selectedProducts.map((product) {
                const outOfStock = false;
                return _buildItemRow(product, outOfStock);
              }).toList(),
            ),
          );
        }),
      ),
    ]);
  }

  Widget _buildBillDetailsSection() {
    final orderCheckoutController = Get.find<OrderCheckoutController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Text(
            "    Bill Details",
            style: GoogleFonts.alatsi(
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Subtotal
                Obx(() => _buildBillRow(
                      "Subtotal",
                      "₹${orderCheckoutController.totalPrice.value}",
                    )),
                _buildBillRow("GST", "₹ 0.00"),
                // GST
                // Obx(()
                // {
                //   final gstAmount = orderCheckoutController.gstAmount;
                //   return _buildBillRow(
                //     "GST@",
                //     "₹${gstAmount.toStringAsFixed(2)}",
                //   );
                // }),

                // Delivery
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Delivery",
                      style: TextStyle(color: Color(0xff466C08)),
                    ),
                    Text(
                      "Free delivery",
                      style: TextStyle(color: Color(0xff466C08)),
                    ),
                  ],
                ),

                // Packaging Charges
                _buildBillRow("Packaging Charges", "₹ 0.00"),

                // Grand Total
                Obx(() {
                  final grandTotal = orderCheckoutController.grandTotal;
                  return _buildBillRow(
                    "Grand Total",
                    "₹${grandTotal.toStringAsFixed(2)}",
                    isBold: true,
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton() {
    final orderCheckoutController = Get.find<OrderCheckoutController>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 9),
          child: Center(
            child: SizedBox(
              width: 342,
              height: 44,
              child: ElevatedButton(
                onPressed: () async {
                  if (orderCheckoutController.selectedProducts.isEmpty) {
                    Get.snackbar("Error", "Please add products to your cart.",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        duration: const Duration(milliseconds: 1000));
                    return;
                  }
                  await orderCheckoutController.submitOrder();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff7B3F00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  "Confirm Order",
                  style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Obx(
          () => Visibility(
            visible: orderCheckoutController.showCancelButton.value,
            child: Center(
              child: SizedBox(
                width: 342,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    orderCheckoutController.cancelOrder(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.brown),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    "Cancel Order",
                    style: GoogleFonts.manrope(
                        color: Colors.brown,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey,
      height: 2.h,
      thickness: 1,
    );
  }


  Widget _buildItemRow(AllProductModule product, bool outOfStock) {
    final orderCheckoutController = Get.find<OrderCheckoutController>();
    final productId = product.productId ?? 0;
    final quantity = orderCheckoutController.cartItems[product.productId] ?? 0;

    final priceToDisplay = product.dealPrice ?? product.basePrice;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      // cartAdd(context, product);
                    },
                    child: Row(
                      children: [
                        Text(
                          product.name ?? "Unnamed Product",
                          style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "[ $quantity ${product.priceScale == 'Per Item' ? 'Piece' : 'kg'} ]",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.zero),
                          border: Border.all(color: Colors.green),
                        ),
                        child: const Icon(
                          Icons.circle,
                          size: 15,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        // outOfStock
                        //     ? " Item is Out of Stock. Kindly Remove"
                        //     : "In Stock",
                        "${product.priceScale == 'Per Item' ? 'Per Item' : 'Per Kg'} ",

                        style: GoogleFonts.inter(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "₹${priceToDisplay ?? 0}",
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                ],
              ),
              if (product.priceScale == 'Per Item')
                Column(
                  children: [
                    // Quantity control buttons
                    Row(
                      children: [
                        Container(
                          width: 120,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.brown),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove,
                                  size: 16,
                                ),
                                onPressed: () {
                                    orderCheckoutController
                                        .decreaseProductQuantity(productId);
                                },
                                color:
                                    quantity == 0 ? Colors.grey : Colors.brown,
                              ),
                              Text(
                                "$quantity",
                                style: const TextStyle(
                                    color: Colors.brown, fontSize: 14),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  size: 16,
                                ),
                                onPressed: () {
                                    orderCheckoutController
                                        .increaseProductQuantity(productId);
                                    },
                                color: outOfStock ? Colors.grey : Colors.brown,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, size: 24),
                          onPressed: () {
                            orderCheckoutController
                                .removeAllProducts(productId);
                          },
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      "₹${(priceToDisplay ?? 0) * quantity}",
                      style: GoogleFonts.alatsi(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              if (product.priceScale == 'Per kg')
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 120,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.brown),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (value) {
                              orderCheckoutController.updateWeight(productId, value);
                            },
                            // controller: TextEditingController(text: orderCheckoutController.getDisplayWeight(productId)),
                            decoration: const InputDecoration(
                              hintText: 'Enter',
                              suffixText: 'KG',
                              hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            style: const TextStyle(color: Colors.brown, fontSize: 14),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        IconButton(
                          icon: const Icon(Icons.cancel, size: 24),
                          onPressed: () {
                            orderCheckoutController.removeAllProducts(productId);
                          },
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text(
                        //   "${orderCheckoutController.getDisplayWeight(productId)} KG",
                        //   style: const TextStyle(
                        //     color: Colors.grey,
                        //     fontSize: 12,
                        //   ),
                        // ),
                        Text(
                          "₹${orderCheckoutController.getPriceToDisplay(productId).toStringAsFixed(2)}",
                          style: GoogleFonts.alatsi(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              // fontSize: 12.sp,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              // fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

void cartAdd(BuildContext context, AllProductModule selectedProduct) {
  final OrderCheckoutController orderCheckoutController = Get.find();

  final priceToDisplay = selectedProduct.dealPrice ?? selectedProduct.basePrice;

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: IntrinsicHeight(
                child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:  Image.network(selectedProduct.fullImagePath,)
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedProduct.name ?? 'N/A',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
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
                      '₹ ${priceToDisplay! * (orderCheckoutController.cartItems[selectedProduct.productId] ?? 0)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Row(
                  children: [
                    Text(
                      selectedProduct.details ??
                          "N/A", // Use the passed product's details
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xffFBEFE3),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                child: Center(
                  child: SizedBox(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 4.h,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.brown.shade200),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.brown.shade50,
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Colors.brown,
                                  ),
                                  onPressed: () {
                                    orderCheckoutController
                                        .decreaseProductQuantity(
                                            selectedProduct.productId!);
                                  },
                                  iconSize: 20,
                                ),
                                // Quantity text
                                Obx(() => Text(
                                      "${orderCheckoutController.cartItems[selectedProduct.productId] ?? 0}",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown),
                                    )),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.brown,
                                  ),
                                  onPressed: () {
                                    orderCheckoutController
                                        .increaseProductQuantity(
                                            selectedProduct.productId!);
                                  },
                                  iconSize: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.find<PersistentTabController>()
                                    .jumpToTab(3);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(() => Text(
                                        '₹ ${selectedProduct.basePrice! * (orderCheckoutController.cartItems[selectedProduct.productId] ?? 0)}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Row(
                                    children: [
                                      const Text(
                                        "View Cart",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      const Icon(
                                        Icons.shopping_basket_outlined,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ])),
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
