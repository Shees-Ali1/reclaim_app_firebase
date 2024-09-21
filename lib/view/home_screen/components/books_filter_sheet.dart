import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reclaim_firebase_app/controller/productsListing_controller.dart';

import '../../../const/color.dart';
import '../../../controller/home_controller.dart';
import '../../../widgets/custom_text.dart';
import '../../sell_screens/list_sell_book_screen.dart';

class BooksFilterBottomSheet extends StatefulWidget {
  const BooksFilterBottomSheet({super.key});

  @override
  State<BooksFilterBottomSheet> createState() => _BooksFilterBottomSheetState();
}

class _BooksFilterBottomSheetState extends State<BooksFilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final ProductsListingController productsListingController = Get.find<ProductsListingController>();

    final List<String> sizes = [
      'All',
      '3XS',
      '2XS',
      'XS',
      'S',
      'M',
      'L',
      'XL',
      '2XL',
      '3XL',
      '4XL',
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 4.h,
                width: 50.w,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(
                "Filter",
                style: GoogleFonts.lato(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  homeController.priceSliderValue.value = 0.0;
                  homeController.selectedCondition.value = "All";
                  productsListingController.category.value = "All";
                  homeController.selectedSize.value = "All";
                  homeController.sliderValue.value = 0.0;homeController.selectedindex.value =0;
                  homeController.filterredProduct.assignAll(homeController.mainProductlist);

                  print(homeController.mainProductlist.value);


                   Get.back();

                },
                child: Container(
                  width: 68.w,
                  height: 42.h,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(35.r),
                  ),
                  child: Center(
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          LatoCustomText(
            text: 'Sizes',
            textColor: primaryColor,
            fontWeight: FontWeight.w700,
            fontsize: 18.sp,
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: sizes.map((size) {
              return GestureDetector(
                onTap: () {
                  homeController.selectedSize.value = size;
                },
                child: Obx(() => Container(
                      width: 47.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: size == homeController.selectedSize.value
                              ? Colors.transparent
                              : primaryColor,
                          width: size == homeController.selectedSize.value
                              ? 2.w
                              : 1.w,
                        ),
                        color: size == homeController.selectedSize.value
                            ? primaryColor
                            : Colors.transparent,
                      ),
                      child: Center(
                        child: MontserratCustomText(
                          text: size,
                          textColor: size == homeController.selectedSize.value
                              ? Colors.white
                              : primaryColor,
                          fontWeight: FontWeight.w400,
                          fontsize: 15.sp,
                        ),
                      ),
                    )),
              );
            }).toList(),
          ),
          SizedBox(height: 11.h),
          LatoCustomText(
            text: 'Condition',
            textColor: primaryColor,
            fontWeight: FontWeight.w700,
            fontsize: 18.sp,
          ),
          SizedBox(height: 11.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(() => ConditionContainer(
                    condtionText: 'All',
                    onTap: () {
                      homeController.selectedCondition.value = "All";
                    },
                    color: homeController.selectedCondition.value == "All"
                        ? primaryColor
                        : primaryColor.withOpacity(0.08),
                    textcolor: homeController.selectedCondition.value == "All"
                        ? Colors.white
                        : primaryColor,
                  )),
              Obx(() => ConditionContainer(
                    condtionText: 'New',
                    onTap: () {
                      homeController.selectedCondition.value = "New";
                    },
                    color: homeController.selectedCondition.value == "New"
                        ? primaryColor
                        : primaryColor.withOpacity(0.08),
                    textcolor: homeController.selectedCondition.value == "New"
                        ? Colors.white
                        : primaryColor,
                  )),
              Obx(() => ConditionContainer(
                    condtionText: 'Used',
                    onTap: () {
                      homeController.selectedCondition.value = "Used";
                    },
                    color: homeController.selectedCondition.value == "Used"
                        ? primaryColor
                        : primaryColor.withOpacity(0.08),
                    textcolor: homeController.selectedCondition.value == "Used"
                        ? Colors.white
                        : primaryColor,
                  )),
              Obx(() => ConditionContainer(
                    condtionText: 'Old',
                    onTap: () {
                      homeController.selectedCondition.value = "Old";
                    },
                    color: homeController.selectedCondition.value == "Old"
                        ? primaryColor
                        : primaryColor.withOpacity(0.08),
                    textcolor: homeController.selectedCondition.value == "Old"
                        ? Colors.white
                        : primaryColor,
                  )),
            ],
          ),
          SizedBox(height: 20.h),
          RalewayCustomText(
            text: "Category",
            textColor: primaryColor,
            fontWeight: FontWeight.w700,
            fontsize: 18.sp,
          ),
          SizedBox(height: 5.h),
          Obx(() {
            return Container(
              height: 50.h,
              width: 327.w,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20.r)),
              child: DropdownButton<String>(
                  underline: const SizedBox.shrink(),
                  isExpanded: true,
                  value: productsListingController.category.value,
                  items: productsListingController.categorys
                      .map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: RalewayCustomText(
                          text: option,
                          textColor: primaryColor,
                          fontWeight: FontWeight.w700),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // homeController.bookClass.value=newValue!;
                    productsListingController.category.value = newValue!;
                  },
                  hint: const SizedBox.shrink()),
            );
          }),
          SizedBox(height: 20.h),
          Row(
            children: [
              RalewayCustomText(
                text: "Price",
                textColor: primaryColor,
                fontWeight: FontWeight.w700,
                fontsize: 18.sp,
              ),
              const Spacer(),
              Obx(() => WorkSansCustomText(
                    text: '< \$${homeController.priceSliderValue.value}',
                    textColor: primaryColor,
                    fontWeight: FontWeight.w700,
                    fontsize: 18.sp,
                  )),
            ],
          ),
          GetBuilder<HomeController>(builder: (homeController) {
            return FlutterSlider(
              values: [homeController.sliderValue.value],
              max: 500,
              min: 0,
              trackBar: const FlutterSliderTrackBar(
                activeTrackBar: BoxDecoration(color: primaryColor),
              ),
              handler: FlutterSliderHandler(
                decoration: const BoxDecoration(shape: BoxShape.rectangle),
                child: Container(
                  height: 35.h,
                  width: 34.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: primaryColor),
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  child: const Icon(Icons.compare_arrows_outlined),
                ),
              ),
              onDragging: (handlerIndex, lowerValue, upperValue) {
                homeController.priceSliderValue.value = lowerValue;
                print(homeController.priceSliderValue.value);
              },
            );
          }),
          SizedBox(height: 26.h),
          GestureDetector(
            onTap: () {
              // homeController.applyFilters(homeController.authorController.text);
              homeController.filterAppointments();

              // setState(() {
              //
              // });
              print('filterAppointments');
              Get.back();
            },
            child: Center(
              child: Container(
                width: 278.w,
                height: 63.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: primaryColor,
                ),
                child: const LatoCustomText(
                  text: 'Apply Filter',
                  textColor: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConditionContainer extends StatelessWidget {
  final String condtionText;
  final void Function()? onTap;
  final Color? color;
  final Color textcolor;

  const ConditionContainer(
      {super.key,
      required this.condtionText,
      this.onTap,
      this.color,
      required this.textcolor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
            top: 17.5.h, bottom: 17.5.h, left: 24.w, right: 24.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r), color: color),
        child: RalewayCustomText(
          text: condtionText,
          textColor: textcolor,
          fontWeight: FontWeight.w700,
          fontsize: 10.sp,
        ),
      ),
    );
  }
}
