import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{
  var favoriteProducts = <String, bool>{}.obs;

  void toggleFavorite(String productId) {
    if (favoriteProducts.containsKey(productId)) {
      favoriteProducts[productId] = !favoriteProducts[productId]!;
    } else {
      favoriteProducts[productId] = true;
    }
  }

  bool isFavorited(String productId) {
    return favoriteProducts[productId] ?? false;
  }
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
  ScrollController scrollController = ScrollController();
  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      // User reached the end of the list
 print("user reach end");
    }
  }



  // ******************Books Listings***********
  // RxList<dynamic> bookListing=[
  //   {
  //     'bookImage':AppImages.harryPotterBook,
  //     'bookName':'Harry Potter and the cursed child',
  //     'bookPart':'Parts One And Two',
  //     'bookAuthor':'J.K. Rowling',
  //     'bookClass':'Graduate',
  //     'bookCondition':'New',
  //     'bookPrice':100,
  //     'bookPosted':'20 May 2025',
  //     'bookDescription':'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Adipiscing malesuada sed imperdiet pharetra, quis et a. Purus sed purus sed proin ornare integer proin lectus. Ut in purus mi, cursus integer et massa. Posuere turpis nulla odio eget auctor nulla lorem. '
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
  //     'bookDescription':'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Adipiscing malesuada sed imperdiet pharetra, quis et a. Purus sed purus sed proin ornare integer proin lectus. Ut in purus mi, cursus integer et massa. Posuere turpis nulla odio eget auctor nulla lorem. '
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
  //     'bookDescription':'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Adipiscing malesuada sed imperdiet pharetra, quis et a. Purus sed purus sed proin ornare integer proin lectus. Ut in purus mi, cursus integer et massa. Posuere turpis nulla odio eget auctor nulla lorem. '
  //   },
  //   {
  //     'bookImage':AppImages.harryPotterBook,
  //     'bookName':'Harry Potter and the cursed child',
  //     'bookPart':'Parts One And Two',
  //     'bookAuthor':'J.K. Rowling',
  //     'bookClass':'Graduate',
  //     'bookCondition':'New',
  //     'bookPrice':100,
  //     'bookPosted':'20 May 2025',
  //     'bookDescription':'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Adipiscing malesuada sed imperdiet pharetra, quis et a. Purus sed purus sed proin ornare integer proin lectus. Ut in purus mi, cursus integer et massa. Posuere turpis nulla odio eget auctor nulla lorem. '
  //   },
  //
  //
  //
  // ].obs;
RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> bookListing = <Map<String, dynamic>>[].obs;
  Future<void> fetchAllListings()async{
    try{
      isLoading.value =true;
      bookListing.clear();
      QuerySnapshot data= await FirebaseFirestore.instance.collection('booksListing').where('approval',isEqualTo: true).where('schoolName',isEqualTo: classOption.value).get();
      data.docs.forEach((bookData) {
        bookListing.add({
          'bookImage': bookData['bookImage'],
          'bookName': bookData['bookName'],
          'bookPart': bookData['bookPart'],
          'bookAuthor': bookData['bookAuthor'],
          'bookClass': bookData['bookClass'],
          'bookCondition': bookData['bookCondition'],
          'bookPrice': bookData['bookPrice'],
          'bookPosted': bookData['bookPosted'],
          'sellerId': bookData['sellerId'] ?? "n/a",
          'bookDescription': bookData['bookDescription'],
          'approval': bookData['approval'],
          'listingId':bookData['listingId'],
          'schoolName':bookData['schoolName']

        });
      });
      print(bookListing);
      isLoading.value =false;


    }catch(e){
      print("Error fetching all listings $e");
      isLoading.value =false;

    }
  }
  void removeBookListing(int index,String listingId) async{
    await FirebaseFirestore.instance
        .collection('booksListing')
        .doc(listingId)
        .delete();
    bookListing.removeAt(index);
    bookListing.refresh();
    update();
    Get.back();
    Get.snackbar('Success', "Listing Removed");
  }

  RxInt selectedindex = 0.obs;

  RxString selectedSize = '6'.obs;


// ******************Search***********
  final TextEditingController bookSearchController=TextEditingController();
  RxList<dynamic> filteredBooks = <dynamic>[].obs;
  void filterBooks() {
    List<dynamic> results = [];
    if (bookSearchController.text.isEmpty) {
      results = bookListing;
    } else {
      results = bookListing
          .where((book) =>
          book['bookName']
              .toLowerCase()
              .contains(bookSearchController.text.toLowerCase()))
          .toList();
    }
    // Update the list of filtered books
    filteredBooks.value = results;
  }


  // ******************Filters***********
  RxInt selectedCondition=1.obs;
  RxDouble priceSliderValue=100.0.obs;
  RxDouble sliderValue=100.0.obs;
  RxString classOption='Graduate'.obs;
  List<String> bookClass = ['Graduate', 'Option 2', 'Class 10', 'Option 4','Harker'];
  String normalize(String str) {
    // Remove all punctuation and spaces, and convert to lower case
    return str.replaceAll(RegExp(r'[\W_]+'), '').toLowerCase();
  }
  void applyFilters(String author) {

    filteredBooks.value = bookListing.where((book) {
      final matchesClass = book['bookClass'] == classOption.value;
      final priceRange = book['bookPrice'] <= priceSliderValue.value;
      final matchesCondition = selectedCondition.value == 1 ||
          (selectedCondition.value == 2 && book['bookCondition'] == 'New') ||
          (selectedCondition.value == 3 && book['bookCondition'] == 'Like New') ||
          (selectedCondition.value == 4 && book['bookCondition'] == 'Used');
      // final matchesAuthor = book['bookAuthor'].toLowerCase().contains(author.toLowerCase());
      final matchesAuthor = normalize(book['bookAuthor']).contains(normalize(author));
      return matchesClass && (matchesCondition || selectedCondition.value == 1) && matchesAuthor && priceRange;
    }).toList();

  }




  //
  // @override
  // void onInit() {
  //   // TODO: implement onInit
  // filteredBooks.value = bookListing;
  // bookSearchController.addListener(() {
  //   filterBooks();
  // });
  // // fetchAllListings();
  // scrollController.addListener(_scrollListener);
  //
  //
  // super.onInit();
  // }

}