import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController {
  static const String cartKey = 'cart';

  // Store product data in an array object in SharedPreferences (store productId, quantity)
Future<bool> addToCart(String productId, int quantity) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> cartData = [];

    // Fetch existing cart data
    if (prefs.containsKey(cartKey)) {
      cartData = List<Map<String, dynamic>>.from(
        json.decode(prefs.getString(cartKey)!),
      );
    }

    // Fetch additional data from Firestore for the product
    DocumentSnapshot productSnapshot =
        await FirebaseFirestore.instance.collection('products').doc(productId).get();

    // Check if the product is already in the cart
    int existingIndex =
        cartData.indexWhere((item) => item['productId'] == productId);

    if (existingIndex != -1) {
      // Product is already in the cart, update quantity
      cartData[existingIndex]['quantity'] += quantity;
    } else {
      // Product is not in the cart, add it with additional data
      cartData.add({
        'productId': productId,
        'quantity': quantity,
        'selected': true,
        'cat_id_fk': productSnapshot['category_id_fk'],
        'imageUrls': productSnapshot['imageUrls'],
        'name': productSnapshot['name'],
        'price': productSnapshot['price'],
        'status': productSnapshot['status'],
      });
    }

    // Save updated cart data to SharedPreferences
    prefs.setString(cartKey, json.encode(cartData));
    return true;
  } catch (e) {
    print('Error adding to cart: $e');
    return false;
  }
}

  // Remove a single product from SharedPreferences by productId
  Future<bool> removeFromCart(String productId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey(cartKey)) {
        List<Map<String, dynamic>> cartData = List<Map<String, dynamic>>.from(
            json.decode(prefs.getString(cartKey)!));

        // Remove the product from the cart
        cartData.removeWhere((item) => item['productId'] == productId);

        // Save updated cart data to SharedPreferences
        prefs.setString(cartKey, json.encode(cartData));
      }

      return true;
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }

  // Remove all products from the cart
  Future<bool> clearCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(cartKey);
      return true;
    } catch (e) {
      print('Error clearing cart: $e');
      return false;
    }
  }

  // Get the array object from SharedPreferences
  // Future<List<Map<String, dynamic>>> getCartData() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     if (prefs.containsKey(cartKey)) {
  //       return List<Map<String, dynamic>>.from(
  //         json.decode(prefs.getString(cartKey)!),
  //       );
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     print('Error getting cart data: $e');
  //     return [];
  //   }
  // }

  Future<List<Map<String, dynamic>>> getCartData() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(cartKey)) {
      List<Map<String, dynamic>> cartData = List<Map<String, dynamic>>.from(
        json.decode(prefs.getString(cartKey)!),
      );

      // Sort cartData based on cat_id_fk in ascending order
      cartData.sort((a, b) => (a['cat_id_fk']).compareTo(b['cat_id_fk']));

      return cartData;
    } else {
      return [];
    }
  } catch (e) {
    print('Error getting cart data: $e');
    return [];
  }
}

  // Increment the quantity of a product in the cart
  Future<bool> incrementQuantity(String productId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey(cartKey)) {
        List<Map<String, dynamic>> cartData = List<Map<String, dynamic>>.from(
            json.decode(prefs.getString(cartKey)!));

        // Find the product in the cart
        int existingIndex =
            cartData.indexWhere((item) => item['productId'] == productId);

        if (existingIndex != -1) {
          // Increment the quantity
          cartData[existingIndex]['quantity'] += 1;

          // Save updated cart data to SharedPreferences
          prefs.setString(cartKey, json.encode(cartData));
        }
      }

      return true;
    } catch (e) {
      print('Error incrementing quantity: $e');
      return false;
    }
  }

  // Decrement the quantity of a product in the cart
  Future<bool> decrementQuantity(String productId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey(cartKey)) {
        List<Map<String, dynamic>> cartData = List<Map<String, dynamic>>.from(
            json.decode(prefs.getString(cartKey)!));

        // Find the product in the cart
        int existingIndex =
            cartData.indexWhere((item) => item['productId'] == productId);

        if (existingIndex != -1) {
          // Decrement the quantity, ensuring it doesn't go below 1
          cartData[existingIndex]['quantity'] =
              (cartData[existingIndex]['quantity'] > 1)
                  ? cartData[existingIndex]['quantity'] - 1
                  : 1;

          // Save updated cart data to SharedPreferences
          prefs.setString(cartKey, json.encode(cartData));
        }
      }

      return true;
    } catch (e) {
      print('Error decrementing quantity: $e');
      return false;
    }
  }

  // Check if a product is present in the cart by productId
  Future<bool> isProductInCart(String productId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey(cartKey)) {
        List<Map<String, dynamic>> cartData = List<Map<String, dynamic>>.from(
            json.decode(prefs.getString(cartKey)!));

        // Check if the product is in the cart
        return cartData.any((item) => item['productId'] == productId);
      }

      return false;
    } catch (e) {
      print('Error checking if product is in cart: $e');
      return false;
    }
  }
}
