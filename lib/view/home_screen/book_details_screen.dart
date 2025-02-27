import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController addressController = TextEditingController();

  String selectedPayment = '';

  final List<Map<String, dynamic>> payments = [
    {
      'name': 'Card Payment',
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

  // Remote and Outer Areas
  final List<String> remoteAreas = [
    "Ghayathi", "Bad Al Matawa", "Al Nadra", "Al Hmara", "Baraka", "Al Sila",
    "Madinat Zayed", "Habshan", "Bainuana", "Liwa", "Asab", "Hameem",
    "Ruwais", "Mirfa", "Abu Al Bayad", "Al Hamra", "Jabel Al Dhani"
  ];

  final List<String> outerAreas = [
    "DXB- Hatta", "SHJ -Lehbab", "AJM- Masfout", "RAK- Wadi Al Shiji",
    "DXB- Nazwa", "RAK-Al Shawka", "SHJ-Madam",
    "Nahi", "Sawehan", "Al Dahra", "Al Qua", "Al Wagan"
  ];

  // Pricing
  final double remotePrice = 41.52;
  final double outerAreaPrice = 28.56;
  final double standardPrice = 17.36;

  String? selectedCategory;
  String? selectedArea;

  @override
  void initState() {
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
    _pageController.dispose();
    addressController.dispose(); // Dispose the controller
    super.dispose();
  }

  void showPaymentBottomSheet(BuildContext context) {
    Get.bottomSheet(
      GetBuilder<PaymentController>(
        init: PaymentController(),
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
                      controller.selectPayment(value!);
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

  void showDeliveryBottomSheet(BuildContext context, controller) {
    TextEditingController addressController = TextEditingController();
    double? deliveryPrice;
    String detectedArea = "Standard Area"; // Default area type

    // Function to check if the input matches a city in remote or outer areas
    void checkAddress(String input, StateSetter setModalState) {
      String lowerCaseAddress = input.toLowerCase();
      double newPrice = standardPrice;
      String newArea = "Standard Area";

      for (String area in remoteAreas) {
        if (lowerCaseAddress.contains(area.toLowerCase())) {
          newPrice = remotePrice;
          newArea = "Remote Area";
          break;
        }
      }

      for (String area in outerAreas) {
        if (lowerCaseAddress.contains(area.toLowerCase())) {
          newPrice = outerAreaPrice;
          newArea = "Outer Area";
          break;
        }
      }

      setModalState(() {
        deliveryPrice = newPrice;
        detectedArea = newArea;
      });
    }

    // Fetch address from Firestore
    void fetchUserAddress(StateSetter setModalState) async {
      try {
        String? userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId == null) {
          Get.snackbar("Error", "User not logged in");
          return;
        }

        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('userDetails')
            .doc(userId)
            .get();

        if (doc.exists) {
          String? address = doc.get('Address');
          if (address != null) {
            addressController.text = address;
            checkAddress(address, setModalState); // Update UI with fetched address
          }
        }
      } catch (e) {
        print("Error fetching address: $e");
        Get.snackbar("Error", "Failed to fetch address");
      }
    }

    Get.bottomSheet(
      isDismissible: true,
      enableDrag: true,
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            if (addressController.text.isEmpty) {
              fetchUserAddress(setModalState);
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Center(
                    child: Text(
                      "Enter Delivery Address",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Address Input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        labelText: "Delivery Address",
                        hintText: "e.g., Street 12, Ghayathi, Dubai",
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Icon(Icons.location_on, color: primaryColor),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                      ),
                      onChanged: (value) => checkAddress(value, setModalState),
                    ),
                  ),
                  SizedBox(height: 15.h),

                  // Detected Area
                  Text(
                    "Detected Area: $detectedArea",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Price Breakdown Card
                  if (deliveryPrice != null)
                    Container(
                      padding: EdgeInsets.all(15.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPriceRow(
                            "Subtotal",
                            widget.bookDetail['productPrice'].toStringAsFixed(2),
                          ),
                          SizedBox(height: 12.h),
                          _buildPriceRow(
                            "Service Charge (10%)",
                            (widget.bookDetail['productPrice'] * 0.10).toStringAsFixed(2),
                          ),
                          SizedBox(height: 12.h),
                          _buildPriceRow(
                            "Delivery",
                            deliveryPrice!.toStringAsFixed(2),
                          ),
                          SizedBox(height: 15.h),
                          Divider(color: Colors.grey[300]),
                          SizedBox(height: 15.h),
                          _buildPriceRow(
                            "Total",
                            (widget.bookDetail['productPrice'] +
                                (widget.bookDetail['productPrice'] * 0.10) +
                                deliveryPrice!).toStringAsFixed(2),
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 25.h),

                  // Pay Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        if (addressController.text.isEmpty) {
                          Get.snackbar("Error", "Please enter a valid address");
                          return;
                        }
                        if (deliveryPrice == null) {
                          Get.snackbar("Error", "Unable to determine delivery price");
                          return;
                        }

                        print("Delivery Price: AED $deliveryPrice");

                        // Payment logic remains same
                        if (controller.selectedPayment == controller.payments[0]['name']) {
                          await stripePaymentPurchasing.paymentPurchasing(
                            widget.bookDetail['productPrice'].toString(),
                            widget.bookDetail['listingId'],
                            widget.bookDetail['sellerId'],
                            widget.bookDetail['brand'],
                            context,
                            widget.bookDetail['productName'],
                            widget.bookDetail['productPrice'],
                            widget.bookDetail['productImages'][0],
                            true,
                            {},
                            deliveryPrice!,
                            addressController.text,
                          );
                        } else if (controller.selectedPayment == controller.payments[1]['name']) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaypalPayment(
                                amount: widget.bookDetail['productPrice'].toString(),
                              ),
                            ),
                          );
                        } else if (controller.selectedPayment == controller.payments[2]['name']) {
                          await productsListingController.buyProductWithWallet(
                            widget.bookDetail['listingId'],
                            widget.bookDetail['sellerId'],
                            widget.bookDetail['brand'],
                            context,
                            widget.bookDetail['productName'],
                            widget.bookDetail['productPrice'],
                            widget.bookDetail['productImages'][0],
                            deliveryPrice!,
                            addressController.text,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        "Confirm Payment",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

// Helper method for price rows
  }
  Widget _buildPriceRow(String label, String price, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? primaryColor : Colors.grey[700],
          ),
        ),
        Text(
          "$price AED",
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? primaryColor : Colors.grey[700],
          ),
        ),
      ],
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
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: CustomBackButton(),
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
                                errorWidget: (context, url, error) => const Center(
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
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InterCustomText(
                            text: widget.bookDetail['brand'],
                            textColor: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontsize: 20.sp,
                          ),
                          InterCustomText(
                            text: '${widget.bookDetail['productPrice']} Aed',
                            textColor: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontsize: 18.sp,
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      InterCustomText(
                        text: widget.bookDetail['productName'],
                        textColor: const Color(0xff9B9B9B),
                        fontWeight: FontWeight.w400,
                        fontsize: 16.sp,
                      ),
                      SizedBox(height: 14.h),
                      Wrap(
                        spacing: 3,
                        runSpacing: 10,
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
                                      : primaryColor.withOpacity(0.10),
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
                      SizedBox(height: 9.h),
                      InterCustomText(
                        text: widget.bookDetail['Description'],
                        textColor: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontsize: 20.sp,
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InterCustomText(
                            text:
                            'There is a maximum weight limit of 5kg for\ndelivery anything over must be organised\nbetween the buyer and seller',
                            textColor: Colors.grey,
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
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
                        borderRadius: BorderRadius.circular(20.r)),
                    child: MontserratCustomText(
                      text: "Purchased",
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
                              color: const Color(0xffFFB9B9),
                              borderRadius:
                              BorderRadius.circular(20.r)),
                          child: productsListingController
                              .offerLoadind.value ==
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
                              init: PaymentController(),
                              builder: (controller) {
                                return Container(
                                  height: Get.height * 0.6,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.w),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 20.h),
                                      Container(
                                        width: 30.w,
                                        height: 4.h,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                          BorderRadius.circular(
                                              4.r),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      MontserratCustomText(
                                        text: 'Payment Methods',
                                        textColor: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontsize: 16.sp,
                                      ),
                                      SizedBox(height: 50.h),
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
                                                  controller
                                                      .payments[
                                                  index]['name']
                                                  ? primaryColor
                                                  : primaryColor
                                                  .withOpacity(
                                                  0.1),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(10),
                                              border: Border.all(
                                                color: controller
                                                    .selectedPayment ==
                                                    controller
                                                        .payments[index]
                                                    ['name']
                                                    ? Colors
                                                    .transparent
                                                    : primaryColor,
                                              ),
                                            ),
                                            child:
                                            RadioListTile<String>(
                                              value: controller
                                                  .payments[
                                              index]['name']!,
                                              groupValue: controller
                                                  .selectedPayment,
                                              onChanged:
                                                  (String? value) {
                                                controller
                                                    .selectPayment(
                                                    value!);
                                              },
                                              title: Text(
                                                controller
                                                    .payments[
                                                index]['name']!,
                                                style: TextStyle(
                                                  color: controller
                                                      .selectedPayment ==
                                                      controller
                                                          .payments[index]
                                                      ['name']
                                                      ? Colors.white
                                                      : Colors.black,
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
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          showDeliveryBottomSheet(
                                              context, controller);
                                        },
                                        child: Container(
                                          padding:
                                          EdgeInsets.symmetric(
                                              horizontal: 10),
                                          height: 58.h,
                                          width: 300.w,
                                          alignment:
                                          Alignment.center,
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                            BorderRadius
                                                .circular(20.r),
                                          ),
                                          child:
                                          MontserratCustomText(
                                            text: 'Continue',
                                            textColor: Colors.white,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10),
                          height: 58.h,
                          width: 155.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius:
                            BorderRadius.circular(20.r),
                          ),
                          child:
                          productsListingController.isLoading.value ==
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
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
