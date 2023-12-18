import 'package:babyshophub/consts/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistItem {
  final String productId;
  final Timestamp timestamp;

  WishlistItem({required this.productId, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'timestamp': timestamp,
    };
  }

  factory WishlistItem.fromMap(Map<String, dynamic> map) {
    return WishlistItem(
      productId: map['productId'],
      timestamp: map['timestamp'],
    );
  }
}

class WishlistController {
  static const String WishlistField = 'wishlist';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the user's UID
  Future<String?> _getUserId() async {
    final User? user = _auth.currentUser;
    return user?.uid;
  }

  Future<List<WishlistItem>> _getWishlistData(DocumentReference userDoc) async {
    final DocumentSnapshot userSnapshot = await userDoc.get();

    if (userSnapshot.exists) {
      final List<dynamic> wishlistData = userSnapshot[WishlistField];
      return wishlistData
          .map((item) => WishlistItem.fromMap(item))
          .cast<WishlistItem>()
          .toList();
    }

    return [];
  }

  Future<void> _updateWishlistData(
      DocumentReference userDoc, List<WishlistItem> wishlistData) async {
    await userDoc.set({WishlistField: wishlistData.map((item) => item.toMap()).toList()}, SetOptions(merge: true));
  }

  Future<bool> addToWishlist(String productId) async {
    try {
      final String? userId = await _getUserId();

      if (userId != null) {
        print("Fetch existing Wishlist data $userId");
        final CollectionReference users =
            FirebaseFirestore.instance.collection(userCollection);

        final DocumentReference userDoc = users.doc(userId);
        final List<WishlistItem> wishlistData = await _getWishlistData(userDoc);

        // Check if the product is already in the wishlist
        final int existingIndex =
            wishlistData.indexWhere((item) => item.productId == productId);

        if (existingIndex != -1) {
          // Product is already in the wishlist, update timestamp
          wishlistData[existingIndex] =
              WishlistItem(productId: productId, timestamp: Timestamp.now());
        } else {
          // Product is not in the wishlist, add it with a new timestamp
          wishlistData.add(
            WishlistItem(productId: productId, timestamp: Timestamp.now()),
          );
        }

        // Save updated wishlist data to Firestore
        await _updateWishlistData(userDoc, wishlistData);
        return true;
      }

      return false;
    } catch (e) {
      print('Error adding to wishlist: $e');
      return false;
    }
  }

  Future<bool> removeFromWishlist(String productId) async {
    try {
      final String? userId = await _getUserId();

      if (userId != null) {
        final CollectionReference users =
            FirebaseFirestore.instance.collection(userCollection);

        final DocumentReference userDoc = users.doc(userId);
        final List<WishlistItem> wishlistData = await _getWishlistData(userDoc);

        // Remove the product from the wishlist
        wishlistData.removeWhere((item) => item.productId == productId);

        // Save updated wishlist data to Firestore
        await _updateWishlistData(userDoc, wishlistData);
        return true;
      }

      return false;
    } catch (e) {
      print('Error removing from Wishlist: $e');
      return false;
    }
  }

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

  Future<List<WishlistItem>> getWishlistData() async {
    try {
      final String? userId = await _getUserId();

      if (userId != null) {
        final CollectionReference users =
            FirebaseFirestore.instance.collection(userCollection);

        final DocumentReference userDoc = users.doc(userId);
        return await _getWishlistData(userDoc);
      }

      return [];
    } catch (e) {
      print('Error getting wishlist data: $e');
      return [];
    }
  }

  Future<bool> isProductInWishlist(String productId) async {
    try {
      final String? userId = await _getUserId();

      if (userId != null) {
        final CollectionReference users =
            FirebaseFirestore.instance.collection(userCollection);

        final DocumentReference userDoc = users.doc(userId);
        final List<WishlistItem> wishlistData = await _getWishlistData(userDoc);

        // Check if the product is in the wishlist
        return wishlistData.any((item) => item.productId == productId);
      }

      return false;
    } catch (e) {
      print('Error checking wishlist: $e');
      return false;
    }
  }
}
