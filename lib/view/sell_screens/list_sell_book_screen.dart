
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../const/assets/image_assets.dart';
import '../../const/color.dart';
import '../../controller/bookListing_controller.dart';
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
  final BookListingController bookListingController =
      Get.find<BookListingController>();
  final HomeController homeController = Get.find<HomeController>();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   print(widget.bookImage);
  //   bookListingController.titleController.text = widget.title!;
  //   bookListingController.bookPartController.text = widget.bookPart!;
  //   bookListingController.authorController.text = widget.author!;
  //   bookListingController.classNameController.text = widget.bookClass!;
  //   bookListingController.priceController.text = widget.bookPrice!.toString();
  //
  //   super.initState();
  // }

  @override
  void dispose() {
    // bookListingController.titleController.dispose();
    // bookListingController.bookPartController.dispose();
    // bookListingController.authorController.dispose();
    // bookListingController.classNameController.dispose();
    // bookListingController.priceController.dispose();
    super.dispose();
  }

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
              GetBuilder<BookListingController>(
                  builder: (bookListingController) {
                return bookListingController.imageFile == null
                    ? GestureDetector(
                        onTap: () {
                          bookListingController.pickImage();
                        },
                        child: Container(
                          width: 321.w,
                          height: 129.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: primaryColor),
                              color: primaryColor.withOpacity(0.08)),
                          child:
                               SizedBox(
                                  height: 65.h,
                                  width: 68.w,
                                  child: Image.asset(AppImages.pickImage,color: primaryColor,))

                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          bookListingController.pickImage();
                        },
                        child: Container(
                          width: 321.w,
                          height: 129.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: primaryColor),
                              color: primaryColor.withOpacity(0.08),
                              image: DecorationImage(
                                  image: FileImage(
                                      bookListingController.imageFile!),
                                  fit: BoxFit.fill)),
                        ),
                      );
              }),
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
                controller: bookListingController.titleController,
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
                controller: bookListingController.bookPartController,
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
              CustomSellTextField(
                controller: bookListingController.authorController,
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
                    text: 'Description',
                    textColor: titleColor,
                    fontWeight: FontWeight.w500,
                    fontsize: 16.sp,
                  ),
                ],
              ),
              // SizedBox(height: 8.h,),
              CustomSellTextField(
                controller: bookListingController.classNameController,
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
                      value: bookListingController.bookCondition.value,
                      items: bookListingController.bookConditions
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
                        bookListingController.bookCondition.value = newValue!;
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
                    text: 'Enter your Asking Price',
                    textColor: titleColor,
                    fontWeight: FontWeight.w500,
                    fontsize: 16.sp,
                  ),
                ],
              ),
              // SizedBox(height: 8.h,),
              CustomSellTextField(
                prefixIcon: Icon(
                  Icons.currency_exchange_sharp,
                  color: titleColor,
                  size: 24.sp,
                ),
                keyboard: TextInputType.number,
                controller: bookListingController.priceController,
              ),

              SizedBox(
                height: 16.h,
              ),

              GestureDetector(
                onTap: () {
                  // widget.comingFromEdit == false
                  //     ? bookListingController.addBookListing(context)
                  //     : bookListingController.updateBookListing(
                  //         context, widget.listingId.toString());
                },
                child: Container(
                      height: 58.h,
                      width: 322.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20.r)),
                      child:
                      // bookListingController.isLoading.value == false
                      //     ?
                      LexendCustomText(
                              text: "Next",
                              textColor: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontsize: 18.sp,
                            )
                          // : Center(
                          //     child: CircularProgressIndicator(
                          //       color: Colors.white,
                          //     ),
                          //   )
                  )

              ),
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

  const CustomSellTextField(
      {super.key,
      this.controller,
      this.prefixIcon,
      this.keyboard,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: SizedBox(
        width: 327.w,
        child: TextField(
          keyboardType: keyboard,
          controller: controller,
          style: GoogleFonts.lexend(
              textStyle: TextStyle(
                  color: titleColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500)),
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
              suffixIconColor: greenColor
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
