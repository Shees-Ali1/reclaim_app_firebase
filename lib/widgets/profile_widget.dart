
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


import '../const/assets/svg_assets.dart';
import '../const/color.dart';
import 'custom_text.dart';

class ProfileWidget extends StatelessWidget {
  final String title;
  final String imgUrl;
  final void Function()? onTap;

  ProfileWidget(
      {super.key,
      required this.title,
      required this.imgUrl,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: SvgPicture.asset(
          imgUrl,
          height: 50.h,
          width: 50.w,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
        ),
        title: Padding(
          padding: EdgeInsets.only(left: 10.sp),
          child: WorkSansCustomText(
            textColor: const Color(0xff040415),
            fontWeight: FontWeight.w500,
            fontsize: 16.sp,
            text: title,
          ),
        ),
        trailing: SvgPicture.asset(AppIcons.arrowIcon),
      ),
    );
  }
}
