import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:reclaim_firebase_app/controller/wishlist_controller.dart';
import 'package:reclaim_firebase_app/helper/loading.dart';
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
  List<Map<String, dynamic>> wishlistProducts = [];

  @override
  void initState() {
    super.initState();

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
            FutureBuilder<List<Map<String, dynamic>>>(
              future: wishlistController.fetchWishlistProducts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: primaryColor,
                  ));
                } else if (snapshot.data!.isEmpty) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 190.h,
                      ),
                      Center(
                        child: InterCustomText(
                          text: 'No Wishlist',
                          textColor: Color(0xff222222),
                          fontWeight: FontWeight.w700,
                          fontsize: 20.sp,
                        ),
                      ),
                    ],
                  );
                } else {
                  wishlistController.favorites1.value =
                      snapshot.data!; // List of products

                  return Obx(() {
                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: wishlistController.favorites1.value.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        // Number of columns
                        crossAxisSpacing: 8.0,
                        // Horizontal space between items
                        mainAxisSpacing: 8.0,
                        // Vertical space between items
                        childAspectRatio: 0.75, // Aspect ratio of each item
                      ),
                      itemBuilder: (context, index) {
                        var product = wishlistController
                            .favorites1[index]; // Get the product map

                        return productCard(
                          product['listingId'],
                          // Accessing the correct keys from the product map
                          product['productCondition'],
                          product['brand'],
                          product['productName'],
                          product['productPrice'],
                          product['productImages'][0],
                          context,
                          homeController,
                        );
                      },
                    );
                  });
                }
              },
            ),
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
                  height: 120.h,
                  child: CachedNetworkImage(
                    imageUrl: imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                      color: primaryColor,
                    )), // Loading indicator
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error), // Error icon
                  )),
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
              child: GestureDetector(
                onTap: () async {
                  await wishlistController.removeFromWishlist(productId);

                  // Optional: Update UI, e.g., refresh the list or update state
                  // wishlistController.updateFavorites(productId, false);
                },
                child: Container(
                    padding: EdgeInsets.all(12),
                    // width: 36.w,
                    // height: 36.h,
                    decoration: BoxDecoration(
                        color: primaryColor, shape: BoxShape.circle),
                    child: SizedBox(
                      height: 22.h,
                      width: 22.w,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 20,
                      ),
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
