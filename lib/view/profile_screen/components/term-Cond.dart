import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/home_controller.dart';
import '../../../widgets/custom_appbar.dart';

class TermCond extends StatefulWidget {
  const TermCond({super.key});

  @override
  State<TermCond> createState() => _TermCondState();
}

class _TermCondState extends State<TermCond> {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(
        homeController: homeController,
        text: 'Terms and Conditions',
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffF9F9F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last Updated: 01/09/2024',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text(
                      '1. Introduction',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const Text(
                  'Welcome to Reclaim, a platform dedicated to sustainable shopping in the Middle East. By accessing or using our website or mobile application (collectively referred to as the "App"), you agree to comply with and be bound by the following Terms and Conditions ("Terms"). If you do not agree with these Terms, please refrain from using our App. These Terms constitute a legally binding agreement between you ("User") and Reclaim. If you are using the App on behalf of an organization or entity, you represent and warrant that you have the authority tobind that organization to these Terms.',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text(
                      '2. Use of the App',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Text(
                      '2.1 Eligibility',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                bulletedList([
                  'To use Reclaim, you must be at least 18 years old. By using the App, you represent that you are of legal age and capable of entering into a binding contract.',
                  'You must reside in the UAE or another country where Reclaim operates and agrees to comply with local laws applicable to your use of the App.',
                ]),
                SizedBox(
                  height: 5.h,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Text(
                      '2.2 Account Registration',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                bulletedList([
                  'Certain features of the App require you to create an account. You agree to provide accurate,current, and complete information during registration and to keep your account information updated',
                  'Each User may only have one active account. If you violate this rule, Reclaim reserves the right to terminate or merge duplicate accounts.',
                ]),
                SizedBox(
                  height: 5.h,
                ),
                SizedBox(
                  height: 5.h,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Text(
                      '2.3 Account Security',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                bulletedList([
                  'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
                  'You must immediately notify Reclaim of any unauthorized use of your account. Reclaim is not liable for any losses or damages arising from your failure to safeguard your account.',
                ]),
                SizedBox(
                  height: 5.h,
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text(
                      '3. User Conduct',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Text(
                      '3.1 Prohibited Activities',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Text(
                      'You agree not to engage in any of the following\nprohibited activities:',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                bulletedList([
                  'Do anything illegal or post any unlawful content',
                  'Engaging in fraudulent transactions, such as selling counterfeit or stolen goods.',
                  'Posting misleading, false, or offensive information.',
                  'Deleting and re-listing the same item multiple times to manipulate visibility.',
                  'Attempting to gain unauthorized access to our systems, data, or other Users accounts.',
                  'Harassing, abusing, or threatening other Users.',
                ]),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Text(
                      '3.2 Content Submission',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                bulletedList([
                  'By submitting content to Reclaim (e.g., product listings, reviews), you grant Reclaim a non-exclusive, royalty-free, perpetual, and worldwide license to use, modify, display, and distribute such content.',
                  'You represent and warrant that you own the rights to the content you submit or have obtained permission to post it.',
                  'You are solely responsible for ensuring that your content does not infringe on any third-party rights or violate any applicable laws.',
                ]),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Text(
                      '4. Transactions',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Text(
                      '4.1 Buying and Selling',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                bulletedList([
                  'Reclaim provides a platform for Users to buy and sell items. While we facilitate transactions between Users, Reclaim is not a party to the actual transaction and does not guarantee the quality,safety, or legality of the items listed. Buyers and sellers are solely responsible for complying with all applicable laws and regulations related to their transactions.',
                ]),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Text(
                      '4.2 Payment',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                bulletedList([
                  'Payments for items sold through the App are processed by third-party payment providers. By using these services, you agree to comply with the terms and conditions of the payment provider.',
                  'If you buy an item, your money will first go into an Escrow account thats securely managed by Reclaim until the transaction between seller and buyer is completed',
                ]),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Text(
                      '4.3 VAT Deduction',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                bulletedList([
                  'For each transaction, a 5% Value Added Tax (VAT) will be deducted from the seller\s proceeds.Sellers are responsible for ensuring they are in compliance with applicable VAT laws and regulations. This VAT amount will be automatically withheld from the sale amount and processed accordingly by Reclaim.',
                ]),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Text(
                      '4.4 Returns and Refunds',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                bulletedList([
                  'Buyers have 24 hours from the time of delivery to confirm the item\s condition. If no confirmation is provided within 24 hours, the payment will be automatically released to the seller',
                  'If the buyer chooses to return the item, the return delivery cost will be deducted from the refund amount.',
                  'Purchases below 50 AED do not qualify for refunds unless the item is significantly different from its description.',
                ]),

                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Text(
                      '4.5 Dispute Resolution',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                bulletedList([
                  'In the event of a dispute between a buyer and seller, Reclaim may intervene to mediate the issue,but Reclaim is not obligated to resolve disputes. Users agree to cooperate with Reclaim in any investigation or mediation process.',
                ]),

                SizedBox(
                  height: 10.h,
                ),

                // Add more Text widgets for the rest of the policy...
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget bulletedList(List<String> items) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: items.map((item) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              child: Icon(
                Icons.circle,
                size: 8.0,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                item,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList(),
  );
}
