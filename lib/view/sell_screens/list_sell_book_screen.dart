import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reclaim_firebase_app/controller/productsListing_controller.dart';
import '../../const/assets/image_assets.dart';
import '../../const/color.dart';
import '../../controller/home_controller.dart';
import '../../widgets/custom _backbutton.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text.dart';

class ListSellBookScreen extends StatefulWidget {
  final String? title;
  final String? bookPart;
  final String? author;
  final String? bookClass;
  final String? bookCondition;
  final int? bookPrice;
  final bool? comingFromEdit;
  final String? listingId;
  final String? bookImage;

  const ListSellBookScreen(
      {super.key,
      this.title,
      this.bookPart,
      this.author,
      this.bookClass,
      this.bookCondition,
      this.bookPrice,
      this.comingFromEdit,
      this.listingId,
      this.bookImage});

  @override
  State<ListSellBookScreen> createState() => _ListSellBookScreenState();
}

class _ListSellBookScreenState extends State<ListSellBookScreen> {
  final ProductsListingController productsListingController =
      Get.find<ProductsListingController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    // TODO: implement initState
    // print(widget.bookImage);
    productsListingController.titleController.clear();
    productsListingController.imageFiles.clear();
    productsListingController.brandController.clear();
    productsListingController.DescriptionController.clear();
    productsListingController.classNameController.clear();
    productsListingController.priceController.clear();
    productsListingController.category.value = 'Accessories';
    productsListingController.bookCondition.value = 'New';
    productsListingController.size.value = '3XS';

