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


}
