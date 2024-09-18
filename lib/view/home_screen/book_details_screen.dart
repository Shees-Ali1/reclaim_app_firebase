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
  const BookDetailsScreen({
    super.key,
    required this.bookDetail,
    required this.index,
    required this.comingfromSellScreen
  });

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
                              image:NetworkImage(widget.bookDetail['productImage'])))),
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
                            text: widget.bookDetail['productName'], // Product name
                            textColor: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontsize: 20.sp,
                          ),
                          InterCustomText(
                            text: '${widget.bookDetail['productPrice']} Aed', // Product price
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
