import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:reclaim_firebase_app/controller/productsListing_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../const/color.dart';
import '../../controller/chat_controller.dart';
import '../../controller/home_controller.dart';
import '../../controller/paymentController.dart';
import '../../controller/user_controller.dart';
import '../../helper/paypal_payment.dart';
import '../../helper/stripe_payment.dart';
import '../../helper/stripe_purchasing.dart';
import '../../widgets/custom _backbutton.dart';
import '../../widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../widgets/payment_method.dart';

class BookDetailsScreen extends StatefulWidget {
  final dynamic bookDetail;
  final int index;
  final bool comingfromSellScreen;

  const BookDetailsScreen(
      {super.key,
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
  final StripePaymentPurchasing stripePaymentPurchasing =
      StripePaymentPurchasing();

  String selectedPayment = '';

  final List<Map<String, dynamic>> payments = [
    {
      'name': 'Stripe',
      'logo': Icons.account_balance,
      'checked': true,
    },
    {
      'name': 'Paypal',
      'logo': Icons.account_balance_wallet,
      'checked': false,
    },
    {
      'name': 'Apple card',
      'logo': Icons.account_balance_outlined,
      'checked': false,
    },
  ];
  @override
  void initState() {
    // TODO: implement initState
    chatController.getorderId(widget.bookDetail['listingId']);

    productsListingController.getSellerData(widget.bookDetail['sellerId']);
    super.initState();
  }

  final PageController _pageController = PageController();
  final List<String> items = [
    'Size UK 14',
    'Women',
    'Barely Used',
    'TopShop',
    'Open for negotiation',
  ];
  @override
  void dispose() {
    _pageController.dispose(); // Dispose the controller when done
    super.dispose();
  }

  void showPaymentBottomSheet(BuildContext context) {
    Get.bottomSheet(
      GetBuilder<PaymentController>(
        init: PaymentController(), // Initialize the controller
        builder: (controller) {
          return Container(
            height: 400,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.payments.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: controller.selectedPayment ==
                            controller.payments[index]['name']
                        ? primaryColor
                        : primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: controller.selectedPayment ==
                              controller.payments[index]['name']
                          ? Colors.transparent
                          : primaryColor,
                    ),
                  ),
                  child: RadioListTile<String>(
                    value: controller.payments[index]['name']!,
                    groupValue: controller.selectedPayment,
                    onChanged: (String? value) {
                      controller
                          .selectPayment(value!); // Update the selected payment
                    },
                    title: Row(
                      children: [
                        Text(
                          controller.payments[index]['name']!,
                          style: TextStyle(
                            color: controller.selectedPayment ==
                                    controller.payments[index]['name']
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    activeColor: Colors.white,
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> productImages = widget.bookDetail['productImages'];
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
                  child: const CustomBackButton(),
                ),
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 400.h,
                        width: 275.w,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: productImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: productImages[index],
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: imageProvider,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Center(
                                  child: Icon(Icons.error),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: productImages.length,
                        effect: ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: primaryColor,
                          dotColor: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
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
                              child:
                                  productsListingController.isLoading.value ==
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
                    : Obx(
                        () => userController.userPurchases
                                .contains(widget.bookDetail['listingId'])
                            ? Center(
                                child: Container(
                                  height: 58.h,
                                  width: 250.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(20.r)),
                                  child: MontserratCustomText(
                                    text: "Purchased", // Show purchased message
                                    textColor: Colors.white,
                                    fontWeight: FontWeight.w500,

                                    fontsize: 16.sp,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        widget.bookDetail['productImages'][0],
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
                                            borderRadius:
                                                BorderRadius.circular(20.r)),
                                        child: productsListingController
                                                    .offerLoadind.value ==
                                                true
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
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
                                    onTap: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return GetBuilder<PaymentController>(
                                            init:
                                                PaymentController(), // Initialize the controller
                                            builder: (controller) {
                                              return Container(
                                                height: Get.height * 0.6,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                                width: double.infinity,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(height: 20.h),
                                                    Container(
                                                      width: 30.w,
                                                      height: 4.h,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.r),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    MontserratCustomText(
                                                      text: 'Payment Methods',
                                                      textColor: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontsize: 16.sp,
                                                    ),
                                                    SizedBox(height: 50.h),

                                                    // Payment method ListView.builder inside the BottomSheet
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: controller
                                                          .payments.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                            vertical: 4.h,
                                                            horizontal: 12.w,
                                                          ),
                                                          padding:
                                                              EdgeInsets.all(4),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: controller
                                                                        .selectedPayment ==
                                                                    controller.payments[
                                                                            index]
                                                                        ['name']
                                                                ? primaryColor
                                                                : primaryColor
                                                                    .withOpacity(
                                                                        0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                              color: controller
                                                                          .selectedPayment ==
                                                                      controller
                                                                              .payments[index]
                                                                          [
                                                                          'name']
                                                                  ? Colors
                                                                      .transparent
                                                                  : primaryColor,
                                                            ),
                                                          ),
                                                          child: RadioListTile<
                                                              String>(
                                                            value: controller
                                                                    .payments[
                                                                index]['name']!,
                                                            groupValue: controller
                                                                .selectedPayment,
                                                            onChanged: (String?
                                                                value) {
                                                              controller
                                                                  .selectPayment(
                                                                      value!);
                                                            },
                                                            title: Text(
                                                              controller.payments[
                                                                      index]
                                                                  ['name']!,
                                                              style: TextStyle(
                                                                color: controller
                                                                            .selectedPayment ==
                                                                        controller.payments[index]
                                                                            [
                                                                            'name']
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            activeColor:
                                                                Colors.white,
                                                            controlAffinity:
                                                                ListTileControlAffinity
                                                                    .trailing,
                                                          ),
                                                        );
                                                      },
                                                    ),

                                                    Spacer(),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        Navigator.pop(context);
                                                        // Navigate based on the selected payment method
                                                        if (controller
                                                                .selectedPayment ==
                                                            controller
                                                                    .payments[0]
                                                                ['name']) {
                                                          await stripePaymentPurchasing.paymentPurchasing(
                                                              widget.bookDetail[
                                                                      'productPrice']
                                                                  .toString(),
                                                              widget.bookDetail[
                                                                  'listingId'],
                                                              widget.bookDetail[
                                                                  'sellerId'],
                                                              widget.bookDetail[
                                                                  'brand'],
                                                              context,
                                                              widget.bookDetail[
                                                                  'productName'],
                                                              widget.bookDetail[
                                                                  'productPrice'],
                                                              widget.bookDetail[
                                                                  'productImages'][0],
                                                              true,
                                                              {});
                                                          // Get.back();
                                                        } else if (controller
                                                                .selectedPayment ==
                                                            controller
                                                                    .payments[1]
                                                                ['name']) {
                                                          // Navigate to PayPal screen
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PaypalPayment(
                                                                          amount: widget
                                                                              .bookDetail['productPrice']
                                                                              .toString(),
                                                                        )),
                                                          );
                                                        } else if (controller
                                                                .selectedPayment ==
                                                            controller
                                                                    .payments[2]
                                                                ['name']) {
                                                          print('wallet');
                                                          await productsListingController.buyProductWithWallet(
                                                              widget.bookDetail[
                                                                  'listingId'],
                                                              widget.bookDetail[
                                                                  'sellerId'],
                                                              widget.bookDetail[
                                                                  'brand'],
                                                              context,
                                                              widget.bookDetail[
                                                                  'productName'],
                                                              widget.bookDetail[
                                                                  'productPrice'],
                                                              widget.bookDetail[
                                                                      'productImages']
                                                                  [0]);

                                                          // Navigate to PayPal screen
                                                          // Navigator.push(
                                                          //   context,
                                                          //   MaterialPageRoute(builder: (context) => PayPalScreen()),
                                                          // );
                                                        } else {
                                                          // Handle other payment methods if necessary
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        height: 58.h,
                                                        width: 300.w,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.r),
                                                        ),
                                                        child:
                                                            MontserratCustomText(
                                                          text: 'Continue',
                                                          textColor:
                                                              Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontsize: 16.sp,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 30.h),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Obx(() {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        height: 58.h,
                                        width: 155.w,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                        child: productsListingController
                                                    .isLoading.value ==
                                                true
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
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
                      )),
            SizedBox(
              height: 10.h,
            )
          ],
        ),
      ),
    );
  }
}
