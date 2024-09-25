import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reclaim_firebase_app/controller/order_controller.dart';

import '../../const/assets/image_assets.dart';
import '../../const/color.dart';
import '../../controller/home_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  final HomeController homeController = Get.find<HomeController>();
  final OrderController orderController = Get.find<OrderController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderController.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar1(
        homeController: homeController,
        text: 'Orders',
      ),
      body: Obx(() {
        if (orderController.orders.isEmpty) {
          return Center(
            child: Text('No orders available.'),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: orderController.orders.length,
            itemBuilder: (context, index) {
              var order = orderController.orders[index];
              var product = orderController.productListing[order['productId']];
              Timestamp timestamp = order['orderDate'];
              DateTime date = timestamp.toDate();
              String formattedDate = DateFormat('yyyy-MM-dd').format(date);
              return Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 78.h,
                            width: 89.w,
                            child: product != null
                                ? CachedNetworkImage(
                                    imageUrl: product['productImages'][0],
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                      color: primaryColor,
                                    )), // Loading indicator
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error), // Error icon
                                  )
                                : SizedBox.shrink(),
                          ),
                          SizedBox(width: 7.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InterCustomText(
                                text: product['brand'],
                                textColor: Color(0xff9B9B9B),
                                fontWeight: FontWeight.w400,
                                fontsize: 11.sp,
                              ),
                              InterCustomText(
                                text: product != null
                                    ? product['productName']
                                    : 'Product Name',
                                textColor: Color(0xff222222),
                                fontWeight: FontWeight.w600,
                                fontsize: 16.sp,
                              ),
                              InterCustomText(
                                text: '${order['buyingprice']} Aed',
                                textColor: Color(0xff222222),
                                fontWeight: FontWeight.w500,
                                fontsize: 14.sp,
                              ),
                              InterCustomText(
                                text: formattedDate,
                                textColor: Color(0xff9B9B9B),
                                fontWeight: FontWeight.w400,
                                fontsize: 11.sp,
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                            width: 74.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11.r),
                              color: primaryColor,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InterCustomText(
                                  text: 'Order Price',
                                  textColor: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontsize: 11.sp,
                                ),
                                SizedBox(height: 3.h),
                                InterCustomText(
                                  text: '${order['buyingprice']} Aed',
                                  textColor: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontsize: 11.sp,
                                ),
                                SizedBox(height: 3.h),
                                Container(
                                  width: 49.w,
                                  height: 15.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    color: Color(0xffF0FFE0),
                                  ),
                                  child: Center(
                                    child: InterCustomText(
                                      text: 'Ordered',
                                      textColor: Color(0xff11CF0A),
                                      fontWeight: FontWeight.w500,
                                      fontsize: 10.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Wrap(
                        spacing: 3, // space between items
                        runSpacing: 10, // space between rows
                        children:
                            [product['category'], product['size']].map((item) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(() => Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      color: (item ==
                                              homeController.selectedSize.value)
                                          ? primaryColor
                                          : primaryColor.withOpacity(
                                              0.10), // Highlight background color for selected item
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MontserratCustomText(
                                            text: item,
                                            textColor: (item ==
                                                    homeController
                                                        .selectedSize.value)
                                                ? whiteColor
                                                : primaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontsize: 10.sp,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
