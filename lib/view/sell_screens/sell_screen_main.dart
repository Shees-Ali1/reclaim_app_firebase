
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:reclaim_firebase_app/helper/loading.dart';


import '../../const/assets/image_assets.dart';
import '../../const/assets/svg_assets.dart';
import '../../const/color.dart';

import '../../controller/home_controller.dart';
import '../../controller/user_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_route.dart';
import '../../widgets/custom_text.dart';
import '../home_screen/book_details_screen.dart';
import '../notification/notification_screen.dart';
import 'book_sell_screen.dart';
import 'list_sell_book_screen.dart';

class SellScreenMain extends StatefulWidget {
  const SellScreenMain({super.key});

  @override
  State<SellScreenMain> createState() => _SellScreenMainState();
}

class _SellScreenMainState extends State<SellScreenMain> {

  final HomeController homeController = Get.find<HomeController>();
  final UserController userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: CustomAppBar(
          homeController: homeController,
          text: 'Listed Items',
        ),
        body: Obx(() => productsListingController.isLoading.value == false?SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Obx(() => productsListingController.mySellListings.isEmpty
                    ? Column(
                  children: [
                    SizedBox(
                      height: 66.h,
                    ),
                    InterCustomText(
                      text: 'No items listed for sale',
                      textColor: lightBlackColor,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    SizedBox(
                      height: 223.h,
                      width: 186.w,
                      child: Image.asset(AppImages.sellMan,color: primaryColor,),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        // userController.verified.value == true
                        //     ?
                        Get.to(
                          const ListSellBookScreen(
                            comingFromEdit: false,
                          ),
                          transition: Transition.fade,
                          duration:
                          const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                        //     : Get.snackbar('Your Profile is UnderReview',
                        //                    'Wait for Admin Approval',
                        //                    colorText: Colors.black,
                        //                    backgroundColor: Colors.white
                        // );
                      },
                      child: Container(
                          height: 39.h,
                          width: 205.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8.r)),
                          child: FittedBox(
                              child: InterCustomText(
                                text: "Sell your first product here!",
                                textColor: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontsize: 14.sp,
                              ))),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    SizedBox(
                      height: 18.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 36.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                const ListSellBookScreen(),
                                transition: Transition.fade,
                                duration:
                                const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                            },
                            child: Container(
                                height: 39.h,
                                width: 142.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius:
                                    BorderRadius.circular(8.r)),
                                child: FittedBox(
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        InterCustomText(
                                          text: "Add new Book",
                                          textColor: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontsize: 14.sp,
                                        ),
                                      ],
                                    ))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    ListView.builder(
                        clipBehavior: Clip.none,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                        productsListingController.mySellListings.length,
                        itemBuilder: (context, index) {
                          final books =
                          productsListingController.mySellListings[index];
                          return GestureDetector(
                              onTap: () {
                                Get.to(
                                  BookDetailsScreen(
                                    index: index,
                                    comingfromSellScreen: true,
                                    bookDetail: '',
                                    // bookDetail: books,
                                    // index: index,
                                    // comingfromSellScreen: true,
                                  ),
                                  transition: Transition.fade,
                                  duration:
                                  const Duration(milliseconds: 500),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: 125.23.h,
                                    width: 303.w,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 36.w),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          books['approval'] == true
                                              ? BoxShadow(
                                              color: shadowColor,
                                              blurRadius: 20,
                                              offset: Offset(0, 4.h))
                                              : const BoxShadow(
                                            color:
                                            Colors.transparent,
                                            // blurRadius: 20,
                                            // offset: Offset(0, 4.h)
                                          )
                                        ],
                                        borderRadius:
                                        BorderRadius.circular(
                                            9.89.r)),
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                              BorderRadius.only(
                                                  topLeft:
                                                  Radius.circular(
                                                      9.89.r),
                                                  bottomLeft: Radius
                                                      .circular(
                                                      9.89.r)),
                                              child: SizedBox(
                                                height: 125.23.h,
                                                width: 77.w,
                                                child:
                                                books['bookImage'] !=
                                                    ''
                                                    ? Image.network(
                                                  books['bookImage']
                                                      .toString(),
                                                  fit: BoxFit
                                                      .cover,
                                                )
                                                    : Container(
                                                  color: Colors
                                                      .red,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            FittedBox(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  SizedBox(
                                                    height: 3.h,
                                                  ),
                                                  SizedBox(
                                                      width: 214.w,
                                                      child:
                                                      MontserratCustomText(
                                                        text: books[
                                                        'bookName'],
                                                        fontsize: 16.sp,
                                                        textColor:
                                                        const Color(
                                                            0xff393939),
                                                        fontWeight:
                                                        FontWeight
                                                            .w600,
                                                        height: 1,
                                                      )),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  SizedBox(
                                                    width: 180.w,
                                                    child: MontserratCustomText(
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        text: books[
                                                        'bookPart'] ??
                                                            '',
                                                        fontsize: 10.sp,
                                                        textColor:
                                                        mainTextColor,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600),
                                                  ),
                                                  SizedBox(
                                                    height: 14.h,
                                                  ),
                                                  MontserratCustomText(
                                                    text:
                                                    "Author: ${books['bookAuthor']}",
                                                    fontsize: 10.sp,
                                                    textColor:
                                                    mainTextColor,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    height: 1.h,
                                                  ),
                                                  SizedBox(
                                                    height: 14.h,
                                                  ),
                                                  MontserratCustomText(
                                                      text:
                                                      "Class: ${books['bookClass']}",
                                                      fontsize: 8.sp,
                                                      textColor:
                                                      mainTextColor,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600),
                                                  MontserratCustomText(
                                                      text:
                                                      "Condition: ${books['bookClass']}",
                                                      fontsize: 8.sp,
                                                      textColor:
                                                      mainTextColor,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600),
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
                                              borderRadius: BorderRadius
                                                  .only(
                                                  topLeft:
                                                  Radius.circular(
                                                      10.r),
                                                  bottomRight:
                                                  Radius.circular(
                                                      10.r))),
                                          child: MontserratCustomText(
                                            text:
                                            "\$${books['bookPrice'].toString()}",
                                            textColor: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontsize: 14.sp,
                                          ),
                                        ),
                                        Positioned(
                                            top: 0.h,
                                            bottom: 25.h,
                                            right: 3.h,
                                            child: GestureDetector(
                                                onTap: () {
                                                  CustomRoute.navigateTo(
                                                      context,
                                                      ListSellBookScreen(
                                                        bookImage: books[
                                                        'bookImage'],
                                                        title: books[
                                                        'bookName'],
                                                        bookPart: books[
                                                        'bookPart'],
                                                        author: books[
                                                        'bookAuthor'],
                                                        bookClass: books[
                                                        'bookClass'],
                                                        bookCondition: books[
                                                        'bookCondition'],
                                                        bookPrice: books[
                                                        'bookPrice'],
                                                        listingId: books[
                                                        'listingId'],
                                                        comingFromEdit:
                                                        true,
                                                      ));
                                                },
                                                child: SizedBox(
                                                  height: 24.h,
                                                  width: 24.w,
                                                  child: SvgPicture.asset(
                                                    AppIcons.editIcon,
                                                    color: primaryColor,
                                                  ),
                                                )))
                                      ],
                                    ),
                                  ),
                                  books['approval'] == false
                                      ? Container(
                                    alignment: Alignment.bottomLeft,
                                    height: 125.23.h,
                                    width: 303.w,
                                    padding:
                                    EdgeInsets.only(left: 11.w),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 8.h,
                                        horizontal: 36.w),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          9.89.r),
                                      color: blackShadeColor
                                          .withOpacity(0.6),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        SizedBox(
                                            height: 48.h,
                                            width: 47.w,
                                            child: Image.asset(
                                              AppImages
                                                  .approvalPending,
                                              color: Colors.white,
                                            )),
                                        InterCustomText(
                                          text: 'Pending\nApproval',
                                          textColor: Colors.white,
                                          fontWeight:
                                          FontWeight.w500,
                                          fontsize: 12.sp,
                                          textAlign:
                                          TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                        ),
                                      ],
                                    ),
                                  )
                                      : const SizedBox.shrink(),
                                ],
                              ));
                        }),
                  ],
                ))
              ],
            ),
          ),
        ):Center(child: CircularProgressIndicator(color: primaryColor,))));
  }
}
