import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reclaim_firebase_app/helper/loading.dart';

class HomeController extends GetxController {

  // var selectedindex = 0.obs;
  var favorites = <String>[].obs;
  RxString searchQuery = ''.obs;
  Future<void> fetchWishlist() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var snapshot = await FirebaseFirestore.instance
        .collection('userDetails')
        .doc(userId)
        .collection('wishlist')
        .get();

    favorites.value = snapshot.docs.map((doc) => doc.id).toList();
  }

  bool isFavorited(String productId) {
    return favorites.contains(productId);
  }

  Future<void> toggleFavorite(String productId) async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var wishlistRef = FirebaseFirestore.instance
        .collection('userDetails')
        .doc(userId)
        .collection('wishlist');

    if (isFavorited(productId)) {
      // Remove from wishlist
      await wishlistRef.doc(productId).delete();
      favorites.remove(productId);
    } else {
      // Add to wishlist
      await wishlistRef.doc(productId).set({
        'addedAt': FieldValue.serverTimestamp(),
        'productId': productId
      });
      favorites.add(productId);
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  ScrollController scrollController = ScrollController();
  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      // User reached the end of the list
      print("user reach end");
    }
  }
  // Restricted words list
  List<String> restrictedWords = [
    'fuck', 'fed', 'fing', 'shit', 'bitch', 'asshole', 'cunt', 'dick', 'dickhead', 'pussy',
    'motherfucker', 'tit', 'sex', 'porn', 'nudes', 'erotic', 'strip', 'masturbation', 'horny',
    'lustful', 'nsfw', 'xxx', 'kill', 'murder', 'rape', 'stab', 'slaughter', 'torture',
    'bomb', 'terrorist', 'assault', 'abuse', 'nigger', 'faggot', 'retard', 'bitch', 'slut',
    'cunt', 'racist slur', 'homophobic slur', 'islamophobic', 'anti-semitic', 'xenophobic slur',
    'transphobic slur', 'cocaine', 'heroin', 'meth', 'weed', 'marijuana', 'high', 'junkie',
    'dealer', 'stoned', 'ecstasy', 'lsd', 'scammer', 'cheat', 'fraud', 'bullshit', 'douche', 'thief'
  ];

  RxString errorText = ''.obs;
  TextEditingController authorController = TextEditingController();

  TextEditingController bookSearchController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    bookSearchController.addListener(() {
      String inputText = bookSearchController.text;
      if (_containsRestrictedWords(inputText)) {
        errorText.value = 'Text contains restricted words';
        bookSearchController.clear();
        Get.snackbar('Error', 'Your message contains inappropriate content'); // Clear the text field if restricted word is found
      } else {
        errorText.value = ''; // Clear the error if no restricted words
      }
    });
    authorController.addListener(() {
      String inputText = authorController.text;
      if (_containsRestrictedWords(inputText)) {
        errorText.value = 'Text contains restricted words';
        authorController.clear();
        Get.snackbar('Error', 'Your message contains inappropriate content'); // Clear the text field if restricted word is found
      } else {
        errorText.value = ''; // Clear the error if no restricted words
      }
    });
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



  RxInt selectedindex = 0.obs;

  RxString selectedSize = 'All'.obs;

// ******************Search***********
//   final TextEditingController bookSearchController = TextEditingController();

  // ******************Filters***********
  RxString selectedCondition ='All'.obs;
  RxDouble priceSliderValue = 0.0.obs;
  RxDouble sliderValue = 0.0.obs;
  RxString classOption = 'Graduate'.obs;
  List<String> bookClass = [
    'Graduate',
    'Option 2',
    'Class 10',
    'Option 4',
    'Harker'
  ];
  String normalize(String str) {
    // Remove all punctuation and spaces, and convert to lower case
    return str.replaceAll(RegExp(r'[\W_]+'), '').toLowerCase();
  }
  var filterredProduct = <QueryDocumentSnapshot<Object?>> [].obs;
  var mainProductlist = <QueryDocumentSnapshot<Object?>> [].obs;
  void filterAppointments() {
  int  priceSlider =homeController.priceSliderValue.value.toInt();
  print(priceSlider);
    filterredProduct.assignAll(mainProductlist.where((product) {
      final matchesCondition = selectedCondition.value == "All" || product['productCondition'] == selectedCondition.value;
      final matchesCategory = productsListingController.category.value == "All" || product['category'] == productsListingController.category.value;
      final matchesSizes = selectedSize.value == "All" || product['size'] == selectedSize.value;
    final matchesPrice = priceSlider == 0|| product['productPrice'] <= priceSlider;
      // final matchesStatus = selectedStatus == "All Status" || appointment['status'] == selectedStatus;

      return matchesCondition && matchesCategory && matchesSizes && matchesPrice ;

    }).toList());
filterredProduct.refresh();    print(filterredProduct);
  }

  void filterProductsByCategory(String categoryName) {
    if (categoryName == 'All') {
      // Show all products
      homeController.filterredProduct.assignAll(homeController.mainProductlist);
    } else {
      // Filter products by category name
      homeController.filterredProduct.assignAll(
        homeController.mainProductlist.where((product) {
          return product['category'] == categoryName; // Ensure this matches your product structure
        }).toList(),
      );
    }

    homeController.filterredProduct.refresh(); // Make sure to refresh the observable list
    print(homeController.mainProductlist); // For debugging
    print(homeController.filterredProduct); // For debugging
  }

  void searchProduct(String searchquery) {
    filterredProduct.value =
        mainProductlist.where((product) {
          final productName =
          product['productName'].toString().toLowerCase();
          final query =
          searchquery.toLowerCase();
          return productName
              .contains(query); // Filtering by search query
        }).toList();
    filterredProduct.refresh();
  }
}
