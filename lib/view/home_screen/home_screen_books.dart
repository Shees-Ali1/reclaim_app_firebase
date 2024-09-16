
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
import '../../controller/user_controller.dart';
import '../../controller/wallet_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_route.dart';
import '../../widgets/custom_text.dart';
import '../notification/notification_screen.dart';
import 'book_details_screen.dart';
import 'components/books_filter_sheet.dart';

class HomeScreenBooks extends StatefulWidget {
  const HomeScreenBooks({super.key});

  @override
  State<HomeScreenBooks> createState() => _HomeScreenBooksState();
}

class _HomeScreenBooksState extends State<HomeScreenBooks> {
  final HomeController homeController = Get.put(HomeController());
  final UserController userController = Get.find<UserController>();
  final BookListingController bookListingController =
      Get.find<BookListingController>();
  final WalletController walletController = Get.find();
  // final List<Product> products = [
  //   Product('Adidas Japan Sneakers', '250 aed', 'assets/images/image1.jpg'),
  //   Product('Kids Toys Package', '36 aed', 'assets/images/image1.jpg'),
  //   Product('Gold Phoenix Necklace', '87 aed', 'assets/images/image1.jpg'),
  //   Product('Red Plaid Teen Skirt', '15 aed', 'assets/images/image1.jpg'),
  // ];
  final catagory = [
    'Recommended',
    'Women',
    'Men',
    'Kids',
    'Toys',
    'Home',
    'Pets',
    'Electronics',
    'Accessories',
  ];

  @override
  void initState() {
    // TODO: implement initState
    print("home");
    super.initState();
    //    userController.fetchUserData().then((value) =>     homeController.fetchAllListings());
    // bookListingController.fetchUserBookListing();
    //  userController.approveProfileUpdate(FirebaseAuth.instance.currentUser!.uid);
    //    userController.checkIfAccountIsDeleted();
    //    walletController.fetchuserwallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarHome(
        homeController: homeController,
        userController: userController,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MontserratCustomText(
                text: 'Favorites',
                fontsize: 14.sp,
                textColor: primaryColor,
                fontWeight: FontWeight.w600,
                // height: 1,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),

                  // height: 1.h,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              5,
                              (index) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.w),
                                    child: SizedBox(
                                        height: 60.h,
                                        width: 82.w,
                                        child: Image.asset(AppImages.image2)),
                                  )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    catagory.length,
                    (index) => GestureDetector(
                      onTap: () {
                        homeController.selectedindex.value = index;
                      },
                      child: Obx(() => Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 13.h, vertical: 11.w),
                            // height: 44.h,
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: homeController.selectedindex.value == index
                                  ? primaryColor
                                  : primaryColor.withOpacity(0.10),
                            ),
                            child: Center(
                                child: MontserratCustomText(
                              text: catagory[index],
                              textColor:
                                  homeController.selectedindex.value == index
                                      ? Colors.white
                                      : primaryColor,
                              fontWeight: FontWeight.w500,
                              fontsize: 12.sp,
                            )),
                          )),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              GestureDetector(
                  onTap: () {
                    Get.to(BookDetailsScreen());
                  },
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2, // Two items in each row
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.75,
                    children: [
                      productCard(
                          'product1',
                          'New',
                          'Mango',
                          'T-Shirt SPANISH',
                          9,
                          'assets/images/image1.jpg',
                          context,
                          homeController),
                      productCard(
                          'product2',
                          'Used',
                          'Dorothy Perkins',
                          'Blouse',
                          21,
                          'assets/images/image1.jpg',
                          context,
                          homeController),
                      productCard(
                          'product3',
                          'New',
                          'Mango',
                          'T-Shirt SPANISH',
                          9,
                          'assets/images/image1.jpg',
                          context,
                          homeController),
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
              SizedBox(
                height: 40.h,
              )
            ],
          ),
        ),
      ),
    );
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
    color:primaryColor.withOpacity(0.08),

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
              bottom: -20,
              child: Container(
                padding: EdgeInsets.zero,
                // width: 36.w,
                // height: 36.h,
                decoration:
                    BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                child: Obx(() => IconButton(
                      icon: Icon(
                        size: 22,
                        homeController.isFavorited(productId)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: homeController.isFavorited(productId)
                            ? Colors.white
                            : Colors.white,
                      ),
                      onPressed: () {
                        homeController.toggleFavorite(productId);
                      },
                    )),
              ),
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
                text: '\$$price',
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

