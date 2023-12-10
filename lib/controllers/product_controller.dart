// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class ProductController {
//   var quantity = 0;
//   var colorIndex = 0;
//   var totalPrice = 0;
//   var isFav = false;

//   var subCat = [];
//   getSubCatgories(title) async {
//     subCat.clear();
//     var data = await rootBundle.loadString("lib/services/category_model.json");
//     var decoded = categoryModelFromJson(data);
//     var s =
//         decoded.categories.where((element) => element.name == title).toList();
//     for (var e in s[0].subcategory) {
//       subCat.add(e);
//     }
//   }

//   changeColorIndex(index) {
//     colorIndex = index;
//   }

//   incrementQuantity(totalQuantity) {
//     if (quantity.value < totalQuantity) {
//       quantity.value++;
//     }
//   }

//   decrementQuantity() {
//     if (quantity.value > 0) {
//       quantity.value--;
//     }
//   }

//   calculateTotalPrice(price) {
//     totalPrice.value = price * quantity.value;
//   }

//   addToCart({title, img, sellername, color, qty, tprice, context,vendorID}) async {
//     await firestore.collection(cartCollection).doc().set({
//       'title': title,
//       'img': img,
//       'sellername': sellername,
//       'color': color,
//       'qty': qty,
//       'tprice': tprice,
//       'vendor_id': vendorID,
//       'added_by': currentUser!.uid,
//     }).catchError((error) {
//       VxToast.show(context, msg: error.toString());
//     });
//   }

//   resetValues() {
//     totalPrice.value = 0;
//     quantity.value = 0;
//     colorIndex.value = 0;
//   }

//   addToWishlist(docId,context) async {
//     await firestore.collection(productsCollection).doc(docId).set({
//       'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
//     }, SetOptions(merge: true));
//     isFav(true);
//     VxToast.show(context, msg: "Added To Wishlist", showTime: 3000);
//   }

//   removeFromWishlist(docId,context) async {
//     await firestore.collection(productsCollection).doc(docId).set({
//       'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
//     }, SetOptions(merge: true));
//     isFav(false);
//     VxToast.show(context, msg: "Remove From Wishlist", showTime: 3000);
//   }

//   checkIfFav(data) async {
//     if (data['p_wishlist'].contains(currentUser!.uid)) {
//       isFav(true);
//     } else {
//       isFav(false);
//     }
//   }
// }
