import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:reclaim_firebase_app/controller/wishlist_controller.dart';
import '../../const/assets/image_assets.dart';
import '../../const/assets/svg_assets.dart';
import '../../const/color.dart';
import '../../controller/home_controller.dart';
import '../../controller/sign_up_controller.dart';
import '../../helper/stripe_payment.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_route.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_textfield.dart';
import '../chat_screen/main_chat.dart';
import '../notification/notification_screen.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final HomeController homeController = Get.find<HomeController>();
  final WishlistController wishlistController = Get.find<WishlistController>();
  // final StripePaymentMethod stripePaymentMethod = StripePaymentMethod();
  final TextEditingController amountcontroller = TextEditingController();
  final SignUpController signUpController = Get.find();
  List<bool> isFavoritedList = [];

  @override
  void initState() {
    super.initState();
    // Initialize the favorite state for each item in the productListing
    isFavoritedList = List<bool>.filled(productListing.length, false);
    homeController.fetchWishlist();
  }

  List<dynamic> productListing = [
    {
      'Image': AppImages.image1,
      'name': 'Adidas Japan Sneakers',
      'price': '250 aed',
    },
    {
      'Image': AppImages.image1,
      'name': 'Nike Air Max',
      'price': '300 aed',
    }
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          homeController: homeController,
          text: 'Wishlist',
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: 17.h,
            ),
            GestureDetector(
                onTap: () {
                  // Get.to(BookDetailsScreen());
                },
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2, // Two items in each row
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.75,
                  children: [
                    productCard('product1', 'New', 'Mango', 'T-Shirt SPANISH',
                        9, 'assets/images/image1.jpg', context, homeController),
                    productCard(
                        'product2',
                        'Used',
                        'Dorothy Perkins',
                        'Blouse',
                        21,
                        'assets/images/image1.jpg',
                        context,
                        homeController),
                    productCard('product3', 'New', 'Mango', 'T-Shirt SPANISH',
                        9, 'assets/images/image1.jpg', context, homeController),
                    productCard(
                        'product4',
                        'Used',
                        'Dorothy Perkins',
                        'Blouse',
                        21,
                        'assets/images/image1.jpg',
                        context,
                        homeController),
                  ],
                )),
            // ListView.builder(
            //   shrinkWrap: true,
            //   itemCount: productListing.length,
            //   itemBuilder: (context, index) {
            //     return Container(
            //       margin: EdgeInsets.symmetric(vertical: 10.h),
            //       padding: EdgeInsets.only(right: 10.w),
            //       height: 160.h,
            //       decoration: BoxDecoration(
            //         border: Border.all(color: primaryColor, width: 2),
            //         borderRadius: BorderRadius.circular(15.r),
            //       ),
            //       child: Row(
            //         children: [
            //           SizedBox(
            //             height: 100,
            //             child: Image.asset(
            //               productListing[index]['Image'],
            //               fit: BoxFit.fill,
            //             ),
            //           ),
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               SizedBox(height: 20.h,),
            //               SizedBox(
            //                 width: 160.w,
            //                 child: MontserratCustomText(
            //                   maxLines: 2,
            //                   overflow: TextOverflow.ellipsis,
            //                   text: productListing[index]['name'],
            //                   fontsize: 18.sp,
            //                   textColor: Colors.black,
            //                   fontWeight: FontWeight.w600,
            //                   height: 1,
            //                 ),
            //               ),
            //               SizedBox(height: 10.h),
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   MontserratCustomText(
            //                     text: productListing[index]['price'],
            //                     fontsize: 18.sp,
            //                     textColor: Colors.black,
            //                     fontWeight: FontWeight.w600,
            //                     height: 1,
            //                   ),
            //                   SizedBox(width: 20.w),
            //                   IconButton(
            //                     onPressed: () {
            //                       setState(() {
            //                         // Toggle favorite state for the current item
            //                         isFavoritedList[index] = !isFavoritedList[index];
            //                       });
            //                     },
            //                     icon: Icon(
            //                       isFavoritedList[index]
            //                           ? Icons.favorite
            //                           : Icons.favorite_border,
            //                       color: isFavoritedList[index] ? Colors.red : Colors.red,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // ),

            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 24.w),
            //   padding: EdgeInsets.only(top: 22.h, bottom: 11.h),
            //   width: 328.w,
            //   height: 143.h,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(16.r),
            //       gradient: const LinearGradient(
            //           colors: [primaryColor, lightPrimaryColor],
            //           begin: Alignment.topCenter,
            //           end: Alignment.bottomCenter)),
            //   child: Column(
            //     children: [
            //       SoraCustomText(
            //         text: 'Balance',
            //         textColor: whiteColor,
            //         fontWeight: FontWeight.w400,
            //         fontsize: 12.sp,
            //       ),
            //       Obx(() {
            //         return SoraCustomText(
            //           text:
            //               "\$${walletController.walletbalance.value.toString()}",
            //           textColor: whiteColor,
            //           fontWeight: FontWeight.w600,
            //           fontsize: 36.sp,
            //         );
            //       }),
            //       SizedBox(
            //         height: 6.h,
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           SvgPicture.asset(AppIcons.topup),
            //           const SizedBox(
            //             width: 10,
            //           ),
            //           GestureDetector(
            //             onTap: () {
            //               showModalBottomSheet(
            //                   isScrollControlled: true,
            //                   backgroundColor: Colors.white,
            //                   shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(20.r)),
            //                   context: context,
            //                   builder: (BuildContext context) {
            //                     return Container(
            //                       padding: EdgeInsets.only(
            //                         bottom:
            //                             MediaQuery.of(context).viewInsets.bottom,
            //                       ),
            //                       margin: EdgeInsets.symmetric(horizontal: 20.w),
            //                       width: double.infinity,
            //                       child: Column(
            //                         crossAxisAlignment: CrossAxisAlignment.center,
            //                         mainAxisSize: MainAxisSize.min,
            //                         children: [
            //                           SizedBox(
            //                             height: 20.h,
            //                           ),
            //                           Container(
            //                             width: 30.w,
            //                             height: 4.h,
            //                             decoration: BoxDecoration(
            //                                 color: Colors.black,
            //                                 borderRadius:
            //                                     BorderRadius.circular(4.r)),
            //                           ),
            //                           SizedBox(
            //                             height: 20.h,
            //                           ),
            //                           LexendCustomText(
            //                             text: 'Enter Topup Amount',
            //                             fontWeight: FontWeight.w500,
            //                             fontsize: 16.sp,
            //                             textColor: const Color(0xff1E1E1E),
            //                           ),
            //                           SizedBox(
            //                             height: 12.h,
            //                           ),
            //                           InputField(
            //                             controller: amountcontroller,
            //                             hint: 'Enter Amount',
            //                             keyboard: TextInputType.number,
            //                             hintStyle: TextStyle(
            //                                 fontSize: 16.sp,
            //                                 color: Colors.black54),
            //                           ),
            //                           SizedBox(
            //                             height: 18.h,
            //                           ),
            //                           CustomButton(
            //                               text: 'Next',
            //                               onPressed: () {
            //
            //                                 signUpController.isLoading.value==false?
            //                                 stripePaymentMethod
            //                                     .payment(amountcontroller.text):null;
            //                               },
            //                               backgroundColor: primaryColor,
            //                               textColor: whiteColor),
            //                           SizedBox(
            //                             height: 20.h,
            //                           ),
            //                         ],
            //                       ),
            //                     );
            //                   });
            //             },
            //             child: SoraCustomText(
            //               text: 'Top up',
            //               textColor: whiteColor,
            //               fontWeight: FontWeight.w400,
            //               fontsize: 12.sp,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 61.h,
            // ),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 24.w),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // SoraCustomText(
            //       //   text: 'Latest Transactions',
            //       //   textColor: darkColor,
            //       //   fontWeight: FontWeight.w600,
            //       //   fontsize: 14.sp,
            //       // ),
            //       SizedBox(
            //         height: 5.h,
            //       ),
            //       // Obx(() {
            //       //   return ListView.builder(
            //       //       physics: NeverScrollableScrollPhysics(),
            //       //       padding: EdgeInsets.zero,
            //       //       itemCount: walletController.transaction.length,
            //       //       shrinkWrap: true,
            //       //       itemBuilder: (context, index) {
            //       //         String time = walletController.formattransactionTime(
            //       //             walletController.transaction[index]
            //       //                 ['purchaseDate']);
            //       //
            //       //         return ListTile(
            //       //           horizontalTitleGap: 8,
            //       //           contentPadding: EdgeInsets.zero,
            //       //           leading:
            //       //           walletController.transaction[index]
            //       //           ['purchaseType'] !=
            //       //               'topup'?
            //       //           Image.asset(
            //       //             AppImages.walmart,
            //       //             height: 40.h,
            //       //             width: 40.w,
            //       //           ):Image.asset(
            //       //             AppImages.download,
            //       //             height: 40.h,
            //       //             width: 40.w,
            //       //           ),
            //       //           title: SoraCustomText(
            //       //             text: walletController.transaction[index]
            //       //                 ['purchaseName'],
            //       //             textColor: darkColor,
            //       //             fontWeight: FontWeight.w600,
            //       //             fontsize: 12.sp,
            //       //           ),
            //       //           subtitle: SoraCustomText(
            //       //             text: time,
            //       //             textColor: lightDarkColor,
            //       //             fontWeight: FontWeight.w400,
            //       //             fontsize: 12.sp,
            //       //           ),
            //       //           trailing: Row(
            //       //             mainAxisSize: MainAxisSize.min,
            //       //             children: [
            //       //               walletController.transaction[index]
            //       //                           ['purchaseType'] !=
            //       //                       'topup'
            //       //                   ? SoraCustomText(
            //       //                       text:
            //       //                           "-\$${walletController.transaction[index]['purchasePrice']}",
            //       //                       textColor: redColor,
            //       //                       fontWeight: FontWeight.w400,
            //       //                       fontsize: 12.sp,
            //       //                     )
            //       //                   : SoraCustomText(
            //       //                       text:
            //       //                           "+\$${walletController.transaction[index]['purchasePrice']}",
            //       //                       textColor: Color(0xff289B4F),
            //       //                       fontWeight: FontWeight.w400,
            //       //                       fontsize: 12.sp,
            //       //                     ),
            //       //               SizedBox(
            //       //                 width: 5.w,
            //       //               ),
            //       //               SvgPicture.asset(AppIcons.arrowIcon)
            //       //             ],
            //       //           ),
            //       //         );
            //       //       });
            //       // })
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 20.h,
            )
          ]),
        )));
  }
}

