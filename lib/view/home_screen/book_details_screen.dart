import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../const/assets/image_assets.dart';
import '../../const/color.dart';
import '../../controller/bookListing_controller.dart';
import '../../controller/chat_controller.dart';
import '../../controller/home_controller.dart';
import '../../controller/user_controller.dart';
import '../../widgets/custom _backbutton.dart';
import '../../widgets/custom_text.dart';

class BookDetailsScreen extends StatefulWidget {
  // final dynamic bookDetail;
  // final int index;
  // final bool comingfromSellScreen;
  const BookDetailsScreen({
    super.key,
    // required this.bookDetail,
    // required this.index,
    // required this.comingfromSellScreen
  });

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final BookListingController bookListingController =
      Get.find<BookListingController>();
  final HomeController homeController = Get.find<HomeController>();
  final UserController userController = Get.find<UserController>();
  final ChatController chatController = Get.find<ChatController>();
  late final String formattedDate;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //
  //   chatController.getorderId(widget.bookDetail['listingId']);
  //   // bookListingController.checkUserBookOrder(widget.bookDetail['listingId'],widget.bookDetail['sellerId']);
  //   bookListingController.getSellerData(widget.bookDetail['sellerId']);
  //   super.initState();
  //   Timestamp timestamp = widget.bookDetail['bookPosted'];
  //   DateTime dateTime = timestamp.toDate();
  //   formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime);
  // }
  final List<String> items = [
    'Size UK 14',
    'Women',
    'Barely Used',
    'TopShop',
    'Open for negotiation',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: SafeArea(
                    child: const CustomBackButton(),
                  ),
                ),
                Center(
                  child: Container(
                      height: 400.h,
                      width: 275.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(AppImages.image5)))),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InterCustomText(
                            text: 'Adidas Japan Sneakers',
                            textColor: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontsize: 20.sp,
                          ),
                          InterCustomText(
                            text: '\$250',
                            textColor: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontsize: 18.sp,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      InterCustomText(
                        text: 'Short black dress',
                        textColor: Color(0xff9B9B9B),
                        fontWeight: FontWeight.w400,
                        fontsize: 16.sp,
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      Wrap(
                        spacing: 3, // space between items
                        runSpacing: 10, // space between rows
                        children: items.map((size) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  homeController.selectedSize.value = size;
                                },
                                child: Obx(() => Container(
                              // width: 76.w,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,   vertical: 6.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.r),
        
                                        color: size ==
                                                homeController.selectedSize.value
                                            ? primaryColor
                                            : primaryColor.withOpacity(0.10),// Highlight background color for selected size
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            MontserratCustomText(
                                              text: size,
                                              textColor: size ==
                                                      homeController
                                                          .selectedSize.value
                                                  ? whiteColor
                                                  : primaryColor, // Change as needed
                                              fontWeight: FontWeight.w500,
                                              fontsize: 10.sp,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 9.h,
                      ),
        
                      InterCustomText(
                        text:
                            'Short dress in soft cotton jersey with decorative buttons down the front and a wide, frill-trimmed square neckline with concealed elastication. ',
                        textColor: Color(0xff222222),
                        fontWeight: FontWeight.w400,
                        fontsize: 14.sp,
                      ),
        
                      // widget.bookDetail['sellerId'] == 'qwerty'
                      //     ? Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           MontserratCustomText(
                      //             text: 'Price',
                      //             textColor: Colors.black,
                      //             fontWeight: FontWeight.w500,
                      //             fontsize: 16.sp,
                      //           ),
                      //           MontserratCustomText(
                      //             text: "\$${widget.bookDetail['bookPrice']}",
                      //             textColor: lightColor,
                      //             fontWeight: FontWeight.w500,
                      //             fontsize: 16.sp,
                      //           ),
                      //         ],
                      //       )
                      //     : const SizedBox.shrink(),
        
                      // Obx(() => userController.userPurchases
                      //         .contains(widget.bookDetail['listingId'])
                      //     ? GestureDetector(
                      //         onTap: () {
                      //           CustomRoute.navigateTo(
                      //               context,
                      //               ChatScreen(
                      //                 image: widget.bookDetail['bookImage'],
                      //                 chatName: widget.bookDetail['sellerId'] ==
                      //                         FirebaseAuth.instance.currentUser!.uid
                      //                     ? widget.bookDetail['bookName']
                      //                     : "You Bought ${widget.bookDetail['bookName']}",
                      //                 chatId: chatController
                      //                     .orderId.value, //order is our chatId
                      //
                      //                 sellerId: widget.bookDetail['sellerId'] ==
                      //                         FirebaseAuth.instance.currentUser!.uid
                      //                     ? chatController.buyerId.value
                      //                     : chatController.sellerId.value,
                      //                 buyerId: chatController.buyerId.value,
                      //                 seller: widget.bookDetail['sellerId'],
                      //                 bookId: widget.bookDetail['bookImage'],
                      //                 bookName: widget.bookDetail['bookName'],
                      //               ));
                      //         },
                      //         child: Center(
                      //           child: Container(
                      //             height: 58.h,
                      //             width: 327.w,
                      //             alignment: Alignment.center,
                      //             decoration: BoxDecoration(
                      //                 color: primaryColor,
                      //                 borderRadius: BorderRadius.circular(20.r)),
                      //             child:
                      //                 // bookDetail['sellerId']==FirebaseAuth.instance.currentUser!.uid?
                      //                 // LexendCustomText(text: "Cancel This Listing", textColor: Colors.white, fontWeight: FontWeight.w400,fontsize: 18.sp,):
                      //
                      //                 Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 LexendCustomText(
                      //                   text: "Chat with seller",
                      //                   textColor: Colors.white,
                      //                   fontWeight: FontWeight.w400,
                      //                   fontsize: 18.sp,
                      //                 ),
                      //
                      //                 // LexendCustomText(text: "\$${bookDetail['bookPrice'].toString()}", textColor: Colors.white, fontWeight: FontWeight.w600,fontsize: 24.sp,),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       )
                      //     : GestureDetector(
                      //         onTap: () {
                      //           if (userController.verified.value == true) {
                      //             widget.bookDetail['sellerId'] !=
                      //                     FirebaseAuth.instance.currentUser!.uid
                      //                 ? bookListingController.buyBook(
                      //                     widget.bookDetail['listingId'],
                      //                     widget.bookDetail['sellerId'],
                      //                     context,
                      //                     widget.bookDetail['bookName'],
                      //                     widget.bookDetail['bookPrice'],
                      //                     widget.bookDetail['bookImage'])
                      //                 : widget.comingfromSellScreen == true
                      //                     ? bookListingController
                      //                         .removeListingfromSell(widget.index,
                      //                             widget.bookDetail['listingId'])
                      //                     : homeController.removeBookListing(
                      //                         widget.index,
                      //                         widget.bookDetail['listingId']);
                      //           } else {
                      //             Get.snackbar('Your Profile is UnderReview',
                      //                 'Wait for Admin Approval');
                      //           }
                      //         },
                      //         child: Center(
                      //           child: Container(
                      //             height: 58.h,
                      //             width: 327.w,
                      //             alignment: Alignment.center,
                      //             decoration: BoxDecoration(
                      //                 color: primaryColor,
                      //                 borderRadius: BorderRadius.circular(20.r)),
                      //             child: widget.bookDetail['sellerId'] ==
                      //                     FirebaseAuth.instance.currentUser!.uid
                      //                 ? LexendCustomText(
                      //                     text: "Cancel This Listing",
                      //                     textColor: Colors.white,
                      //                     fontWeight: FontWeight.w400,
                      //                     fontsize: 18.sp,
                      //                   )
                      //                 : bookListingController.isLoading.value ==
                      //                         false
                      //                     ? Row(
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment.center,
                      //                         children: [
                      //                           LexendCustomText(
                      //                             text: "Add to Cart ",
                      //                             textColor: Colors.white,
                      //                             fontWeight: FontWeight.w400,
                      //                             fontsize: 18.sp,
                      //                           ),
                      //                           LexendCustomText(
                      //                             text:
                      //                                 "\$${widget.bookDetail['bookPrice'].toString()}",
                      //                             textColor: Colors.white,
                      //                             fontWeight: FontWeight.w600,
                      //                             fontsize: 24.sp,
                      //                           ),
                      //                         ],
                      //                       )
                      //                     : CircularProgressIndicator(
                      //                         color: Colors.white,
                      //                       ),
                      //           ),
                      //         ),
                      //       )),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 58.h,
                    width: 155.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xffFFB9B9),
                        borderRadius: BorderRadius.circular(20.r)),
                    child: MontserratCustomText(
                      text: 'Make offer',
                      textColor: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontsize: 16.sp,
                    ),
                  ),
                  Container(
                    height: 58.h,
                    width: 155.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20.r)),
                    child: MontserratCustomText(
                      text: 'Purchase',
                      textColor: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontsize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            )
          ],
        ),
      ),
    );
  }
}
