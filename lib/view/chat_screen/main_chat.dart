
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../const/assets/image_assets.dart';
import '../../controller/home_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text.dart';
import 'chat_screen.dart';
import 'components/chat_message_list.dart';

class MainChat extends StatefulWidget {
  const MainChat({super.key});

  @override
  State<MainChat> createState() => _MainChatState();
}

class _MainChatState extends State<MainChat> {
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar2(
          homeController: homeController,
          text: 'Chats',
        ),
        body: SingleChildScrollView(
            child: Column(children: [

              SizedBox(
                height: 30.h,
              ),
              ChatMessageList(),
              // ListView.builder(
              //     padding: EdgeInsets.zero,
              //     itemCount: messageListing.length,
              //     shrinkWrap: true,
              //     itemBuilder: (context, index) {
              //       final message=messageListing[index];
              //       return ListTile(
              //         onTap: () {
              //           CustomRoute.navigateTo(context, ChatScreen(messagedetail:message));
              //         },
              //         leading: Container(
              //           alignment: Alignment.bottomRight,
              //           height: 62.h,
              //           width: 62.w,
              //           decoration: BoxDecoration(
              //             image: DecorationImage(image: AssetImage( messageListing[index]['messageImage'],))
              //           ),
              //           child: Padding(
              //             padding: const EdgeInsets.all(4.0),
              //             child: Image.asset(
              //
              //              AppImages.onlinedot,
              //               height: 10.h,
              //               width: 10.w,
              //             ),
              //           ),
              //         ),
              //         title: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             SizedBox(
              //               width: 200.w,
              //               child: LexendCustomText(
              //                 maxLines: 1,
              //                 overflow: TextOverflow.ellipsis,
              //                 text: messageListing[index]['messagename'],
              //                 textColor: Colors.black,
              //                 fontWeight: FontWeight.w700,
              //                 fontsize: 16.sp,
              //               ),
              //             ),
              //             LexendCustomText(
              //               text: messageListing[index]['Timestamp'],
              //               textColor: Colors.black,
              //               fontWeight: FontWeight.w400,
              //               fontsize: 12.sp,
              //             ),
              //           ],
              //         ),
              //         subtitle: LexendCustomText(
              //           text: messageListing[index]['messagetext'],
              //           textColor: Colors.black,
              //           fontWeight: FontWeight.w400,
              //           fontsize: 12.sp,
              //         ),
              //       );
              //     })
            ])));
  }
}

List<dynamic> messageListing = [
  {
    'messageImage': AppImages.profile1,
    'messagename': 'Memory',
    'messagetext': 'Hi ',
    'Timestamp': '12:52'
  },
  {
    'messageImage': AppImages.profile2,
    'messagename': 'Harry Potter and the cursed',
    'messagetext': 'How are you',
    'Timestamp': '01:52'
  },
  {
    'messageImage': AppImages.profile3,
    'messagename': 'Soul',
    'messagetext': 'I am fine',
    'Timestamp': '03:53'
  }
];
