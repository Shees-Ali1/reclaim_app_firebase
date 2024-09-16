import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


import '../view/home_screen/components/buy_dialog_box.dart';
import '../view/sell_screens/approval_sell_screen.dart';
import '../widgets/custom_route.dart';
import 'chat_controller.dart';
import 'home_controller.dart';
import 'notification_controller.dart';
import 'user_controller.dart';
import 'wallet_controller.dart';

class BookListingController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();
  final WalletController walletController = Get.put(WalletController());
  final NotificationController notificationController = Get.put(NotificationController());
  final ChatController chatController=Get.put(ChatController());
  final UserController userController = Get.put(UserController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bookPartController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  // final user=FirebaseAuth.instance.currentUser!.uid;
  RxString bookCondition = 'New'.obs;
  List<String> bookConditions = ['New', 'Used', 'Old'];
  File? imageFile;
  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);

      update();
    }
  }

  // RxList<dynamic> mySellListings=[
  //   {
  //     'bookImage':AppImages.harryPotterBook,
  //     'bookName':'Harry Potter and the cursed child',
  //     'bookPart':'Parts One And Two',
  //     'bookAuthor':'J.K. Rowling',
  //     'bookClass':'Graduate',
  //     'bookCondition':'New',
  //     'bookPrice':100,
  //     'bookPosted':'20 May 2025',
  //     'sellerId':'qwerty',
  //
  //     'bookDescription':'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Adipiscing malesuada sed imperdiet pharetra, quis et a. Purus sed purus sed proin ornare integer proin lectus. Ut in purus mi, cursus integer et massa. Posuere turpis nulla odio eget auctor nulla lorem. ',
  //     'approval':false,
  //   },
  //   {
  //     'bookImage':AppImages.soulBook,
  //     'bookName':'Soul',
  //     'bookPart':'',
  //     'bookAuthor':' Olivia Wilson',
  //     'bookClass':'Graduate',
  //     'bookCondition':'New',
  //     'bookPrice':100,
  //     'bookPosted':'20 May 2025',
  //     'sellerId':'qwerty',
  //
  //     'bookDescription':'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Adipiscing malesuada sed imperdiet pharetra, quis et a. Purus sed purus sed proin ornare integer proin lectus. Ut in purus mi, cursus integer et massa. Posuere turpis nulla odio eget auctor nulla lorem. ',
  //     'approval':true,
  //
  //   },
  //   {
  //     'bookImage':AppImages.milliontoone ,
  //     'bookName':'A MILLION TO ONE',
  //     'bookPart':'The Fassano Trilogy - Book Two',
  //     'bookAuthor':'Tony Faggioli',
  //     'bookClass':'Graduate',
  //     'bookCondition':'Used',
  //     'bookPrice':70,
  //     'bookPosted':'20 May 2025',
  //     'sellerId':'qwerty',
  //     'bookDescription':'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Adipiscing malesuada sed imperdiet pharetra, quis et a. Purus sed purus sed proin ornare integer proin lectus. Ut in purus mi, cursus integer et massa. Posuere turpis nulla odio eget auctor nulla lorem. ',
  //     'approval':true,
  //
  //   },
  //
  //
  // ].obs;
  RxList<Map<String, dynamic>> mySellListings = <Map<String, dynamic>>[].obs;

  // **************Store book listing by user**********
  Future<void> addBookListing(BuildContext context) async {
    try {
      isLoading.value=true;
      if (titleController.text.isNotEmpty &&
          priceController.text.isNotEmpty &&
          classNameController.text.isNotEmpty &&
          authorController.text.isNotEmpty && imageFile!=null) {
        // mySellListings.add({
        //   'bookImage':AppImages.harryPotterBook,
        //   'bookName':titleController.text,
        //   'bookPart':bookPartController.text,
        //   'bookAuthor':authorController.text,
        //   'bookClass':classNameController.text,
        //   'bookCondition':bookCondition,
        //   'bookPrice':priceController.text,
        //   'bookPosted':'20 May 2025',
        //   'sellerId':'qwerty',
        //
        //   'bookDescription':'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Adipiscing malesuada sed imperdiet pharetra, quis et a. Purus sed purus sed proin ornare integer proin lectus. Ut in purus mi, cursus integer et massa. Posuere turpis nulla odio eget auctor nulla lorem. ',
        //   'approval':false,
        // },);

        DocumentReference bookId =
            await FirebaseFirestore.instance.collection('booksListing').add({
              'bookName': titleController.text,
          'bookPart': bookPartController.text,
          'bookAuthor': authorController.text,
          'bookClass': classNameController.text,
          'bookCondition': bookCondition.value,
          'bookPrice': int.tryParse(priceController.text) ?? 0,
          'bookPosted': DateTime.now(),
          'sellerId': FirebaseAuth.instance.currentUser!.uid,
          'bookDescription': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Adipiscing malesuada sed imperdiet pharetra, quis et a. Purus sed purus sed proin ornare integer proin lectus. Ut in purus mi, cursus integer et massa. Posuere turpis nulla odio eget auctor nulla lorem. ',
          'approval': false,

        });
        DocumentSnapshot userSnap=   await FirebaseFirestore.instance.collection('userDetails').doc(FirebaseAuth.instance.currentUser!.uid).get();
        dynamic userData=userSnap.data();
        String schoolName=userData['userSchool'];
        await uploadBookImage(bookId.id);
        await FirebaseFirestore.instance
            .collection('booksListing')
            .doc(bookId.id)
            .set({
          'listingId': bookId.id,
         'bookImage': imageUrl,
          'schoolName':schoolName
        }, SetOptions(merge: true));
        imageFile=null;

        Get.snackbar('Success', "Book Listing Added");
        isLoading.value=false;
        CustomRoute.navigateTo(context, ApprovalSellScreen());
       await fetchUserBookListing();
        titleController.clear();
        bookPartController.clear();
        authorController.clear();
        classNameController.clear();
        priceController.clear();

      } else {
        Get.snackbar('Missing Values', "Enter All Fields");
        isLoading.value=false;
      }
    } catch (e) {
      isLoading.value=false;
      print("Error listing book $e");
    }
  }
