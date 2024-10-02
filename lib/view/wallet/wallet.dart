import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../const/assets/image_assets.dart';
import '../../const/assets/svg_assets.dart';
import '../../const/color.dart';
import '../../controller/home_controller.dart';
import '../../controller/sign_up_controller.dart';
import '../../controller/wallet_controller.dart';

import '../../helper/btc_address_validate.dart';
import '../../helper/stripe_payment.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_button.dart';

import '../../widgets/custom_text.dart';
import '../../widgets/custom_textfield.dart';


class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final HomeController homeController = Get.find<HomeController>();
  final WalletController walletController = Get.put(WalletController());
  final StripePaymentMethod stripePaymentMethod = StripePaymentMethod();
  final SignUpController signUpController = Get.find();

  late Stream<QuerySnapshot> transQuery;

  // Future<void> convertUsdToBtc() async {
  //   await walletController.fetchUserWallet();
  //
  //   final askPrice = await walletController.fetchBitcoinPrice();
  //   final newUsdBalance = walletController.btcBalance.value * askPrice;
  //   print("new usd btc amount ${newUsdBalance}");
  //
  //   walletController.walletbalance.value = newUsdBalance;
  //   print("new usd btc ask price ${askPrice}");
  // }
  //
  // Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transQuery = FirebaseFirestore.instance
        .collection('wallet')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('transaction')
        .orderBy('date', descending: true)
        .snapshots();
  }

  _asyncInitState() async {
    walletController.amountcontroller.clear();
    // // These two are not dependent and can run in parallel.
    // await Future.wait([
    //   walletController.fetchUserWallet(),
    // ]);
    // _timer?.cancel();
    // _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   if (walletController.isTopping.value == false) {
    //     convertUsdToBtc();
    //     print("timer p topping up");
    //   }
    // });
  }

  // @override
  // void dispose() {
  //   _timer?.cancel();
  //   super.dispose();
  // }

  // Given the type of transaction, determine the image icon.
  Image getImageForType(String type) {
    if (type == "deposit") {
      return Image.asset(
        AppImages.download,
        height: 40.h,
        width: 40.w,
      );
    } else if (type == "buy") {
      return Image.asset(
        AppImages.walmart,
        height: 40.h,
        width: 40.w,
      );
    } else if (type == "refund") {
      return Image.asset(
        AppImages.backbutton,
        height: 40.h,
        width: 40.w,
      );
    } else if (type == "sale") {
      return Image.asset(
        AppImages.sellMan,
        height: 40.h,
        width: 40.w,
      );
    } else if (type == "withdraw") {
      return Image.asset(
        AppImages.send,
        height: 40.h,
        width: 40.w,
      );
    }
    // Shouldn't get here!
    return Image.asset(
      AppImages.onlinedot,
      height: 40.h,
      width: 40.w,
    );
  }

  // Given the type of transaction, determine the message.
  String getDescriptionForType(String type, String productName) {
    if (type == "deposit") {
      return "Deposit";
    } else if (type == "buy") {
      return "Bought \"" + productName + "\"";
    } else if (type == "refund") {
      return "Refund for \"" + productName + "\"";
    } else if (type == "sale") {
      return "Sold \"" + productName + "\"";
    } else if (type == "withdraw") {
      return "Withdraw";
    }
    // Shouldn't get here!
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: CustomAppBar(
          homeController: homeController,
          text: 'Wallet',
        ),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 17.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            padding: EdgeInsets.only(top: 22.h, bottom: 11.h),
            width: 328.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: const LinearGradient(
                    colors: [primaryColor, primaryColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Column(
              children: [
                SoraCustomText(
                  text: 'Aed Balance',
                  textColor: whiteColor,
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                ),
                SizedBox(height: 5.h,),
                Obx(() {
                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "${walletController.walletbalance.value.toStringAsFixed(1)}",
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 25.sp,
                          ),
                        ),
                        TextSpan(
                          text: " AED",
                          style: TextStyle(
                            color:
                                whiteColor, // You can change the color here if needed
                            fontWeight: FontWeight.w400,
                            fontSize: 16
                                .sp, // You can set different size for AED if you want
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppIcons.topup),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r)),
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 20.w),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                      width: 30.w,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(4.r)),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    LexendCustomText(
                                      text: 'Deposit',
                                      fontWeight: FontWeight.w500,
                                      fontsize: 16.sp,
                                      textColor: const Color(0xff1E1E1E),
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    InputField(
                                      controller:
                                          walletController.amountcontroller,
                                      hint: 'Enter amount in Dirham (Aed)',
                                      keyboard: TextInputType.number,
                                      hintStyle: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.black54),
                                    ),
                                    SizedBox(
                                      height: 18.h,
                                    ),
                                    CustomButton(
                                        text: 'Next',
                                        onPressed: () async {
                                          signUpController.isLoading.value ==
                                                  false
                                              ? await stripePaymentMethod
                                                  .payment(walletController
                                                      .amountcontroller.text)
                                              : null;
                                          walletController.amountcontroller
                                              .clear();
                                          Navigator.pop(context);
                                        },
                                        backgroundColor: primaryColor,
                                        textColor: whiteColor),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Row(
                        children: [
                          SoraCustomText(
                            text: 'Add funds',
                            textColor: whiteColor,
                            fontWeight: FontWeight.w400,
                            fontsize: 12.sp,
                          ),
                          SizedBox(
                            width: 30.w,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        walletController.withdrawal.clear();
                        walletController.btcaddress.clear();

                        walletController.btcAddressValidation.value = false;
                        showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r)),
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 20.h),
                                  Container(
                                    width: 30.w,
                                    height: 4.h,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  LexendCustomText(
                                    text: 'Withdraw',
                                    fontWeight: FontWeight.w500,
                                    fontsize: 16.sp,
                                    textColor: const Color(0xff1E1E1E),
                                  ),
                                  SizedBox(height: 12.h),
                                  InputField(
                                    controller: walletController.withdrawal,
                                    hint: 'Enter amount in Dirham (Aed)',
                                    keyboard: TextInputType.number,
                                    hintStyle: TextStyle(
                                        fontSize: 16.sp, color: Colors.black54),
                                  ),
                                  SizedBox(height: 18.h),
                                  CustomButton(
                                    text: 'Next',
                                    onPressed: () async {
                                      final withdrawAmount = double.parse(
                                        walletController.withdrawal.text.trim(),
                                      );
                                      if (withdrawAmount <= 0) {
                                        Get.snackbar(
                                          'Invalid Amount',
                                          'The withdrawal amount cannot be zero.',
                                          backgroundColor: whiteColor,
                                          colorText: Colors.black,
                                        );
                                        Navigator.pop(context);

                                        return;
                                      }
                                      if (withdrawAmount >
                                          walletController
                                              .walletbalance.value) {
                                        Get.snackbar('Insufficient Balance',
                                            'Your wallet balance is too low for this withdrawal.',
                                            backgroundColor: whiteColor,
                                            colorText: Colors.black);
                                        Navigator.pop(context);
                                        return;
                                      }

                                      {


                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                          ),
                                          context: context,
                                          builder: (BuildContext context) {
                                            // _timer?.cancel();
                                            // _timer = Timer.periodic(
                                            //     Duration(seconds: 1),
                                            //     (timer) async {
                                            //   double btcPrice =
                                            //       await walletController
                                            //           .fetchBitcoinPrice();
                                            //   newBtcBalance.value =
                                            //       withdrawAmount / btcPrice;
                                            //   print("timer: ${newBtcBalance}");
                                            // });
                                            return Container(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom,
                                              ),
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
                                                  SizedBox(height: 20.h),
                                                  LexendCustomText(
                                                    text:
                                                        'Where to Send Bitcoin?',
                                                    fontWeight: FontWeight.w500,
                                                    fontsize: 16.sp,
                                                    textColor:
                                                        const Color(0xff1E1E1E),
                                                  ),
                                                  SizedBox(height: 12.h),
                                                  InputField(
                                                    controller: walletController
                                                        .btcaddress,
                                                    hint: 'Enter BTC address',
                                                    hintStyle: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Colors.black54,
                                                    ),
                                                    keyboard:
                                                        TextInputType.name,
                                                  ),
                                                  SizedBox(height: 18.h),
                                                  GestureDetector(
                                                    onTap: () {
                                                      // CustomRoute.navigateTo(
                                                      //     context,
                                                      //     QRViewExample1());
                                                    },
                                                    child: LexendCustomText(
                                                        text:
                                                            '[-] Or scan a QRCode',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontsize: 16.sp,
                                                        textColor: Colors.blue),
                                                  ),
                                                  SizedBox(height: 18.h),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      LexendCustomText(
                                                        text: 'Amount in USD:',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontsize: 16.sp,
                                                        textColor: const Color(
                                                            0xff000000),
                                                      ),
                                                      LexendCustomText(
                                                        text:
                                                            "\$${walletController.withdrawal.text}",
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontsize: 16.sp,
                                                        textColor: const Color(
                                                            0xff000000),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 18.h),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      LexendCustomText(
                                                        text: 'Amount in BTC:',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontsize: 16.sp,
                                                        textColor: const Color(
                                                            0xff000000),
                                                      ),
                                                      Obx(() {
                                                        return LexendCustomText(
                                                            text:
                                                                "\₿${walletController.btcBalance.value.toStringAsFixed(10)}",
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontsize: 16.sp,
                                                            textColor:
                                                                const Color(
                                                                    0xff000000));
                                                      }),
                                                    ],
                                                  ),
                                                  SizedBox(height: 18.h),
                                                  CustomButton(
                                                    onPressed: () {

                                                    },
                                                    text: 'Send Request',
                                                    // onPressed: () async {
                                                    //   if (walletController
                                                    //       .btcaddress.text
                                                    //       .trim()
                                                    //       .isEmpty) {
                                                    //     Get.snackbar(
                                                    //       'Invalid BTC Address',
                                                    //       'Please enter a valid BTC address.',
                                                    //       backgroundColor:
                                                    //           whiteColor,
                                                    //       colorText:
                                                    //           Colors.black,
                                                    //     );
                                                    //     return;
                                                    //   }
                                                    //
                                                    //   Address btcaddress =
                                                    //       await validate(
                                                    //           walletController
                                                    //               .btcaddress
                                                    //               .text);
                                                    //   print(
                                                    //       "Btc address $btcaddress");
                                                    //   print(walletController
                                                    //       .btcAddressValidation
                                                    //       .value);
                                                    //   if (walletController
                                                    //           .btcAddressValidation
                                                    //           .value ==
                                                    //       true) {
                                                    //     signUpController
                                                    //         .isLoading
                                                    //         .value = true;
                                                    //  // await walletController.recordWithdrawal(withdrawAmount, walletController.btcaddress.value.text);
                                                    //     signUpController
                                                    //         .isLoading
                                                    //         .value = false;
                                                    //     walletController
                                                    //         .btcaddress
                                                    //         .clear();
                                                    //     walletController
                                                    //         .withdrawal
                                                    //         .clear();
                                                    //     Navigator.pop(context);
                                                    //     Navigator.pop(context);
                                                    //
                                                    //     Get.dialog(
                                                    //       AlertDialog(
                                                    //         title: Text(
                                                    //             'Withdraw Request'),
                                                    //         content: Text(
                                                    //           'Your request has been submitted. Withdrawal will be processed within 24 hours.',
                                                    //         ),
                                                    //       ),
                                                    //     );
                                                    //   }
                                                    // },
                                                    backgroundColor:
                                                        primaryColor,
                                                    textColor: whiteColor,
                                                  ),
                                                  SizedBox(height: 20.h),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                    backgroundColor: primaryColor,
                                    textColor: whiteColor,
                                  ),
                                  SizedBox(height: 20.h),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SoraCustomText(
                            text: 'Withdraw',
                            textColor: whiteColor,
                            fontWeight: FontWeight.w400,
                            fontsize: 12.sp,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 61.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SoraCustomText(
                  text: 'Latest Transactions',
                  textColor: darkColor,
                  fontWeight: FontWeight.w600,
                  fontsize: 14.sp,
                ),
                SizedBox(
                  height: 5.h,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: transQuery,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.white,
                          child: Container(
                            height: 50.h,
                            width: 320.w,
                            margin: EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 36.w),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(9.89.r)),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(9.89.r),
                                          bottomLeft: Radius.circular(9.89.r)),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    FittedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 3.h,
                                          ),
                                          SizedBox(
                                              width: 214.w,
                                              child: MontserratCustomText(
                                                text: "books[",
                                                fontsize: 16.sp,
                                                textColor: textColor,
                                                fontWeight: FontWeight.w600,
                                                height: 1,
                                              )),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          SizedBox(
                                            width: 214.w,
                                            child: MontserratCustomText(
                                                text: '',
                                                fontsize: 12.sp,
                                                textColor: mainTextColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 14.h,
                                          ),
                                          MontserratCustomText(
                                            text: '',
                                            fontsize: 10.sp,
                                            textColor: mainTextColor,
                                            fontWeight: FontWeight.w600,
                                            height: 1.h,
                                          ),
                                          SizedBox(
                                            height: 14.h,
                                          ),
                                          MontserratCustomText(
                                              text: '',
                                              fontsize: 8.sp,
                                              textColor: mainTextColor,
                                              fontWeight: FontWeight.w600),
                                          SizedBox(
                                            height: 3.h,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  width: 71.w,
                                  height: 29.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.r),
                                          bottomRight: Radius.circular(10.r))),
                                  child: MontserratCustomText(
                                    text: "",
                                    textColor: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontsize: 14.sp,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return ListView.builder(
                            itemCount: 3,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.white,
                                child: Container(
                                  height: 50.h,
                                  width: 320.w,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8.h, horizontal: 36.w),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(9.89.r)),
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    Radius.circular(9.89.r),
                                                bottomLeft:
                                                    Radius.circular(9.89.r)),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          FittedBox(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                                SizedBox(
                                                    width: 214.w,
                                                    child: MontserratCustomText(
                                                      text: "books[",
                                                      fontsize: 16.sp,
                                                      textColor: textColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1,
                                                    )),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                SizedBox(
                                                  width: 214.w,
                                                  child: MontserratCustomText(
                                                      text: '',
                                                      fontsize: 12.sp,
                                                      textColor: mainTextColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: 14.h,
                                                ),
                                                MontserratCustomText(
                                                  text: '',
                                                  fontsize: 10.sp,
                                                  textColor: mainTextColor,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.h,
                                                ),
                                                SizedBox(
                                                  height: 14.h,
                                                ),
                                                // MontserratCustomText(
                                                //     text:
                                                //     "Class: ${books['bookClass']}",
                                                //     fontsize: 8.sp,
                                                //     textColor: mainTextColor,
                                                //     fontWeight: FontWeight.w600),
                                                MontserratCustomText(
                                                    text: '',
                                                    fontsize: 8.sp,
                                                    textColor: mainTextColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        width: 71.w,
                                        height: 29.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.r),
                                                bottomRight:
                                                    Radius.circular(10.r))),
                                        child: MontserratCustomText(
                                          text: "",
                                          textColor: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontsize: 14.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                      // else if (snapshot.data!.docs.isEmpty) {
                      //   return Column(
                      //     children: [
                      //       SizedBox(
                      //         height: 150.h,
                      //       ),
                      //       Center(
                      //         child: Text("No Transactions"),
                      //       ),
                      //     ],
                      //   );
                      // }
                      print('snapshot.data!.docs,${snapshot.data!.docs}');

                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            String time = walletController
                                .formattransactionTime(item['date']);
                            String productName = item.containsKey('purchaseName')
                                ? item['purchaseName']
                                : "";

                            return GestureDetector(
                              onTap: () {
                                // Get.to(WalletDetails(
                                //     transaction: snapshot.data!.docs[index].data() as Map<String, dynamic>));
                              },
                              child: ListTile(
                                horizontalTitleGap: 8,
                                contentPadding: EdgeInsets.zero,
                                leading: getImageForType(item['type'].toString()),
                                title: SoraCustomText(
                                  text: getDescriptionForType(
                                      item['type'].toString(), productName),
                                  textColor: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontsize: 12.sp,
                                ),
                                subtitle: SoraCustomText(
                                  text: time,
                                  textColor: lightDarkColor,
                                  fontWeight: FontWeight.w400,
                                  fontsize: 12.sp,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SoraCustomText(
                                      text:
                                          "+\$${item['price'].toStringAsFixed(1)}",
                                      textColor: greenColor,
                                      fontWeight: FontWeight.w400,
                                      fontsize: 12.sp,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    SvgPicture.asset(AppIcons.arrowIcon)
                                  ],
                                ),
                              ),
                            );
                          });
                    })
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          )
        ])));
  }
}
