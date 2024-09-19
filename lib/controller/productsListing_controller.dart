import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reclaim_firebase_app/controller/wishlist_controller.dart';
import '../const/color.dart';
import '../view/home_screen/components/buy_dialog_box.dart';
import '../view/sell_screens/approval_sell_screen.dart';
import '../widgets/custom_route.dart';
import 'chat_controller.dart';
import 'home_controller.dart';
import 'notification_controller.dart';
import 'user_controller.dart';

class ProductsListingController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();
  final WishlistController wishlistController = Get.put(WishlistController());
  final NotificationController notificationController =
      Get.put(NotificationController());
  final ChatController chatController = Get.put(ChatController());
  final UserController userController = Get.put(UserController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController DescriptionController = TextEditingController();

  List<String> restrictedWords = [
    'fuck',
    'fed',
    'fing',
    'shit',
    'bitch',
    'asshole',
    'cunt',
    'dick',
    'dickhead',
    'pussy',
    'motherfucker',
    'tit',
    'sex',
    'porn',
    'nudes',
    'erotic',
    'strip',
    'masturbation',
    'horny',
    'lustful',
    'nsfw',
    'xxx',
    'kill',
    'murder',
    'rape',
    'stab',
    'slaughter',
    'torture',
    'bomb',
    'terrorist',
    'assault',
    'abuse',
    'nigger',
    'faggot',
    'retard',
    'bitch',
    'slut',
    'cunt',
    'racist slur',
    'homophobic slur',
    'islamophobic',
    'anti-semitic',
    'xenophobic slur',
    'transphobic slur',
    'cocaine',
    'heroin',
    'meth',
    'weed',
    'marijuana',
    'high',
    'junkie',
    'dealer',
    'stoned',
    'ecstasy',
    'lsd',
    'scammer',
    'cheat',
    'fraud',
    'bullshit',
    'douche',
    'thief'
  ];

  RxString errorText = ''.obs;
  @override
  void onInit() {
    super.onInit();
    titleController.addListener(() {
      String inputText = titleController.text;
      if (_containsRestrictedWords(inputText)) {
        errorText.value = 'Text contains restricted words';
        titleController.clear();
        Get.snackbar('Error',
            'Your message contains inappropriate content'); // Clear the text field if restricted word is found
      } else {
        errorText.value = ''; // Clear the error if no restricted words
      }
    });
    brandController.addListener(() {
      String inputText = brandController.text;
      if (_containsRestrictedWords(inputText)) {
        errorText.value = 'Text contains restricted words';
        brandController.clear();
        Get.snackbar('Error',
            'Your message contains inappropriate content'); // Clear the text field if restricted word is found
      } else {
        errorText.value = ''; // Clear the error if no restricted words
      }
    });
    categoryController.addListener(() {
      String inputText = categoryController.text;
      if (_containsRestrictedWords(inputText)) {
        errorText.value = 'Text contains restricted words';
        categoryController.clear();
        Get.snackbar('Error',
            'Your message contains inappropriate content'); // Clear the text field if restricted word is found
      } else {
        errorText.value = ''; // Clear the error if no restricted words
      }
    });
    classNameController.addListener(() {
      String inputText = classNameController.text;
      if (_containsRestrictedWords(inputText)) {
        errorText.value = 'Text contains restricted words';
        classNameController.clear();
        Get.snackbar('Error',
            'Your message contains inappropriate content'); // Clear the text field if restricted word is found
      } else {
        errorText.value = ''; // Clear the error if no restricted words
      }
    });
    priceController.addListener(() {
      String inputText = priceController.text;
      if (_containsRestrictedWords(inputText)) {
        errorText.value = 'Text contains restricted words';
        priceController.clear();
        Get.snackbar('Error',
            'Your message contains inappropriate content'); // Clear the text field if restricted word is found
      } else {
        errorText.value = ''; // Clear the error if no restricted words
      }
    });
    DescriptionController.addListener(() {
      String inputText = DescriptionController.text;
      if (_containsRestrictedWords(inputText)) {
        errorText.value = 'Text contains restricted words';
        DescriptionController.clear();
        Get.snackbar('Error',
            'Your message contains inappropriate content'); // Clear the text field if restricted word is found
      } else {
        errorText.value = ''; // Clear the error if no restricted words
      }
    });
    fetchUserProductListing();
  }

  // Method to check for restricted words
  bool _containsRestrictedWords(String text) {
    for (var word in restrictedWords) {
      if (text.toLowerCase().contains(word.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    titleController.dispose();
    brandController.dispose();
    categoryController.dispose();
    classNameController.dispose();
    priceController.dispose();
    DescriptionController.dispose();

    super.dispose();
  }

  RxString bookCondition = 'New'.obs;
  RxString category = 'All'.obs;
  RxString size = '3XS'.obs;

  List<String> bookConditions = ['New', 'Used', 'Old'];
  List<String> sizes = [
    '3XS',
    '2XS',
    'XS',
    'S',
    'M',
    'L',
    'XL',
    '2XL',
    '3XL',
    '4XL',
  ];
  List<String> categorys = ['All','Fashion', 'Men', 'Women'];
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

  RxList<Map<String, dynamic>> mySellListings = <Map<String, dynamic>>[].obs;

  // **************Store book listing by user**********
  Future<void> addProductListing(BuildContext context) async {
    try {
      isLoading.value = true;
      if (titleController.text.isNotEmpty &&
          priceController.text.isNotEmpty &&
          // classNameController.text.isNotEmpty &&
          // categoryController.text.isNotEmpty &&
          imageFile != null) {
        print('hello');
        DocumentReference productId =
            await FirebaseFirestore.instance.collection('productsListing').add({
          'productName': titleController.text,
          'brand': brandController.text,
          'category': category.value,
          'size': size.value,
          // 'bookClass': classNameController.text,
          'productCondition': bookCondition.value,
          'productPrice': int.tryParse(priceController.text) ?? 0,
          'postedDate': DateTime.now(),
          'sellerId': FirebaseAuth.instance.currentUser!.uid,
          'Description': DescriptionController.text,
          'approval': false,
        });
        print('hello1');
        // DocumentSnapshot userSnap=   await FirebaseFirestore.instance.collection('userDetails').doc(FirebaseAuth.instance.currentUser!.uid).get();
        // // dynamic userData=userSnap.data();
        // // // String schoolName=userData['userSchool'];
        await uploadProductImage(productId.id);

        await FirebaseFirestore.instance
            .collection('productsListing')
            .doc(productId.id)
            .set({
          'listingId': productId.id,
          'productImage': imageUrl,
          // 'schoolName':schoolName
        }, SetOptions(merge: true));
        imageFile = null;
        print('hello');
        Get.snackbar('Success', "product Listing Added");
        isLoading.value = false;
        CustomRoute.navigateTo(context, ApprovalSellScreen());
        await fetchUserProductListing();
        titleController.clear();
        brandController.clear();
        // categoryController.clear();
        classNameController.clear();
        priceController.clear();
      } else {
        Get.snackbar('Missing Values', "Enter All Fields");
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      print("Error listing product $e");
    }
  }

  String imageUrl = '';
  Future<void> uploadProductImage(String listingId) async {
    try {
      // Get a reference to the Firebase Storage location
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('product_listing_images')
          .child('$listingId.jpg');

      // Upload the image
      UploadTask uploadTask = storageReference.putFile(imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask;

      imageUrl = await taskSnapshot.ref.getDownloadURL();
      update();

      print("Image uploaded");
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }

  // **************update book listings of  user**********
  Future<void> updateProductListing(
      BuildContext context, String listingId) async {
    try {
      isLoading.value = true;
      if (titleController.text.isNotEmpty && priceController.text.isNotEmpty
          // classNameController.text.isNotEmpty &&
          // categoryController.text.isNotEmpty
          ) {
        await FirebaseFirestore.instance
            .collection('productsListing')
            .doc(listingId)
            .update({
          'productName': titleController.text,
          'brand': brandController.text,
          'category': category.value,
          'size': size.value,
          // 'bookClass': classNameController.text,
          'productCondition': bookCondition.value,
          'productPrice': int.tryParse(priceController.text) ?? 0,
          'postedDate': DateTime.now(),
          'sellerId': FirebaseAuth.instance.currentUser!.uid,
          'Description': DescriptionController.text,
          'approval': false,
        });
        if (imageFile != null) {
          await uploadProductImage(listingId);
          await FirebaseFirestore.instance
              .collection('productsListing')
              .doc(listingId)
              .set({
            'productImage': imageUrl,
          }, SetOptions(merge: true));
          imageFile = null;
        }
        // mySellListings.refresh();
        // update();
        // Get.back();
        Get.snackbar('Success', "Product Listing Updated");
        isLoading.value = false;

        CustomRoute.navigateTo(context, ApprovalSellScreen());
        await fetchUserProductListing();
        // await homeController.fetchAllListings();
        titleController.clear();
        brandController.clear();
        // categoryController.clear();
        classNameController.clear();
        priceController.clear();
      } else {
        Get.snackbar('Missing Values', "Enter All Fields");
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;

      print("Error listing book $e");
    }
  }

  // **************Fetch product listings of that user**********
  Future<void> fetchUserProductListing() async {
    try {
      mySellListings.clear();
      isLoading.value = true;
      QuerySnapshot listingsData = await FirebaseFirestore.instance
          .collection('productsListing')
          .where('sellerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (listingsData.docs.isNotEmpty) {
        listingsData.docs.forEach((prod) {
          Map<String, dynamic> prodData = prod.data() as Map<String, dynamic>;
          mySellListings.add({
            ...prodData,
          });
        });
        print('Current User sell listings ${mySellListings}');
      } else {
        print("No user listings found");
      }
      isLoading.value = false;
    } catch (e) {
      print("Error fetch user listings $e");
      isLoading.value = false;
    }
  }



// **************buy book**********
  RxBool isLoading = false.obs;
  Future<void> buyProduct(
      String listingId,
      String sellerId,
      BuildContext context,
      String productName,
      int purchasePrice,
      String productImage) async {
    try {
      isLoading.value = true;
      // Check if balance is zero

        // int appFees = (purchasePrice * 0.2).round();
        // int finalPrice = purchasePrice - appFees;
        // DocumentReference docRef=   await FirebaseFirestore.instance.collection('booksListing').doc(listingId).collection('orders').add({
        //   'bookId':listingId,
        //   'buyerId':FirebaseAuth.instance.currentUser!.uid,
        //   'orderDate':DateTime.now(),
        //   'deliveryStatus':false
        // });
        print("book bought111");

        DocumentReference docRef =
            await FirebaseFirestore.instance.collection('orders').add({
          // listing id is our book id
          'productId': listingId,
          'buyerId': FirebaseAuth.instance.currentUser!.uid,
          'orderDate': DateTime.now(),
          'deliveryStatus': false,
          'sellerId': sellerId,
          // 'buyerApproval': false,
          // 'sellerApproval': false,
          'buyingprice': purchasePrice,
          // 'appFees': appFees,
          // 'finalPrice': finalPrice,
        });
        // await FirebaseFirestore.instance.collection('booksListing').doc(listingId).collection('orders').doc(docRef.id).set({
        //   'orderId':docRef.id
        // },SetOptions(merge: true)
        // );
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(docRef.id)
            .set({'orderId': docRef.id}, SetOptions(merge: true));
        await wishlistController.updatebalance(purchasePrice);
        await FirebaseFirestore.instance
            .collection('userDetails')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'userPurchases': FieldValue.arrayUnion([listingId]),
        }, SetOptions(merge: true));
        userController.userPurchases.add(listingId);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
                // title: Text('Hello!'),

                content: BuyDialogBox());
          },
        );
        // await notificationController.sendFcmMessage(
        //     'New message', 'You got the order', sellerId);

        // await notificationController.storeNotification(
        //     purchasePrice, docRef.id, listingId, bookName, 'purchased');

        await chatController.createChatConvo(
            listingId, docRef.id, productName, sellerId, productImage,purchasePrice );
        await chatController.getorderId(listingId);

        // await checkUserBookOrder(listingId,sellerId);

        print("product bought");
        isLoading.value = false;


      isLoading.value = false;
    } catch (e) {
      print("error buying product $e");
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }
  // **************remove book listings of that user**********
  void removeListingfromSell(int index, String listingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('productsListing')
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
// *************remove book listings of that user*********
  void removeListing(
      String listingId, String sellerId, String productName) async {
    try {
      isLoading.value = true;
      // await sendSystemMessage(listingId, sellerId);
      // await refundOrderPayment(listingId);
      // TODO(MB): probably should remove the booklisting serverside also....
      await FirebaseFirestore.instance
          .collection('productsListing')
          .doc(listingId)
          .delete();
      // await fetchUserBookListing();
      update();
      Get.back();
      Get.snackbar('Success', "Listing Removed",
          backgroundColor: whiteColor, colorText: Colors.black);
    } catch (e) {
      print("Error deleting user listing $e");
    } finally {
      isLoading.value = false;
    }
  }
  RxString sellerName = ''.obs;

  Future<void> getSellerData(String sellerId) async {
    try {
      DocumentSnapshot docSnap = await FirebaseFirestore.instance
          .collection('userDetails')
          .doc(sellerId)
          .get();
      if (docSnap.exists) {
        dynamic sellerData = docSnap.data();
        sellerName.value = sellerData['userName'];
      } else {
        sellerName.value = '';
        print("no seller found");
      }
    } catch (e) {
      print("Error fetching seller data $e");
    }
  }
}