String imageUrl='';
  Future<void> uploadBookImage(String listingId) async{
    try {
      // Get a reference to the Firebase Storage location
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('book_listing_images')
          .child('$listingId.jpg');

      // Upload the image
      UploadTask uploadTask = storageReference.putFile(imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask;

       imageUrl=await taskSnapshot.ref.getDownloadURL();
       update();

      print("Image uploaded");

    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');

    }

  }
  // **************update book listings of  user**********
  Future<void> updateBookListing(BuildContext context,String listingId) async {
    try {
      isLoading.value=true;
      if (titleController.text.isNotEmpty &&
          priceController.text.isNotEmpty &&
          classNameController.text.isNotEmpty &&
          authorController.text.isNotEmpty) {
        // mySellListings.add({
        //   'bookImage':AppImages.harryPotterBook,
        //   'bookName':titleController.text,
        //   'bookPart':bookPartController.text,
        //   'bookAuthor':authorController.text,
        //   'bookClass':classNameController.text,
        //   'bookCondition':bookCondition,
        //   'bookPrice':priceController.text,
        //   'bookPosted':'20 May 2025',
        //   'sellerId':'qwerty',
        //
        //   'bookDescription':'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Adipiscing malesuada sed imperdiet pharetra, quis et a. Purus sed purus sed proin ornare integer proin lectus. Ut in purus mi, cursus integer et massa. Posuere turpis nulla odio eget auctor nulla lorem. ',
        //   'approval':false,
        // },);

        await FirebaseFirestore.instance.collection('booksListing').doc(listingId).update({
          'bookName': titleController.text,
          'bookPart': bookPartController.text,
          'bookAuthor': authorController.text,
          'bookClass': classNameController.text,
          'bookCondition': bookCondition.value,
          'bookPrice': int.tryParse(priceController.text) ?? 0,
          'bookPosted': DateTime.now(),
          'sellerId': FirebaseAuth.instance.currentUser!.uid,
          'bookDescription': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Adipiscing malesuada sed imperdiet pharetra, quis et a. Purus sed purus sed proin ornare integer proin lectus. Ut in purus mi, cursus integer et massa. Posuere turpis nulla odio eget auctor nulla lorem. ',
          'approval': false,
        });
       if(imageFile!=null)
         { await uploadBookImage(listingId);
         await FirebaseFirestore.instance
             .collection('booksListing')
             .doc(listingId)
             .set({
           'bookImage': imageUrl,
         }, SetOptions(merge: true));
         imageFile=null;
         }
        // mySellListings.refresh();
        // update();
        // Get.back();
        Get.snackbar('Success', "Book Listing Updated");
        isLoading.value=false;

        CustomRoute.navigateTo(context, ApprovalSellScreen());
        await fetchUserBookListing();
        await homeController.fetchAllListings();
        titleController.clear();
        bookPartController.clear();
        authorController.clear();
        classNameController.clear();
        priceController.clear();
      } else {
        Get.snackbar('Missing Values', "Enter All Fields");
        isLoading.value=false;

      }
    } catch (e) {
      isLoading.value=false;

      print("Error listing book $e");
    }
  }



  // **************Fetch book listings of that user**********
  Future<void> fetchUserBookListing() async {
    try {
      mySellListings.clear();
      isLoading.value =true;
      QuerySnapshot listingsData = await FirebaseFirestore.instance
          .collection('booksListing')
          .where('sellerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (listingsData.docs.isNotEmpty) {
        listingsData.docs.forEach((book) {
          dynamic bookData = book.data();
          mySellListings.add({
            'bookImage': bookData['bookImage'],
            'bookName': bookData['bookName'],
            'bookPart': bookData['bookPart'],
            'bookAuthor': bookData['bookAuthor'],
            'bookClass': bookData['bookClass'],
            'bookCondition': bookData['bookCondition'],
            'bookPrice': bookData['bookPrice'],
            'bookPosted': bookData['bookPosted'],
            'sellerId': bookData['sellerId'],
            'bookDescription': bookData['bookDescription'],
            'approval': bookData['approval'],
            'listingId':bookData['listingId']
          });
        });
        print('Current User sell listings ${mySellListings}');

      } else {
        print("No user listings found");
      }
      isLoading.value =false;

    } catch (e) {
      print("Error fetch user listings $e");
      isLoading.value =false;

    }
  }

  // **************remove book listings of that user**********
  void removeListingfromSell(int index, String listingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('booksListing')
          .doc(listingId)
          .delete();
      mySellListings.removeAt(index);
      mySellListings.refresh();
      update();
      Get.back();
      Get.snackbar('Success', "Listing Removed");
    } catch (e) {
      print("Error deleting user lisitng $e");
    }
  }



