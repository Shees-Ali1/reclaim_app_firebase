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
import '../view/chat_screen/chat_screen.dart';
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
  List<String> categorys = ['Accessories', 'Fashion', 'Men', 'Women','Kids'];
  List<File?> imageFiles = [];

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (imageFiles.length < 3) {
        imageFiles.add(File(pickedFile.path));
        update();
      } else {
        // Handle the case when more than 3 images are selected
        Get.snackbar("Limit Reached", "You can only add up to 3 images.");
      }
    }
  }

  void removeImage(int index) {
    imageFiles.removeAt(index);
    update();
  }

  RxList<Map<String, dynamic>> mySellListings = <Map<String, dynamic>>[].obs;

  // **************Store book listing by user**********
  Future<void> addProductListing(BuildContext context) async {
    try {
      isLoading.value = true;

      // Check if the user already has 20 listings
      QuerySnapshot userListings = await FirebaseFirestore.instance
          .collection('productsListing')
          .where('sellerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (userListings.docs.length >= 20) {
        Get.snackbar('Limit Exceeded', "You can only have 20 listings.");
        isLoading.value = false;
        return;
      }

      // Proceed if all fields are valid
      if (titleController.text.isNotEmpty &&
          priceController.text.isNotEmpty &&
          imageFiles != null && imageFiles.isNotEmpty) {

        // Add product listing details to Firestore
        DocumentReference productId = await FirebaseFirestore.instance.collection('productsListing').add({
          'productName': titleController.text,
          'brand': brandController.text,
          'category': category.value,
          'size': size.value,
          'productCondition': bookCondition.value,
          'productPrice': int.tryParse(priceController.text) ?? 0,
          'postedDate': DateTime.now(),
          'sellerId': FirebaseAuth.instance.currentUser!.uid,
          'Description': DescriptionController.text,
          // 'approval': false,
        });

        // Upload all selected images and get their URLs
        List<String> imageUrls = await uploadProductImages(productId.id);

        // Update Firestore document with image URLs
        await FirebaseFirestore.instance.collection('productsListing').doc(productId.id).set({
          'listingId': productId.id,
          'productImages': imageUrls, // Store list of image URLs
        }, SetOptions(merge: true));

        // Reset and notify success
        imageFiles.clear();
        Get.snackbar('Success', "Product Listing Added");
        isLoading.value = false;
       CustomRoute.navigateTo(context, ApprovalSellScreen());
        await fetchUserProductListing();
        titleController.clear();
        DescriptionController.clear();
        brandController.clear();
        classNameController.clear();
        priceController.clear();

      } else {
        Get.snackbar('Missing Values', "Enter All Fields");
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      print("Error listing product: $e");
    }
  }


  // String imageUrl = '';
  Future<List<String>> uploadProductImages(String listingId) async {
    List<String> imageUrls = [];

    try {
      // Loop through all selected images and upload each one
      for (int i = 0; i < imageFiles.length; i++) {
        File? imageFile = imageFiles[i];
        if (imageFile != null) {
          Reference storageReference = FirebaseStorage.instance
              .ref()
              .child('product_listing_images')
              .child('$listingId/image_$i.jpg');

          UploadTask uploadTask = storageReference.putFile(imageFile);
          TaskSnapshot taskSnapshot = await uploadTask;

          String imageUrl = await taskSnapshot.ref.getDownloadURL();
          imageUrls.add(imageUrl); // Add the URL to the list
        } else {
          // Log or handle the null imageFile case
          print('Image file is null at index $i');
        }
      }
      print("Images uploaded");
    } catch (e) {
      print('Error uploading images to Firebase Storage: $e');
      Get.snackbar('Error', "Failed to upload images.");
    }

    return imageUrls;
  }



  // **************update book listings of  user**********
  Future<void> updateProductListing(BuildContext context, String listingId) async {
    try {
      isLoading.value = true;

      if (titleController.text.isNotEmpty && priceController.text.isNotEmpty) {
        // Update product listing details in Firestore
        await FirebaseFirestore.instance.collection('productsListing').doc(listingId).update({
          'productName': titleController.text,
          'brand': brandController.text,
          'category': category.value,
          'size': size.value,
          'productCondition': bookCondition.value,
          'productPrice': int.tryParse(priceController.text) ?? 0,
          'postedDate': DateTime.now(),
          'sellerId': FirebaseAuth.instance.currentUser!.uid,
          'Description': DescriptionController.text,
          'approval': false,
        });

        // Check if there are any new images to upload
        if (imageFiles != null && imageFiles.isNotEmpty) {
          // Upload multiple images and get the new URLs
          List<String> newImageUrls = await uploadProductImages(listingId);

          // Update Firestore with new image URLs (merging with existing images)
          await FirebaseFirestore.instance.collection('productsListing').doc(listingId).set({
            'productImages': FieldValue.arrayUnion(newImageUrls), // Merge new images with existing ones
          }, SetOptions(merge: true));

          imageFiles.clear(); // Clear the images after upload
        }

        Get.snackbar('Success', "Product Listing Updated");
        isLoading.value = false;

        CustomRoute.navigateTo(context, ApprovalSellScreen());
        await fetchUserProductListing();

        // Clear the text fields after update
        titleController.clear();
        brandController.clear();
        classNameController.clear();
        priceController.clear();
      } else {
        Get.snackbar('Missing Values', "Enter All Fields");
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      print("Error updating product listing: $e");
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
  RxBool offerLoadind = false.obs;
  Future<void> buyProduct(
    String listingId,
    String sellerId,
    String brand,
    BuildContext context,
    String productName,
    int purchasePrice,
    String productImage,
  ) async {
    try {
      isLoading.value = true;

      print("book bought111");
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('orders').add({
        // listing id is our book id
        'productId': listingId,
        'buyerId': FirebaseAuth.instance.currentUser!.uid,
        'orderDate': DateTime.now(),
        'deliveryStatus': false,
        'isOrdered': true,

        'sellerId': sellerId,
        'brand': brand,
        // 'buyerApproval': false,
        // 'sellerApproval': false,
        'buyingprice': purchasePrice,
        // 'appFees': appFees,
        // 'finalPrice': finalPrice,
      });

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(docRef.id)
          .set({'orderId': docRef.id}, SetOptions(merge: true));
      // await wishlistController.updatebalance(purchasePrice);
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
          return AlertDialog(
              content: BuyDialogBox(
            sellerId: sellerId,
            buyerId: FirebaseAuth.instance.currentUser!.uid,
          ));
        },
      );
      await notificationController.sendFcmMessage(
          'New message', 'You got the order', sellerId);

      await notificationController.storeNotification(purchasePrice, docRef.id,
          listingId, productName, 'purchased', sellerId);
      await notificationController.sendnotificationtoseller(
          purchasePrice, docRef.id, listingId, productName, 'seller', sellerId);

      await chatController.createChatConvo(
          listingId,
          docRef.id,
          productName,
          sellerId,
          productImage,
          purchasePrice,
          'You got the order on $productName',
          brand);
      await chatController.getorderId(listingId);

      print("product bought");
      isLoading.value = false;

      // isLoading.value = false;
    } catch (e) {
      print("error buying product $e");
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> buyProduct1(
      String listingId,
      String sellerId,
      String brand,
      BuildContext context,
      String productName,
      int purchasePrice,
      String productImage,
      String orderId) async {
    try {
      isLoading.value = true;
      print("Buying product...");

      // Reference the existing order document by listingId
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('orders').doc(orderId);

      // Merge changes to the existing order document
      await docRef.set({
        'deliveryStatus': true, // Updating delivery status to true
        'isOrdered': true, // Updating to reflect the order has been placed
      }, SetOptions(merge: true));

      // Update the buyer's userDetails
      await FirebaseFirestore.instance
          .collection('userDetails')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'userPurchases': FieldValue.arrayUnion([listingId]),
      }, SetOptions(merge: true));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: BuyDialogBox(
            sellerId: sellerId,
            buyerId: FirebaseAuth.instance.currentUser!.uid,
          ));
        },
      );
      // Send FCM notification to seller
      await notificationController.sendFcmMessage(
        'New message',
        'Your product has been purchased',
        sellerId,
      );

      // Store the notification in Firestore
      await notificationController.storeNotification(purchasePrice, listingId,
          listingId, productName, 'purchased', sellerId);
      await notificationController.sendnotificationtoseller(
          purchasePrice, docRef.id, listingId, productName, 'seller', sellerId);
      print("Product purchased successfully");
      isLoading.value = false;
    } catch (e) {
      print("Error buying product: $e");
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createchatwithoutroffer(
    String listingId,
    String sellerId,
    BuildContext context,
    String productName,
    int purchasePrice,
    String productImage,
    String brand,
  ) async {
    try {
      offerLoadind.value = true;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where(
            'buyerId',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
          .where('productId', isEqualTo: listingId)
          .get();

      print("chat create1");

      // Check if querySnapshot is not empty
      if (querySnapshot.docs.isNotEmpty) {
        // Access the first document safely
        DocumentSnapshot firstDoc = querySnapshot.docs.first;

        Get.to(
          ChatScreen(
            sellerId: sellerId == FirebaseAuth.instance.currentUser!.uid
                ? firstDoc['buyerId']
                : sellerId,
            buyerId: FirebaseAuth.instance.currentUser!.uid,
            productName: productName,
            brand: brand,
            image: productImage,
            chatName: 'Make Offer $productName',
            chatId: firstDoc.id,
            seller: sellerId,
            productId: listingId,
            productPrice: purchasePrice,
          ),
        );
      } else {
        // If no document found, create a new order and chat conversation
        DocumentReference docRef =
            await FirebaseFirestore.instance.collection('orders').add({
          // listing id is our product id
          'productId': listingId,
          'buyerId': FirebaseAuth.instance.currentUser!.uid,
          'orderDate': DateTime.now(),
          'deliveryStatus': false,
          'isOrdered': false,
          'sellerId': sellerId,
          'buyingprice': purchasePrice,
          'brand': brand,
        });

        await FirebaseFirestore.instance
            .collection('orders')
            .doc(docRef.id)
            .set({'orderId': docRef.id}, SetOptions(merge: true));

        await chatController.createChatConvo(
          listingId,
          docRef.id,
          productName,
          sellerId,
          productImage,
          purchasePrice,
          "I want to make offer",
          brand,
        );

        await chatController.getorderId(listingId);

        print("chat create");
        Get.snackbar('Success', 'Chat Created');

        Get.to(
          ChatScreen(
            sellerId: sellerId == FirebaseAuth.instance.currentUser!.uid
                ? FirebaseAuth.instance.currentUser!.uid
                : sellerId,
            buyerId: FirebaseAuth.instance.currentUser!.uid,
            productName: productName,
            brand: brand,
            image: productImage,
            chatName: 'Make Offer $productName',
            chatId: docRef.id,
            seller: sellerId,
            productId: listingId,
            productPrice: purchasePrice,
          ),
        );
      }

      offerLoadind.value = false;
    } catch (e) {
      print("error chat create: $e");
      offerLoadind.value = false;
    } finally {
      offerLoadind.value = false;
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

  int rating = 0; // This will store the selected rating

  // Function to update the rating when a star is tapped
  void updateRating(int newRating) {
    rating = newRating;
    update(); // This will refresh the UI in GetBuilder
  }

  Future<void> submitReviewToFirestore(
      String sellerId, int rating, String reviewText, String buyerId) async {
    // Create a reference to the new review document without adding data yet
    final docRef = FirebaseFirestore.instance
        .collection('productReviews')
        .doc(sellerId)
        .collection('reviews')
        .doc();

    // Create review data with the generated reviewId
    final reviewData = {
      'buyerId': buyerId,
      'rating': rating,
      'reviewText': reviewText,
      'timestamp': FieldValue.serverTimestamp(),
      'reply': '',
      'likeCount': 0,
      'likedBy': [],
      'reviewId': docRef.id, // Use the generated document ID as the reviewId
    };

    // Add the review data to Firestore
    await docRef.set(reviewData);
  }

  Future<void> likeReview(String sellerId, String reviewId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('productReviews')
        .doc(sellerId)
        .collection('reviews')
        .doc(reviewId)
        .set({
      'likedBy': FieldValue.arrayUnion([currentUserId]),
      'likeCount': FieldValue.increment(1), // Increment like count
    }, SetOptions(merge: true));
  }

  Future<void> unlikeReview(String sellerId, String reviewId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Update the review document to remove the user from likedBy and decrement the like count
    await FirebaseFirestore.instance
        .collection('productReviews')
        .doc(sellerId)
        .collection('reviews')
        .doc(reviewId)
        .set({
      'likedBy': FieldValue.arrayRemove([currentUserId]),
      'likeCount': FieldValue.increment(-1), // Decrement like count
    }, SetOptions(merge: true));
  }

  Stream<List<Map<String, dynamic>>> fetchProductReviews() async* {
    // Fetch reviews for the current user
    var reviewsSnapshot = FirebaseFirestore.instance
        .collection('productReviews')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('reviews')
        .orderBy('timestamp', descending: true)
        .snapshots();

    await for (var snapshot in reviewsSnapshot) {
      List<Map<String, dynamic>> enrichedReviews = [];

      for (var doc in snapshot.docs) {
        var review = doc.data();
        var buyerId = review['buyerId'];

        // Fetch buyer's name and image based on buyerId
        var buyerDoc = await FirebaseFirestore.instance
            .collection(
                'userDetails') // Assuming the users are stored in 'users' collection
            .doc(buyerId)
            .get();

        var buyerData = buyerDoc.data();

        if (buyerData != null) {
          review['buyerName'] =
              buyerData['userName'] ?? 'Unknown'; // Ensure fallback
          review['buyerImage'] = buyerData['userImage'] ??
              'https://via.placeholder.com/150'; // Default image
        }

        enrichedReviews.add(review);
      }

      // Yield the updated list with buyer details
      yield enrichedReviews;
    }
  }
}