Widget productCard(
    String productId,
    String status,
    String brand,
    String title,
    int price,
    String imagePath,
    BuildContext context,
    HomeController homeController) {
  return Card(
    color: primaryColor.withOpacity(0.08),
    margin: EdgeInsets.symmetric(vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: SizedBox(
                // height: 120.h,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: status == 'New' ? primaryColor : primaryColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: InterCustomText(
                  text: status,
                  textColor: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontsize: 10.sp,
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: -10,
              child: Container(
                  padding: EdgeInsets.all(12),
                  // width: 36.w,
                  // height: 36.h,
                  decoration: BoxDecoration(
                      color: primaryColor, shape: BoxShape.circle),
                  child: SizedBox(
                      height: 22.h,
                      width: 22.w,
                    child: Icon(Icons.favorite,color: Colors.white,size: 20,),
                  )),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.w, top: 5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InterCustomText(
                text: brand,
                textColor: Color(0xff9B9B9B),
                fontWeight: FontWeight.w400,
                fontsize: 11.sp,
              ),
              SizedBox(height: 4),
              InterCustomText(
                text: title,
                maxLines: 2,
                textColor: Color(0xff222222),
                fontWeight: FontWeight.w600,
                fontsize: 16.sp,
              ),
              SizedBox(height: 4),
              InterCustomText(
                text: '$price Aed',
                textColor: Color(0xff222222),
                fontWeight: FontWeight.w500,
                fontsize: 14.sp,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
