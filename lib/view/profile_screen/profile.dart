import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../const/assets/image_assets.dart';
import '../../const/assets/svg_assets.dart';
import '../../const/color.dart';
import '../../controller/bookListing_controller.dart';
import '../../controller/home_controller.dart';
import '../../controller/login_auth_controller.dart';
import '../../controller/user_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_route.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/profile_widget.dart';
import '../chat_screen/main_chat.dart';
import '../notification/notification_screen.dart';
import 'components/edit_profile.dart';
import 'components/privacy_policy.dart';
import 'components/term-Cond.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final HomeController homeController = Get.find<HomeController>();
  final UserController userController = Get.find<UserController>();
  final BookListingController bookListingController =
      Get.find<BookListingController>();
  final LoginAuthController loginAuthController =
      Get.find<LoginAuthController>();

  @override
  void initState() {
    // TODO: implement initState
    userController.getSellHistory();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          homeController: homeController,
          text: 'Profile',
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 17.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 35.h),
              child: Column(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('userDetails')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, usersnapshot) {
                      if (usersnapshot.connectionState ==
                          ConnectionState.waiting) {
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
                      } else if (usersnapshot.hasError) {
                        return Center(child: Text('Error loading user data'));
                      } else if (!usersnapshot.hasData ||
                          !usersnapshot.data!.exists) {
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
                      } else {
                        final userdata =
                            usersnapshot.data!.data() as Map<String, dynamic>?;
                        if (userdata != null) {
                          userController.userName.value =
                              userdata['userName'] ?? 'Unknown';
                          userController.userImage.value =
                              userdata['userImage'] ?? '';
                          userController.verified.value =
                              userdata['verified'] ?? false;
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      userController.userImage.value,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                height: 76.h,
                                width: 76.w,
                              );
                            }),
                            SizedBox(
                              width: 10.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return SizedBox(
                                    width: 150,
                                    child: LexendCustomText(
                                      overflow: TextOverflow.ellipsis,
                                      text: userController.userName.value,
                                      fontWeight: FontWeight.w400,
                                      fontsize: 20.sp,
                                      textColor: blackTitleColor,
                                    ),
                                  );
                                }),
                                SizedBox(
                                  height: 8.h,
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                CustomRoute.navigateTo(
                                    context, const EditProfile());
                              },
                              child: SvgPicture.asset(AppIcons.editIcon),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 36.h,
                  ),
                  const Divider(
                    color: Color(0xffDADADA),
                    thickness: 1.5,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 25.w, right: 25.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Obx(() {
                                  return LexendCustomText(
                                    text: bookListingController
                                        .mySellListings.length
                                        .toString(),
                                    fontWeight: FontWeight.w400,
                                    fontsize: 20.sp,
                                    textColor: blackTitleColor,
                                  );
                                }),
                                LexendCustomText(
                                  text: 'Listed',
                                  fontWeight: FontWeight.w400,
                                  fontsize: 10.sp,
                                  textColor: lightTitleColor,
                                ),
                              ],
                            ),
                            Container(
                              height: 24.h,
                              width: 2.w,
                              color: const Color(0xffE0E0E0),
                            ),
                            Column(
                              children: [
                                Obx(() {
                                  return LexendCustomText(
                                    text:
                                        userController.saleSum.value.toString(),
                                    fontWeight: FontWeight.w400,
                                    fontsize: 20.sp,
                                    textColor: blackTitleColor,
                                  );
                                }),
                                LexendCustomText(
                                  text: 'Sales',
                                  fontWeight: FontWeight.w400,
                                  fontsize: 10.sp,
                                  textColor: lightTitleColor,
                                ),
                              ],
                            ),
                            Container(
                              height: 24.h,
                              width: 2.w,
                              color: const Color(0xffE0E0E0),
                            ),
                            Column(
                              children: [
                                Obx(() {
                                  return LexendCustomText(
                                    text: userController.userPurchases.length
                                        .toString(),
                                    fontWeight: FontWeight.w400,
                                    fontsize: 20.sp,
                                    textColor: blackTitleColor,
                                  );
                                }),
                                LexendCustomText(
                                  text: 'Purchases',
                                  fontWeight: FontWeight.w400,
                                  fontsize: 10.sp,
                                  textColor: lightTitleColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileWidget(
                    onTap: () {
                      CustomRoute.navigateTo(context, const EditProfile());
                    },
                    title: 'Edit Profile',
                    imgUrl: AppIcons.editprofileIcon,
                  ),
                  SizedBox(
                    height: 9.h,
                  ),
                  ProfileWidget(
                    onTap: () {
                      CustomRoute.navigateTo(context, const PrivacyPolicy());
                    },
                    title: 'Privacy Policy',
                    imgUrl: AppIcons.privacyIcon,
                  ),
                  SizedBox(
                    height: 9.h,
                  ),
                  // ProfileWidget(
                  //   onTap: () {},
                  //   title: 'Settings',
                  //   imgUrl: AppIcons.settingIcon,
                  // ),
                  // SizedBox(
                  //   height: 9.h,
                  // ),
                  ProfileWidget(
                    onTap: () {
                      CustomRoute.navigateTo(context, const TermCond());
                    },
                    title: 'Terms and Conditions',
                    imgUrl: AppIcons.termcondIcon,
                  ),
                  SizedBox(
                    height: 28.11.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r)),
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 290.h,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Container(
                                    width: 48.w,
                                    height: 5.h,
                                    decoration: const BoxDecoration(
                                        color: Color(0xffCDCFD0)),
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  LexendCustomText(
                                    text: 'Logout Account?',
                                    textColor: const Color(0xff090A0A),
                                    fontWeight: FontWeight.w700,
                                    fontsize: 24.sp,
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  LexendCustomText(
                                    text:
                                        'Are you sure want to logout this account?',
                                    textColor: const Color(0xff090A0A),
                                    fontWeight: FontWeight.w400,
                                    fontsize: 16.sp,
                                  ),
                                  SizedBox(
                                    height: 37.h,
                                  ),
                                  CustomButton(
                                      text: 'Logout',
                                      onPressed: () async {
                                        await loginAuthController.logOut();
                                      },
                                      backgroundColor: const Color(0xffE60000),
                                      textColor: whiteColor),
                                  SizedBox(
                                    height: 22.h,
                                  ),
                                  LexendCustomText(
                                    text: 'Cancel',
                                    textColor: const Color(0xff202325),
                                    fontWeight: FontWeight.w500,
                                    fontsize: 16.sp,
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(AppIcons.logoutIcon),
                        Padding(
                          padding: EdgeInsets.only(left: 26.sp),
                          child: WorkSansCustomText(
                            textColor: const Color(0xff040415),
                            fontWeight: FontWeight.w700,
                            fontsize: 16.sp,
                            text: 'Log Out',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 28.11.h,
            ),
          ],
        )));
  }
}
