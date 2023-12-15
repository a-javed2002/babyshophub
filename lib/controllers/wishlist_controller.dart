import 'package:babyshophub/consts/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistController {
  static const String WishlistField = 'wishlist';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the user's UID
  Future<String?> _getUserId() async {
    final User? user = _auth.currentUser;
    return user?.uid;
  }

  // Store product data in an array object in Firestore (store productId, timestamp)
  Future<bool> addToWishlist(String productId) async {
    try {
      final String? userId = await _getUserId();

      if (userId != null) {
        final CollectionReference users =
            FirebaseFirestore.instance.collection(userCollection);

        // Fetch existing Wishlist data
        DocumentSnapshot userSnapshot = await users.doc(userId).get();
        List<Map<String, dynamic>> WishlistData = [];

        if (userSnapshot.exists) {
          WishlistData = List<Map<String, dynamic>>.from(userSnapshot[WishlistField]);
        }

        // Check if the product is already in the cart
        int existingIndex =
            WishlistData.indexWhere((item) => item['productId'] == productId);

        if (existingIndex != -1) {
          // Product is already in the cart, update timestamp
          WishlistData[existingIndex]['timestamp'] = FieldValue.serverTimestamp();
        } else {
          // Product is not in the cart, add it
          WishlistData.add({'productId': productId, 'timestamp': FieldValue.serverTimestamp()});
        }

        // Save updated cart data to Firestore
        await users.doc(userId).set({WishlistField: WishlistData}, SetOptions(merge: true));
        return true;
      }

      return false;
    } catch (e) {
      print('Error adding to wishlist: $e');
      return false;
    }
  }

  // Remove a single product from Firestore by productId
  Future<bool> removeFromWishlist(String productId) async {
    try {
      final String? userId = await _getUserId();

      if (userId != null) {
        final CollectionReference users =
            FirebaseFirestore.instance.collection(userCollection);

        // Fetch existing cart data
        DocumentSnapshot userSnapshot = await users.doc(userId).get();
        List<Map<String, dynamic>> WishlistData = [];

        if (userSnapshot.exists) {
          WishlistData = List<Map<String, dynamic>>.from(userSnapshot[WishlistField]);

          // Remove the product from the cart
          WishlistData.removeWhere((item) => item['productId'] == productId);

          // Save updated cart data to Firestore
          await users.doc(userId).set({WishlistField: WishlistData}, SetOptions(merge: true));
        }

        return true;
      }

      return false;
    } catch (e) {
      print('Error removing from Wishlist: $e');
      return false;
    }
  }

  // Remove all products from the Wishlist in Firestore
  Future<bool> clearWishlist() async {
    try {
      final String? userId = await _getUserId();

      if (userId != null) {
        final CollectionReference users =
            FirebaseFirestore.instance.collection(userCollection);

        // Clear the Wishlist data in Firestore
        await users.doc(userId).set({WishlistField: []}, SetOptions(merge: true));
      }

      return true;
    } catch (e) {
      print('Error clearing wishlist: $e');
      return false;
    }
  }

  // Get the array object from Firestore
  Future<List<Map<String, dynamic>>> getWishlistData() async {
    try {
      final String? userId = await _getUserId();

      if (userId != null) {
        final CollectionReference users =
            FirebaseFirestore.instance.collection(userCollection);

        // Fetch wishlist data from Firestore
        DocumentSnapshot userSnapshot = await users.doc(userId).get();

        if (userSnapshot.exists) {
          return List<Map<String, dynamic>>.from(userSnapshot[WishlistField]);
        }
      }

      return [];
    } catch (e) {
      print('Error getting wishlist data: $e');
      return [];
    }
  }

    // Check if a product with a given productId is present in the wishlist
  Future<bool> isProductInWishlist(String productId) async {
    try {
      final String? userId = await _getUserId();

      if (userId != null) {
        final CollectionReference users =
            FirebaseFirestore.instance.collection(userCollection);

        // Fetch wishlist data from Firestore
        DocumentSnapshot userSnapshot = await users.doc(userId).get();

        if (userSnapshot.exists) {
          List<Map<String, dynamic>> wishlistData =
              List<Map<String, dynamic>>.from(userSnapshot[WishlistField]);

          // Check if the product is in the wishlist
          return wishlistData.any((item) => item['productId'] == productId);
        }
      }

      return false;
    } catch (e) {
      print('Error checking wishlist: $e');
      return false;
    }
  }
}
