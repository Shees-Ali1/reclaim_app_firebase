import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:get/state_manager.dart';
import 'package:timeago/timeago.dart' as timeago;

class WishlistController extends GetxController {
  var favorites = <String>[].obs;
  var favorites1 = <Map<String, dynamic>>[].obs;

  Future<List<Map<String, dynamic>>> fetchWishlistProducts() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var wishlistRef = FirebaseFirestore.instance
        .collection('userDetails')
        .doc(userId)
        .collection('wishlist');

    // Fetch all products in the wishlist
    var snapshot = await wishlistRef.get();

    List<Map<String, dynamic>> wishlistProducts = [];

    for (var doc in snapshot.docs) {
      var productId = doc.id;

      // Fetch product details from the main 'products' collection
      var productSnapshot = await FirebaseFirestore.instance
          .collection('productsListing')
          .doc(productId)
          .get();

      if (productSnapshot.exists) {
        wishlistProducts.add(productSnapshot.data()!);
      }
    }

    return wishlistProducts;
  }

  Future<void> removeFromWishlist(String productId) async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var wishlistRef = FirebaseFirestore.instance
        .collection('userDetails')
        .doc(userId)
        .collection('wishlist');

    // Remove from wishlist
    await wishlistRef.doc(productId).delete();

    final filteredUsersIndex =
        favorites1.indexWhere((product) => product['listingId'] == productId);
    if (filteredUsersIndex != -1) {
      favorites1.removeAt(filteredUsersIndex);
    }
    favorites1.refresh();
    favorites.remove(productId);
  }

  // **************Freee**********
  RxInt walletbalance = 0.obs;

  Future<void> fetchuserwallet() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('wallet')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (documentSnapshot.exists) {
        dynamic list = documentSnapshot.data();
        walletbalance.value = list['balance'];
        print(walletbalance.value);
      } else {
        // Handle case where the document does not exist
        print("Wallet document does not exist.");
      }
    } catch (e) {
      // Handle errors
      print("An error occurred while fetching the wallet: $e");
    }
  }

  Future<void> updatebalance(int purchasePrice) async {
    try {
      // int appFees = (purchasePrice * 0.2).round();
      // int finalPrice = purchasePrice - appFees;
      int newbalance = walletbalance.value - purchasePrice;
      await FirebaseFirestore.instance
          .collection('wallet')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'balance': newbalance});
      await storetransactionhistory(purchasePrice, 'buy', 'Walmart');
    } catch (e) {
      print('Error update balance$e');
    }
  }

  Future<void> storetransactionhistory(
      int purchasePrice, String purchaseType, String purchaseName) async {
    try {
      await FirebaseFirestore.instance
          .collection('wallet')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('transaction')
          .add({
        'purchasePrice': purchasePrice,
        'purchaseDate': DateTime.timestamp(),
        'purchaseName': purchaseName,
        'purchaseType': purchaseType
      });
    } catch (e) {
      print('Error storeTransaction$e');
    }
  }

  Future<void> storetopup(int purchasePrice) async {
    try {
      await FirebaseFirestore.instance
          .collection('wallet')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'balance': purchasePrice,
      });
    } catch (e) {
      print('Error storeTransaction$e');
    }
  }

  RxList<dynamic> transaction = [].obs;
  Future<void> transactionfetch() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('wallet')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('transaction')
        .orderBy('purchaseDate', descending: true)
        .get();

    transaction.clear();
    data.docs.forEach((tran) {
      transaction.add({
        'purchasePrice': tran['purchasePrice'],
        'purchaseName': tran['purchaseName'],
        'purchaseDate': tran['purchaseDate'],
        'purchaseType': tran['purchaseType'],
      });
    });
  }

  String formattransactionTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();

    Duration difference = now.difference(dateTime);
    if (difference.inDays == 0) {
      return 'Today ${dateTime.hour}:${dateTime.minute}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${dateTime.hour}:${dateTime.minute}';
    } else {
      return timeago.format(dateTime);
    }
  }
  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   fetchuserwallet();
  // }
}