    super.initState();
  }

  //
  // @override
  // void dispose() {
  //   productsListingController.titleController.dispose();
  //
  //   productsListingController.classNameController.dispose();
  //   productsListingController.priceController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar1(
          homeController: homeController,
          text: 'Sell Items',
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 14.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24.w,
                  ),
                  InterCustomText(
                    text: 'Enter the Details of the product',
                    textColor: headingBlackColor,
                    fontsize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),

              GetBuilder<ProductsListingController>(
                builder: (bookListingController) {
                  return GridView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: bookListingController.imageFiles.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                        mainAxisExtent: 140
                        // childAspectRatio: 1,
                        ),
                    itemBuilder: (context, index) {
                      if (index == bookListingController.imageFiles.length) {
                        // Display add image option if the limit of 3 is not reached
                        return GestureDetector(
                            onTap: () {
                              if (bookListingController.imageFiles.length < 3) {
                                bookListingController.pickImage();
                              }
                            },
                            child: bookListingController.imageFiles.length < 3
                                ? Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(color: primaryColor),
                                      color: primaryColor.withOpacity(0.08),
                                    ),
                                    child: SizedBox(
                                      height: 65.h,
                                      width: 68.w,
                                      child: Image.asset(
                                        AppImages.pickImage,
                                        color: primaryColor,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink());
                      } else {
                        // Display the selected image with a remove option
                        return Stack(
                          children: [
                            Container(
                              // width: 321.w,
                              // height: 129.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: primaryColor),
                                color: primaryColor.withOpacity(0.08),
                                image: DecorationImage(
                                  image: FileImage(productsListingController
                                      .imageFiles[index]!),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  bookListingController.removeImage(index);
                                },
                                child: Icon(Icons.close, color: primaryColor),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
              ),

              SizedBox(
                height: 8.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24.w,
                  ),
                  LexendCustomText(
                    text: 'Product Name',
                    textColor: titleColor,
                    fontWeight: FontWeight.w500,
                    fontsize: 16.sp,
                  ),
                ],
              ),
              // SizedBox(height: 8.h,),
              CustomSellTextField(
                controller: productsListingController.titleController,
              ),
              SizedBox(
                height: 6.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24.w,
                  ),
                  LexendCustomText(
                    text: 'Brand',
                    textColor: titleColor,
                    fontWeight: FontWeight.w500,
                    fontsize: 16.sp,
                  ),
                ],
              ),
              // SizedBox(height: 8.h,),
              CustomSellTextField(
                controller: productsListingController.brandController,
              ),
              SizedBox(
                height: 6.h,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24.w,
                  ),
                  LexendCustomText(
                    text: 'Category',
                    textColor: titleColor,
                    fontWeight: FontWeight.w500,
                    fontsize: 16.sp,
                  ),
                ],
              ),
              // SizedBox(height: 8.h,),
              Obx(() {
                // Check if the current category value exists in the items list
                String? currentCategory =
                    productsListingController.category.value;
                if (!productsListingController.categorys
                    .contains(currentCategory)) {
                  // If not, set it to a default value, e.g., the first item or null
                  currentCategory =
                      productsListingController.categorys.isNotEmpty
                          ? productsListingController.categorys[0]
                          : null;
                  productsListingController.category.value =
                      currentCategory!; // Set the default value
                }

                return Container(
                  height: 50.h,
                  width: 327.w,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: DropdownButton<String>(
                    underline: const SizedBox.shrink(),
                    isExpanded: true,
                    value: currentCategory,
                    items: productsListingController.categorys
                        .map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: RalewayCustomText(
                          text: option,
                          textColor: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        productsListingController.category.value = newValue;
                      }
                    },
                    hint: const SizedBox.shrink(),
                  ),
                );
              }),

              SizedBox(
                height: 6.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24.w,
                  ),
                  LexendCustomText(
                    text: 'Sizes',
                    textColor: titleColor,
                    fontWeight: FontWeight.w500,
                    fontsize: 16.sp,
                  ),
                ],
              ),
              // SizedBox(height: 8.h,),
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
                      value: productsListingController.size.value,
                      items:
                          productsListingController.sizes.map((String option) {
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
                        productsListingController.size.value = newValue!;
                      },
                      hint: const SizedBox.shrink()),
                );
              }),
              SizedBox(
                height: 6.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24.w,
                  ),
                  LexendCustomText(
                    text: 'Description',
                    textColor: titleColor,
                    fontWeight: FontWeight.w500,
                    fontsize: 16.sp,
                  ),
                ],
              ),
              // SizedBox(height: 8.h,),
              CustomSellTextField(
                maxLines: 3,
                controller: productsListingController.DescriptionController,
              ),
              SizedBox(
                height: 6.h,
              ),

              // SizedBox(height: 8.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24.w,
                  ),
                  LexendCustomText(
                    text: 'Condition',
                    textColor: titleColor,
                    fontWeight: FontWeight.w500,
                    fontsize: 16.sp,
                  ),
                ],
              ),
              SizedBox(
                height: 6.h,
              ),
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
                      value: productsListingController.bookCondition.value,
                      items: productsListingController.bookConditions
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
                        productsListingController.bookCondition.value =
                            newValue!;
                      },
                      hint: const SizedBox.shrink()),
                );
              }),
              SizedBox(
                height: 16.h,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24.w,
                  ),
                  LexendCustomText(
                    text: 'Enter your Asking Price (Aed)',
                    textColor: titleColor,
                    fontWeight: FontWeight.w500,
                    fontsize: 16.sp,
                  ),
                ],
              ),
              // SizedBox(height: 8.h,),
              CustomSellTextField(
                // prefixIcon: Icon(
                //   Icons.currency_exchange_sharp,
                //   color: titleColor,
                //   size: 24.sp,
                // ),
                keyboard: TextInputType.number,
                controller: productsListingController.priceController,
              ),
              SizedBox(
                height: 12.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24.w,
                  ),
                  InterCustomText(
                    text:
                        'There is a maximum weight limit of 5kg for\ndelivery anything over must be organised\nbetween the buyer and seller',
                    textColor: Colors.grey,
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),

              SizedBox(
                height: 16.h,
              ),

              GestureDetector(onTap: () {
                widget.comingFromEdit == false
                    ? productsListingController.addProductListing(context)
                    : productsListingController.updateProductListing(
                        context, widget.listingId.toString());
              }, child: Obx(() {
                return Container(
                    height: 58.h,
                    width: 322.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20.r)),
                    child: productsListingController.isLoading.value == true
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : LexendCustomText(
                            text: "Next",
                            textColor: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontsize: 18.sp,
                          ));
              })),
              SizedBox(
                height: 32.h,
              ),
            ],
          ),
        ));
  }
}

class CustomSellTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Icon? prefixIcon;
  final TextInputType? keyboard;
  final Icon? suffixIcon;
  final int? maxLines; // Add maxLines parameter

  const CustomSellTextField({
    super.key,
    this.controller,
    this.prefixIcon,
    this.keyboard,
    this.suffixIcon,
    this.maxLines, // Include maxLines in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: SizedBox(
        width: 327.w,
        child: TextField(
          maxLines: maxLines ?? 1, // Use the maxLines parameter
          keyboardType: keyboard,
          controller: controller,
          style: GoogleFonts.lexend(
            textStyle: TextStyle(
              color: titleColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide.none,
            ),
            fillColor: primaryColor.withOpacity(0.08),
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            suffixIconColor: greenColor,
            // hintText: 'Search',
            // hintStyle: GoogleFonts.inter(
            //     textStyle: TextStyle(
            //         color: Colors.white,
            //         fontSize: 15.11.sp,
            //         fontWeight: FontWeight.w500)),
          ),
        ),
      ),
    );
  }
}