// **************buy book**********
  RxBool isLoading=false.obs;
Future<void> buyBook(String listingId,String sellerId,BuildContext context,String bookName,int purchasePrice,String bookImage) async{
   try{
     isLoading.value=true;
     // Check if balance is zero
     if (walletController.walletbalance.value == 0) {
       Get.snackbar('Low Balance', ' Add money to their wallet');
       isLoading.value=false;

     }
     else{
       int appFees = (purchasePrice * 0.2).round();
       int finalPrice = purchasePrice - appFees;
       // DocumentReference docRef=   await FirebaseFirestore.instance.collection('booksListing').doc(listingId).collection('orders').add({
       //   'bookId':listingId,
       //   'buyerId':FirebaseAuth.instance.currentUser!.uid,
       //   'orderDate':DateTime.now(),
       //   'deliveryStatus':false
       // });
       DocumentReference docRef=   await FirebaseFirestore.instance.collection('orders').add({
         // listing id is our book id
         'bookId':listingId,
         'buyerId':FirebaseAuth.instance.currentUser!.uid,
         'orderDate':DateTime.now(),
         'deliveryStatus':false,
         'sellerId':sellerId,
         'buyerApproval':false,
         'sellerApproval':false,
         'buyingprice':purchasePrice,
         'appFees': appFees,
         'finalPrice': finalPrice,
       });
       // await FirebaseFirestore.instance.collection('booksListing').doc(listingId).collection('orders').doc(docRef.id).set({
       //   'orderId':docRef.id
       // },SetOptions(merge: true)
       // );
       await FirebaseFirestore.instance.collection('orders').doc(docRef.id).set({
         'orderId':docRef.id
       },SetOptions(merge: true)
       );
       await walletController.updatebalance(purchasePrice);
       await FirebaseFirestore.instance.collection('userDetails').doc(FirebaseAuth.instance.currentUser!.uid).set({
         'userPurchases':FieldValue.arrayUnion([listingId]),
       },SetOptions(merge: true));
       userController.userPurchases.add(listingId);
       showDialog(
         context: context,
         builder: (BuildContext context) {
           return const AlertDialog(
             // title: Text('Hello!'),

               content: BuyDialogBox()

           );
         },
       );
       await notificationController.sendFcmMessage('New message', 'You got the order', sellerId);

       await notificationController.storeNotification(purchasePrice, docRef.id, listingId,bookName,'purchased');

       await chatController.createChatConvo(listingId, docRef.id, bookName,sellerId,bookImage);
       await  chatController.getorderId(listingId);

       // await checkUserBookOrder(listingId,sellerId);


       print("book bought");
       isLoading.value=false;
     }

     isLoading.value=false;

   }catch(e){
     print("error buying book $e");
     isLoading.value=false;
   }finally{
     isLoading.value=false;

   }
}






// **************check if user bought that book**********
//   RxBool userBoughtBook=false.obs;
// Future<void> checkUserBookOrder(String listingId,String sellerId) async{
// try{
//   QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('booksListing').doc(listingId).collection('orders').where('buyerId',isEqualTo:FirebaseAuth.instance.currentUser!.uid).get();
//   if(querySnapshot.docs.isNotEmpty) {
//     dynamic data=querySnapshot.docs.first;
//
//     if(data['buyerId']!=sellerId){
//       userBoughtBook.value=true;
//     }
//     else{
//       print("Not match");
//       userBoughtBook.value=false;
//     }
//   }else{
//     userBoughtBook.value=false;
//     print("No order on that id");
//   }
//
// }catch(e){
//   print("error checking order user $e");
// }
//
//
// }

// **************get seller data**********
  RxString sellerName=''.obs;

Future<void> getSellerData(String sellerId) async {
 try{
   DocumentSnapshot docSnap= await FirebaseFirestore.instance.collection('userDetails').doc(sellerId).get();
   if(docSnap.exists){
     dynamic sellerData=docSnap.data();
     sellerName.value=sellerData['userName'];
   }else{
     sellerName.value='';
     print("no seller found");
   }
 }catch(e){
   print("Error fetching seller data $e");
 }
}
// @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     fetchUserBookListing();
//
// }

}
