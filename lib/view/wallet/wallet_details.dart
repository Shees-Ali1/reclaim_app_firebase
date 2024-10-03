
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reclaim_firebase_app/controller/home_controller.dart';

import '../../const/color.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text.dart';

class WalletDetails extends StatefulWidget {
  final dynamic transaction;
  const WalletDetails({super.key, required this.transaction});

  @override
  State<WalletDetails> createState() => _WalletDetailsState();
}

class _WalletDetailsState extends State<WalletDetails> {
  final HomeController homeController = Get.find<HomeController>();
  late final String formattedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timestamp timestamp = widget.transaction['date'];
    DateTime dateTime = timestamp.toDate();
    formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime);
  }

  String getTransactionType(dynamic tx) {
    return tx['type'];
  }

  String getTransactionDate(dynamic tx) {
    return tx['date'];
  }

  String formatBitcoinAmount(dynamic amount) {
    double value;
    if (amount is String) {
      value = double.tryParse(amount) ?? 0.0;
    } else if (amount is int) {
      value = amount.toDouble();
    } else {
      print(amount.runtimeType);
      value = amount;
    }
    return "\₿" + value.toStringAsFixed(8);
  }

  String formatDollarAmount(dynamic amount) {
    double value;
    if (amount is String) {
      value = double.tryParse(amount) ?? 0.0;
    } else if (amount is int) {
      value = amount.toDouble();
    } else {
      value = amount;
    }
    return "" + value.toStringAsFixed(2);
  }

  // Get the Book Name for a transaction
  String? getBookName(dynamic tx) {
    if (tx['type'] == "buy" ||
        tx['type'] == "refund" ||
        tx['type'] == "sale") {
      return tx['productName'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.transaction);

    return Scaffold(
        backgroundColor: whiteColor,

        appBar: CustomAppBar1(
          homeController: homeController,
          text: 'Transaction Details',
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 17.h,
            ),
                ListTile(
                  minTileHeight: 56,
                  minVerticalPadding: 2,
                  contentPadding: EdgeInsets.zero,
                  leading: SizedBox(
                    width: 150.w,
                    child: SoraCustomText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      text: 'Activity',
                      textColor: darkColor,
                      fontWeight: FontWeight.w600,
                      fontsize: 14.sp,
                    ),
                  ),
                  trailing: SizedBox(
                    child: SoraCustomText(
                        text: getTransactionType(widget.transaction),
                        textColor: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontsize: 14.sp),
                  ),
                ),

                ListTile(
                    minTileHeight: 56,
                    minVerticalPadding: 5,
                    contentPadding: EdgeInsets.zero,
                    leading: SizedBox(
                      width: 150.w,
                      child: SoraCustomText(
                        text: 'Date',    // XXXMB - move up to top?
                        textColor: darkColor,
                        fontWeight: FontWeight.w600,
                        fontsize: 14.sp,
                      ),
                    ),
                    trailing: SizedBox(
                      child: SoraCustomText(
                        maxLines: 2,
                        text: formattedDate,
                        textColor: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontsize: 12.sp,
                      ),
                    )),

                getBookName(widget.transaction) != null
                ? ListTile(
                    minTileHeight: 56,
                    minVerticalPadding: 2,
                    contentPadding: EdgeInsets.zero,
                    leading: SizedBox(
                      width: 150.w,
                      child: SoraCustomText(
                        overflow: TextOverflow.ellipsis,
                        text: 'Product Name:',
                        textColor: darkColor,
                        fontWeight: FontWeight.w600,
                        fontsize: 14.sp,
                      ),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Container(
                        alignment: Alignment.centerRight,
                        width: 150,
                        height: 50.h,
                        child: SoraCustomText(
                            maxLines: 2,
                            text: getBookName(widget.transaction)!,
                            textColor: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontsize: 14.sp),
                      ),
                    ))
                : SizedBox.shrink(),
            ListTile(
              minTileHeight: 56,
              minVerticalPadding: 2,
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                width: 150.w,
                child: SoraCustomText(
                  overflow: TextOverflow.ellipsis,
                  text: 'Amount (Aed)',
                  textColor: darkColor,
                  fontWeight: FontWeight.w600,
                  fontsize: 14.sp,
                ),
              ),
              trailing: SoraCustomText(
                text: formatDollarAmount(widget.transaction['price']),
                textColor: primaryColor,
                fontWeight: FontWeight.w600,
                fontsize: 14.sp,
              ),
            ),

            if (widget.transaction['type'] == 'withdraw')
              ListTile(
                  minTileHeight: 56,
                  minVerticalPadding: 5,
                  contentPadding: EdgeInsets.zero,
                  leading: SizedBox(
                    width: 150.w,
                    child: SoraCustomText(
                      text: 'Status',
                      textColor: darkColor,
                      fontWeight: FontWeight.w600,
                      fontsize: 14.sp,
                    ),
                  ),
                  trailing: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('userWithdrawals')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('withdrawalsRequest')
                        .doc(widget.transaction['requestId'])
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox
                            .shrink(); // Show a loading indicator while waiting for data
                      } else if (!snapshot.hasData) {
                        return SizedBox
                            .shrink(); // Show a loading indicator while waiting for data
                      }

                      var document =
                          snapshot.data!.data() as Map<String, dynamic>?;

                      if (document == null ||
                          !document.containsKey('withdrawStatus')) {
                        return SoraCustomText(
                          maxLines: 2,
                          text: 'unknown',
                          textColor: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontsize: 12.sp,
                        );
                      }

                      var status = document['withdrawStatus'];

                      return SoraCustomText(
                        maxLines: 2,
                        text: status,
                        textColor: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontsize: 12.sp,
                      );
                    },
                  )),
          ]),
        )));
  }
}
