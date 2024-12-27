import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void demo2(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      int itemCount = 0;
      return IntrinsicHeight(
        child: Column(
          children: [
            Image.asset('assets/images/cake.png'),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.zero),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Icon(
                    Icons.circle,
                    color: Colors.green,
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Container(
                  width: 10.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.greenAccent),
                  child: const Center(
                      child: Text(
                    "New",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  )),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  " Almond Chocolate Cupcake",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
              ],
            ),
            const Row(
              children: [
                Icon(Icons.currency_rupee),
                Text(
                  "  99",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Extra protein charges an additional charge",
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.zero),
                  color: Color(0xffFBEFE3)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {},
                    ),
                    Text(itemCount.toString()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {},
                    )
                  ]),
                  SizedBox(
                    height: 4.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.currency_rupee,
                            color: Colors.white,
                          ),
                          Text(
                            "99",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/billdetails');
                            },
                            child: Text(
                              "  View Cart",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
