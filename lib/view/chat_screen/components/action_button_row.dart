
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/custom_text.dart';
 // for adaptive sizing, make sure to use the package
// Import your custom text widget here if needed

class ActionButtonsRow extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final String amount;  // To pass the '19' dynamically
  final String currency;  // To pass 'Aed' dynamically

  const ActionButtonsRow({
    Key? key,
    required this.onAccept,
    required this.onDecline,
    required this.amount,
    required this.currency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Accept button
        Container(
          width: 100.w,
          height: 52.h,
          decoration: BoxDecoration(
            color: const Color(0xff24B26B),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Center(
            child: GestureDetector(
              onTap: onAccept,
              child: MontserratCustomText(
                textColor: Colors.white,
                text: 'Accept',
                fontWeight: FontWeight.w700,
                fontsize: 14.sp,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),

        // Amount display
        Container(
          width: 52.w,
          height: 52.h,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.10),
            border: Border.all(color: Colors.green, width: 1),
            borderRadius: BorderRadius.circular(11.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MontserratCustomText(
                textColor: Colors.black,
                text: amount,
                fontWeight: FontWeight.w700,
                fontsize: 15.sp,
              ),
              MontserratCustomText(
                textColor: Colors.black,
                text: currency,
                fontWeight: FontWeight.w700,
                fontsize: 12.sp,
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),

        // Decline button
        Container(
          width: 100.w,
          height: 52.h,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Center(
            child: GestureDetector(
              onTap: onDecline,
              child: MontserratCustomText(
                textColor: Colors.white,
                text: 'Decline',
                fontWeight: FontWeight.w700,
                fontsize: 14.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
