
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/color.dart';
import '../../../widgets/custom_text.dart';


class OfferDialog extends StatelessWidget {
  final int currentOffer;
  final Function(int) onOfferChanged;

  OfferDialog({required this.currentOffer, required this.onOfferChanged});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Increment/Decrement Buttons and Offer Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    onOfferChanged(currentOffer - 1);
                  },
                  child: Container(
                    width: 41.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(15.r)),
                    child: Icon(Icons.remove, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withOpacity(0.10),
                      border: Border.all(color: primaryColor, width: 1)),
                  child: Center(
                    child: PoppinsCustomText(
                      fontWeight: FontWeight.w600,
                      text: "$currentOffer Aed",
                      fontsize: 24.sp,
                      textColor: primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                GestureDetector(
                  onTap: () {
                    onOfferChanged(currentOffer + 1);
                  },
                  child: Container(
                    width: 41.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(15.r)),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Send Offer Button
            ElevatedButton(
              onPressed: () {

                Navigator.of(context).pop(); // Close the dialog
                // Handle send offer logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              child: PoppinsCustomText(
                fontWeight: FontWeight.w400,
                text: "Send offer",
                fontsize: 16.sp,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