// class Product {
//   final String name;
//   final String price;
//   final String imagePath;
//
//   Product(this.name, this.price, this.imagePath);
// }
//
// class ProductCard extends StatefulWidget {
//   final Product product;
//
//   const ProductCard({required this.product});
//
//   @override
//   _ProductCardState createState() => _ProductCardState();
// }
//
// class _ProductCardState extends State<ProductCard> {
//   bool isFavorited = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Image.asset(
//                   widget.product.imagePath,
//                   fit: BoxFit.fill,
//                   // width: double.infinity,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: MontserratCustomText(
//                   text: widget.product.name,
//                   fontsize: 15.sp,
//                   fontWeight: FontWeight.w600,
//                   textColor: Colors.black,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: MontserratCustomText(
//                   text: widget.product.price,
//                   fontsize: 12.sp,
//                   fontWeight: FontWeight.w500,
//                   textColor: Colors.black87,
//                 ),
//               ),
//               SizedBox(
//                 height: 10.h,
//               )
//             ],
//           ),
//           Positioned(
//             top: -15,
//             right: -15,
//             child: IconButton(
//               icon: Icon(
//                 isFavorited ? Icons.favorite : Icons.favorite_border,
//                 color: isFavorited ? Colors.red : Colors.red,
//               ),
//               onPressed: () {
//                 setState(() {
//                   isFavorited = !isFavorited; // Toggle favorite state
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// key: homeController.scaffoldKey,
// drawer: MyDrawer(),
//       body: Obx(() => userController.isLoading.value==false &&homeController.isLoading.value ==false?SingleChildScrollView(
//         controller: homeController.scrollController,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 18.h,
//             ),
//             Obx(() {
//               return ListView.builder(
//                   clipBehavior: Clip.none,
//                   padding: EdgeInsets.zero,
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: homeController.filteredBooks.length,
//                   itemBuilder: (context, index) {
//                     final books = homeController.filteredBooks[index];
//                     return GestureDetector(
//                         onTap: () {
//                           Get.to(
//                             BookDetailsScreen(
//                               bookDetail: books,
//                               index: index,
//                               comingfromSellScreen: false,
//                             ),
//                             transition: Transition.fade,
//                             duration: const Duration(milliseconds: 500),
//                             curve: Curves.easeIn,
//                           );
//                         },
//                         child: Container(
//                           height: 125.23.h,
//                           width: 303.w,
//                           margin: EdgeInsets.symmetric(
//                               vertical: 8.h, horizontal: 36.w),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                     color: shadowColor,
//                                     blurRadius: 20,
//                                     offset: Offset(0, 4.h))
//                               ],
//                               borderRadius: BorderRadius.circular(9.89.r)),
//                           child: Stack(
//                             alignment: Alignment.bottomRight,
//                             children: [
//                               Row(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(9.89.r),
//                                         bottomLeft: Radius.circular(9.89.r)),
//                                     child: SizedBox(
//                                       height: 125.23.h,
//                                       width: 77.w,
//                                       child: books['bookImage'] != ''
//                                           ? Image.network(
//                                         books['bookImage'].toString(),
//                                         fit: BoxFit.cover,
//                                       )
//                                           : Container(
//                                         color: primaryColor ,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 5.w,
//                                   ),
//                                   FittedBox(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         SizedBox(
//                                           height: 3.h,
//                                         ),
//                                         SizedBox(
//                                             width: 214.w,
//                                             child: MontserratCustomText(
//                                               text: books['bookName'],
//                                               fontsize: 16.sp,
//                                               textColor: textColor,
//                                               fontWeight: FontWeight.w600,
//                                               height: 1,
//                                             )),
//                                         SizedBox(
//                                           height: 5.h,
//                                         ),
//                                         MontserratCustomText(
//                                             text: books['bookPart'] ?? '',
//                                             fontsize: 12.sp,
//                                             textColor: mainTextColor,
//                                             fontWeight: FontWeight.w600),
//                                         SizedBox(
//                                           height: 14.h,
//                                         ),
//                                         MontserratCustomText(
//                                           text:
//                                           "Author: ${books['bookAuthor']}",
//                                           fontsize: 10.sp,
//                                           textColor: mainTextColor,
//                                           fontWeight: FontWeight.w600,
//                                           height: 1.h,
//                                         ),
//                                         SizedBox(
//                                           height: 14.h,
//                                         ),
//                                         MontserratCustomText(
//                                             text:
//                                             "Class: ${books['bookClass']}",
//                                             fontsize: 8.sp,
//                                             textColor: mainTextColor,
//                                             fontWeight: FontWeight.w600),
//                                         MontserratCustomText(
//                                             text:
//                                             "Condition: ${books['bookCondition']}",
//                                             fontsize: 8.sp,
//                                             textColor: mainTextColor,
//                                             fontWeight: FontWeight.w600),
//                                         SizedBox(
//                                           height: 3.h,
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               Container(
//                                 width: 71.w,
//                                 height: 29.h,
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                     color: primaryColor,
//                                     borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(10.r),
//                                         bottomRight: Radius.circular(10.r))),
//                                 child: MontserratCustomText(
//                                   text: "\$${books['bookPrice'].toString()}",
//                                   textColor: Colors.white,
//                                   fontWeight: FontWeight.w700,
//                                   fontsize: 14.sp,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ));
//                   });
//             }),
//             SizedBox(
//               height: 18.h,
//             ),
//           ],
//         ),
//       ):Center(child: CircularProgressIndicator(color: primaryColor,))));
// }
