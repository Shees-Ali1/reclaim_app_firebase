import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reclaim_firebase_app/controller/productsListing_controller.dart';
import 'package:reclaim_firebase_app/controller/wishlist_controller.dart';
import '../../const/assets/image_assets.dart';
import '../../const/color.dart';
import '../../controller/home_controller.dart';
import '../../controller/user_controller.dart';
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
  final ProductsListingController productsListingController =
      Get.find<ProductsListingController>();
  final WishlistController wishlistController = Get.find();

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
  late final Stream<QuerySnapshot> product;
  late final Stream<QuerySnapshot> productlisting;

  @override
  void initState() {
    // TODO: implement initState
    print("home");
    super.initState();
    userController.fetchUserData();
    productlisting =
        FirebaseFirestore.instance.collection('productsListing').snapshots();
    product = FirebaseFirestore.instance
        .collection('userDetails')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('wishlist')
        .snapshots();
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
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder(
                        stream: product, // Real-time updates for wishlist
                        builder: (context, wishlistSnapshot) {
                          if (wishlistSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox.shrink();
                          } else if (wishlistSnapshot.hasError) {
                            return Center(
                                child:
                                    Text('Error: ${wishlistSnapshot.error}'));
                          } else if (!wishlistSnapshot.hasData ||
                              wishlistSnapshot.data!.docs.isEmpty) {
                            return Center(
                                child: Text('No products found in wishlist.'));
                          } else {
                            // Fetch product details based on the wishlist product IDs
                            final wishlistDocs = wishlistSnapshot.data!.docs;
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  wishlistDocs.length,
                                  (index) {
                                    final productId = wishlistDocs[index].id;
                                    return FavouriteProduct(
                                      productId: productId,
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              MontserratCustomText(
                text: 'Followings',
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
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: SizedBox(
                                height: 60.h,
                                // You can set your desired size here
                                width: 60.w,
                                // Same as height to maintain square shape
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  // This ensures the widget remains a square
                                  child: Image.asset(AppImages.image2,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
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
              StreamBuilder(
                stream: productlisting,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: primaryColor,
                    ));
                  } else if (!snapshot.data!.docs.isNotEmpty) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 80.h,
                        ),
                        Center(
                          child: InterCustomText(
                            text: "No Products",
                            textColor: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontsize: 18.sp,
                          ),
                        ),
                      ],
                    );
                  } else {
                    var products = snapshot.data!.docs;

                    homeController.filterdProduct1.value =
                        products.where((product) {
                      var productName =
                          product['productName'].toString().toLowerCase();
                      var productBrand =
                          product['brand'].toString().toLowerCase();

                      // Check if product name or brand contains the search query
                      return productName
                              .contains(homeController.searchQuery.value) ||
                          productBrand
                              .contains(homeController.searchQuery.value);
                    }).toList();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      homeController.update();
                      setState(() {});
                    });
                    homeController.filterdProduct1.value =
                        homeController.filterdProduct2.value;

// Apply additional filtering based on condition, price, and size
//                     homeController.filterdProduct1.value =  homeController.filterdProduct1.value.where((product) {
//                       // Filter by price range
//                       final priceRange = product['productPrice'] <=
//                           homeController.priceSliderValue.value;
//
//                       // Filter by selected condition
//                       final matchesCondition =
//                           homeController.selectedCondition.value == 1 ||
//                               (homeController.selectedCondition.value == 2 &&
//                                   product['productCondition'] == 'New') ||
//                               (homeController.selectedCondition.value == 3 &&
//                                   product['productCondition'] == 'Used') ||
//                               (homeController.selectedCondition.value == 4 &&
//                                   product['productCondition'] == 'Old');
//
//                       final matchesSize = product['size'].toString() ==
//                           homeController.selectedSize.value;
//
//                       final category = product['category'] ==
//                           productsListingController.category.value;
//                       // Combine all conditions
//                       return matchesCondition &&
//                           priceRange &&
//                           matchesSize &&
//                           category;
//                     }).toList();

                    // WidgetsBinding.instance.addPostFrameCallback((_) {
                    //   homeController.update();
                    //   setState(() {});
                    // });
                    homeController.filterdProduct2.value =
                        products.where((product) {
                      var productName =
                          product['productName'].toString().toLowerCase();
                      var productBrand =
                          product['brand'].toString().toLowerCase();

                      // Check if product name or brand contains the search query
                      return productName
                              .contains(homeController.searchQuery.value) ||
                          productBrand
                              .contains(homeController.searchQuery.value);
                    }).toList();
                    // homeController.filterdProduct1.value = homeController.filterdProduct2.value;
                    return Obx(() {
                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: homeController.filterdProduct1.length,
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
                          var product = homeController.filterdProduct1[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(BookDetailsScreen(
                                bookDetail: product, // Pass the product data
                                index: index,
                                comingfromSellScreen: false,
                              ));
                            },
                            child: productCard(
                              product.id,
                              product['productCondition'],
                              product['brand'],
                              product['productName'],
                              product['productPrice'],
                              product['productImage'],
                              context,
                              homeController,
                            ),
                          );
                        },
                      );
                    });
                  }
                },
              ),
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
                child: Image.network(
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

class FavouriteProduct extends StatefulWidget {
  final String productId;

  const FavouriteProduct({super.key, required this.productId});

  @override
  State<FavouriteProduct> createState() => _FavouriteProductState();
}

class _FavouriteProductState extends State<FavouriteProduct> {
  late Stream<DocumentSnapshot> favquery;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    favquery = FirebaseFirestore.instance
        .collection('productsListing')
        .doc(widget.productId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: favquery, // Real-time updates for product details
      builder: (context, productSnapshot) {
        if (productSnapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        } else if (productSnapshot.hasError) {
          return Center(child: Text('Error: ${productSnapshot.error}'));
        } else if (!productSnapshot.hasData || !productSnapshot.data!.exists) {
          return Center(child: Text('Product not found.'));
        } else {
          final productData =
              productSnapshot.data!.data()! as Map<String, dynamic>;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: SizedBox(
              height: 60.h,
              width: 60.w,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  productData['productImage'], // Product image URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
