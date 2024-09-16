
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/home_controller.dart';

import '../../../widgets/custom_appbar.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(
        homeController: homeController,
        text: 'Privacy Policy',
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
                  'Last Updated: 12/09/2024',
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
                  'Welcome to Reclaim, a platform dedicated to sustainable shopping in the Middle East.We value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our app.',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text(
                      '2. Information We Collect We may collect and\nprocess the following types of information:',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                bulletedList([
                  'Personal Information: Name, email address, phone number, and payment information when you register, make a purchase, or interact with our services.',
                  'User Data: Information about your usage of the app, including purchase history, browsing habits,and preferences.',
                  'Device Information: Information about your device, such as IP address, browser type, and operating system.',
                ]),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Text(
                      '3. How We Use Your Information We use the\ninformation we collect to:',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                bulletedList([
                  'Provide, operate, and maintain our app.',
                  'Process transactions and manage your orders.',
                  'Communicate with you regarding your account, orders, and other relevant updates.',
                  'Improve our app by analyzing user behavior and preferences.',
                  'Offer personalized experiences and recommendations.',
                  'Ensure the security and integrity of our platform.',
                ]),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Text(
                      '4. Sharing Your Information We may share your\ninformation with:',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                bulletedList([
                  'Service Providers: Third-party companies that help us operate our business, such as payment processors and delivery services.',
                  'Legal Requirements: If required by law, regulation, or legal process, we may disclose your information to relevant authorities.',
                  'Business Transfers: In the event of a merger, sale, or transfer of all or part of our business, your information may be transferred to the new owner.',
                ]),
                SizedBox(
                  height: 5.h,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '5. Security ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text:
                        'We take reasonable measures to protect your information from unauthorized access, disclosure, alteration, or destruction.\nHowever, please note that no method of transmission over the internet or method of electronic storage is 100% secure.',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Text(
                      '6. Your Rights You have the right to:',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                bulletedList([
                  'Access and update your personal information.',
                  'Request the deletion of your personal data, subject to certain exceptions.',
                  'Opt-out of marketing communications at any time.',
                ]),
                SizedBox(
                  height: 5.h,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '7. Cookies and Tracking Technologies ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text:
                        'We use cookies and similar tracking technologies to enhance your experience on our app. These technologies help us understand how you use our app, remember your preferences, and provide personalized content',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 5.h,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '8. Third-Party Links ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text:
                        'Our app may contain links to third-party websites or services. We are not responsible for the privacy practices or content of these third-party sites.',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 5.h,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '9. Changes to This Privacy Policy ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text:
                        'We may update this Privacy Policy from time to time. Any changes will be posted on this page with an updated "Last Updated" date. We encourage you to review this policy periodically to stay informed about how we are protecting your information.',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 5.h,
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
