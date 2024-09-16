
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../const/assets/image_assets.dart';
import '../const/color.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return   Center(
      child: Container(
        height: 130.h,
        width: double.infinity,
        decoration: BoxDecoration(
            color: primaryColor,
            image: DecorationImage(
                image: AssetImage(
                  AppImages.reclaimlogo,
                ))),
      ),
    );
  }
}
