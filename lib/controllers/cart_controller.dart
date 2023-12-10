import 'dart:convert';
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

      // Check if the product is already in the cart
      int existingIndex =
          cartData.indexWhere((item) => item['productId'] == productId);

      if (existingIndex != -1) {
        // Product is already in the cart, update quantity
        cartData[existingIndex]['quantity'] += quantity;
      } else {
        // Product is not in the cart, add it
        cartData.add({'productId': productId, 'quantity': quantity});
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
  Future<List<Map<String, dynamic>>> getCartData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(cartKey)) {
        return List<Map<String, dynamic>>.from(
          json.decode(prefs.getString(cartKey)!),
        );
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting cart data: $e');
      return [];
    }
  }
}
