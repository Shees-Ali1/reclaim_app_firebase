import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:reclaim_firebase_app/controller/productsListing_controller.dart';
import '../../const/color.dart';
import '../../controller/chat_controller.dart';
import '../../controller/home_controller.dart';
import '../../controller/user_controller.dart';
import '../../widgets/custom _backbutton.dart';
import '../../widgets/custom_text.dart';

class BookDetailsScreen extends StatefulWidget {
  final dynamic bookDetail;
  final int index;
  final bool comingfromSellScreen;

  const BookDetailsScreen({super.key,
    required this.bookDetail,
    required this.index,
    required this.comingfromSellScreen});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final ProductsListingController productsListingController =
  Get.find<ProductsListingController>();
  final HomeController homeController = Get.find<HomeController>();
  final UserController userController = Get.find<UserController>();
  final ChatController chatController = Get.find<ChatController>();
  late final String formattedDate;

  @override
  void initState() {
    // TODO: implement initState
    chatController.getorderId(widget.bookDetail['listingId']);

    productsListingController.getSellerData(widget.bookDetail['sellerId']);
    super.initState();
  }

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
                              image: NetworkImage(
                                  widget.bookDetail['productImage'])))),
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
                            text: widget.bookDetail['brand'], // Product name
                            textColor: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontsize: 20.sp,
                          ),
                          InterCustomText(
                            text: '${widget.bookDetail['productPrice']} Aed',
                            // Product price
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
                        text: widget.bookDetail['productName'],
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
                        children: [
                          widget.bookDetail['category'],
                          widget.bookDetail['size']
                        ].map((item) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(() =>
                                  Container(
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
                      SizedBox(
                        height: 9.h,
                      ),
                      InterCustomText(
                        text: widget.bookDetail['Description'], // Product name
                        textColor: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontsize: 20.sp,
                      ),
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
              child: widget.bookDetail['sellerId'] ==
                  FirebaseAuth.instance.currentUser!.uid
                  ? GestureDetector(
                onTap: () {
                  productsListingController.removeListing(
                      widget.bookDetail['listingId'],
                      widget.bookDetail['sellerId'],
                      widget.bookDetail['productName']);
                },
                child: Obx(() {
                  return Center(
                    child: Container(
                      height: 58.h,
                      width: 250.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20.r)),
                      child: productsListingController.isLoading.value ==
                          true
                          ? Center(
                          child: CircularProgressIndicator(
                            color: whiteColor,
                          ))
                          : MontserratCustomText(
                        text: "Cancel This Listing",
                        textColor: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontsize: 16.sp,
                      ),
                    ),
                  );
                }),
              )
                  : userController.userPurchases
                  .contains(widget.bookDetail['listingId'])
                  ? Center(
                child: Container(
                  height: 58.h,
                  width: 250.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20.r)),
                  child: MontserratCustomText(
                    text: "Purchased", // Show purchased message
                    textColor: Colors.white,
                    fontWeight: FontWeight.w500,

                    fontsize: 16.sp,
                  ),
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await productsListingController
                          .createchatwithoutroffer(
                        widget.bookDetail['listingId'],
                        widget.bookDetail['sellerId'],
                        context,
                        widget.bookDetail['productName'],
                        widget.bookDetail['productPrice'],
                        widget.bookDetail['productImage'],
                        widget.bookDetail['brand'],
                      );
                    },
                    child: Obx(() {
                      return Container(
                        height: 58.h,
                        width: 155.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xffFFB9B9),
                            borderRadius: BorderRadius.circular(20.r)),
                        child:
                        productsListingController.offerLoadind.value ==
                            true
                            ? Center(
                            child: CircularProgressIndicator(
                              color: whiteColor,
                            ))
                            : MontserratCustomText(
                          text: 'Make offer',
                          textColor: primaryColor,
                          fontWeight: FontWeight.w500,
                          fontsize: 16.sp,
                        ),
                      );
                    }),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if(productsListingController.isLoading.value == false) {
                        await productsListingController.buyProduct(
                            widget.bookDetail['listingId'],
                            widget.bookDetail['sellerId'],
                            widget.bookDetail['brand'],
                            context,
                            widget.bookDetail['productName'],
                            widget.bookDetail['productPrice'],
                            widget.bookDetail['productImage']);
                      }

                    },
                    child: Obx(() {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 58.h,
                        width: 155.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius:
                            BorderRadius.circular(20.r)),
                        child: productsListingController
                            .isLoading.value ==
                            true
                            ? Center(
                            child: CircularProgressIndicator(
                              color: whiteColor,
                            ))
                            : MontserratCustomText(
                          text: 'Purchase',
                          textColor: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontsize: 16.sp,
                        ),
                      );
                    }),
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
