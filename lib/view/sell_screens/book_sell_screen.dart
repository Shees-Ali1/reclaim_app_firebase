//
// import 'package:flutter/material.dart';
// import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
//
//
// import '../../const/assets/image_assets.dart';
// import '../../const/assets/svg_assets.dart';
// import '../../const/color.dart';
// import '../../controller/home_controller.dart';
// import '../../widgets/custom _backbutton.dart';
// import '../../widgets/custom_appbar.dart';
// import '../../widgets/custom_text.dart';
// import 'list_sell_book_screen.dart';
//
// class BookSellScreen extends StatelessWidget {
//   const BookSellScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final HomeController homeController = Get.find<HomeController>();
//
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//           appBar: CustomAppBar1(
//             homeController: homeController,
//             text: 'Sell Items',
//           ),
//           body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 114.h,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       width: 25.w,
//                     ),
//                     InterCustomText(
//                       text: 'Enter ISBN Number',
//                       textColor: headingBlackColor,
//                       fontsize: 20.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 16.h,
//                 ),
//                 SizedBox(
//                   width: 327.w,
//                   child: TextField(
//                     style: GoogleFonts.lexend(
//                         textStyle: TextStyle(
//                             color: const Color(0xff1E1E1E),
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w500)),
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20.r),
//                         borderSide: BorderSide.none,
//                       ),
//                       fillColor: primaryColor.withOpacity(0.08),
//                       filled: true,
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//                       // prefixIcon: Icon(
//                       //   Icons.search,
//                       //   color: Colors.white,
//                       // ),
//                       // hintText: 'Search',
//                       // hintStyle: GoogleFonts.inter(
//                       //     textStyle: TextStyle(
//                       //         color: Colors.white,
//                       //         fontSize: 15.11.sp,
//                       //         fontWeight: FontWeight.w500)),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 8.h,
//                 ),
//                 InterCustomText(
//                   text: 'or',
//                   textColor: headingBlackColor,
//                   fontsize: 16.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 InterCustomText(
//                   text: 'Click to Scan',
//                   textColor: headingBlackColor,
//                   fontsize: 20.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 SizedBox(
//                   height: 119.h,
//                   width: 111.w,
//                   child: Image.asset(AppImages.qrscan),
//                 ),
//                 SizedBox(
//                   height: 28.h,
//                 ),
//                 Container(
//                     height: 58.h,
//                     width: 322.w,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         color: primaryColor,
//                         borderRadius: BorderRadius.circular(20.r)),
//                     child: LexendCustomText(
//                       text: "Confirm",
//                       textColor: Colors.white,
//                       fontWeight: FontWeight.w400,
//                       fontsize: 18.sp,
//                     )),
//                 SizedBox(
//                   height: 32.h,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Get.to(
//                       const ListSellBookScreen(
//                           bookImage: '',
//                           title: '',
//                           bookCondition: '',
//                           bookPrice: 0,
//                           bookClass: '',
//                           author: '',
//                           bookPart: '',
//                           comingFromEdit: false),
//                       transition: Transition.fade,
//                       duration: const Duration(milliseconds: 500),
//                       curve: Curves.easeIn,
//                     );
//                   },
//                   child: Container(
//                       height: 58.h,
//                       width: 322.w,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           color: primaryColor.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(20.r)),
//                       child: LexendCustomText(
//                         text: "Skip to Enter details Manually",
//                         textColor: Colors.white,
//                         fontWeight: FontWeight.w400,
//                         fontsize: 18.sp,
//                       )),
//                 ),
//                 SizedBox(
//                   height: 20.h,
//                 ),
//               ],
//             ),
//           )),
//     );
//   }
// }
