import 'package:babyshophub/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:babyshophub/views/common/user-scaffold.dart';
import 'package:babyshophub/controllers/cart_controller.dart';
import 'package:babyshophub/controllers/wishlist_controller.dart';
import 'package:babyshophub/views/Product/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetails extends StatefulWidget {
  String productId;

  ProductDetails({required this.productId});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late Future<Map<String, dynamic>> productDetailsFuture;
  late Future<List<Map<String, dynamic>>> allCategoriesFuture;
  late CartController _controllerCart;
  late WishlistController _controllerWishlist;
  bool productIsInCart = false;
  bool productIsInWishlist = false;
  TextEditingController reviewMessageController = TextEditingController();
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
    productDetailsFuture = fetchProductDetails(widget.productId);
    allCategoriesFuture = fetchAllCategories();
    _controllerCart = CartController();
    _controllerWishlist = WishlistController();
    chk();
  }

  void chk() async {
    productIsInCart = await _controllerCart.isProductInCart(widget.productId);
    productIsInWishlist =
        await _controllerWishlist.isProductInWishlist(widget.productId);
  }

  Future<Map<String, dynamic>> fetchProductDetails(String productId) async {
    final productSnapshot = await FirebaseFirestore.instance
        .collection(productsCollection)
        .doc(productId)
        .get();

    final categoryId = productSnapshot['category_id_fk'];
    final categoryName = await getCategoryName(categoryId);

    return {
      'productDetails': productSnapshot.data(),
      'categoryName': categoryName,
    };
  }

  Future<List<Map<String, dynamic>>> fetchAllCategories() async {
    final categoriesSnapshot =
        await FirebaseFirestore.instance.collection(categoriesCollection).get();

    final categories =
        categoriesSnapshot.docs.map((doc) => doc.data()).toList();

    return categories;
  }

  Future<String> getCategoryName(String categoryId) async {
    final categorySnapshot = await FirebaseFirestore.instance
        .collection(categoriesCollection)
        .doc(categoryId)
        .get();

    return categorySnapshot['name'];
  }

  Future<void> toggleWishlistStatus(String productId) async {
    bool temp;
    if (productIsInWishlist) {
      print("Removing Wishlist...");
      temp = await _controllerWishlist.removeFromWishlist(productId);
    } else {
      print("Adding Wishlist...");
      temp = await _controllerWishlist.addToWishlist(productId);
    }

    setState(() {
      // Toggle the wishlist status
      productIsInWishlist = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserCustomScaffold(
      appBarTitle: "Product Details",
      body: FutureBuilder<Map<String, dynamic>>(
        future: productDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final productDetails = snapshot.data!['productDetails'];
          final categoryName = snapshot.data!['categoryName'];

          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildImageSlider(productDetails['imageUrls']),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              productDetails['name'],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(onPressed: (){
                              _sendMessage(imageUrl: productDetails['imageUrls'][0],msg: "What You Want To Know?",sender_id: productDetails['addedBy']);
                            }, icon: Icon(Icons.chat_bubble))
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price: \$${productDetails['price']}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await toggleWishlistStatus(widget.productId);
                                showToast(
                                  productIsInWishlist
                                      ? 'Added to Wishlist'
                                      : 'Removed from Wishlist',
                                );
                              },
                              child: Image.asset(
                                productIsInWishlist
                                    ? 'assets/images/heart_filled.jpg'
                                    : 'assets/images/heart_empty.jpg',
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Category: $categoryName',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Description:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          productDetails['description'],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle buy now action
                                showToast('Buy Now');
                              },
                              child: Lottie.asset(
                                'assets/animations/main.json',
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (await _controllerCart.addToCart(
                                    widget.productId, 1)) {
                                  showToast(
                                    productIsInCart
                                        ? 'Already In Cart'
                                        : 'Added to Cart',
                                  );
                                  setState(() {
                                    productIsInCart = true;
                                  });
                                } else {
                                  showToast('Error Add To Cart');
                                }
                              },
                              child: Text(
                                'Add to Cart',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  buildReviewSection(productId: widget.productId),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildImageSlider(List<dynamic> imageUrls) {
    return CarouselSlider(
      items: imageUrls.map((imageUrl) {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        );
      }).toList(),
      options: CarouselOptions(
        height: 200,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
      ),
    );
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  void _sendMessage({String? imageUrl,String? msg,String?sender_id}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    // String messageText = _messageController.text.trim();
    // if (messageText.isNotEmpty || imageUrl != null) {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(_getChatId(currentUserUid: sender_id,recipientUid: _auth.currentUser!.uid))
          .collection('messages')
          .add({
            'sender': sender_id,
            'text': msg,
            'imageUrl': imageUrl,
            'timestamp': FieldValue.serverTimestamp(),
          });

      // _messageController.clear();
      // setState(() {
      //   _isEmojiPickerVisible = false;
      // });
    // }
  }

  String _getChatId({required String?currentUserUid,required String?recipientUid}) {
    // Create a unique chat ID based on user UIDs
    List<String> participantUids = [currentUserUid!, recipientUid!];
    participantUids.sort();
    return participantUids.join('_');
  }

  Widget buildReviewSection({required String productId}) {
    return Column(
      children: [
        // Display reviews (if any)
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(productsCollection)
              .doc(productId)
              .collection('reviews')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            final reviews = snapshot.data!.docs;

            if (reviews.isEmpty) {
              return Text('No reviews yet.');
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Reviews',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                // Display each review
                ...reviews.map((review) {
                  final reviewData = review.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(reviewData['message']),
                    subtitle: Text('User ID: ${reviewData['userId']}'),
                    // You can display the image and rating here
                  );
                }),
              ],
            );
          },
        ),
        // Form to submit a new review
        buildReviewForm(productId: productId),
      ],
    );
  }

  Widget buildReviewForm({required String productId}) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Write a Review',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: reviewMessageController,
            decoration: InputDecoration(
              labelText: 'Review Message',
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Rating: ',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              // Add a rating widget (e.g., stars) here
              RatingBar.builder(
                initialRating: rating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  setState(() {
                    rating = newRating;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Call a function to submit the review
              submitReview(productId);
            },
            child: Text('Submit Review'),
          ),
        ],
      ),
    );
  }

  Future<void> submitReview(String productId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get the user ID
        final userId = user.uid;

        // Prepare the review data
        final reviewData = {
          'userId': userId,
          'message': reviewMessageController.text,
          'rating': rating,
          // Add other fields if needed
        };

        // Submit the review to the "reviews" subcollection
        await FirebaseFirestore.instance
            .collection(productsCollection)
            .doc(productId)
            .collection('reviews')
            .add(reviewData);

        // Clear the form after submission
        reviewMessageController.clear();
        setState(() {
          rating = 0.0;
        });

        // Optional: Display a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Review submitted successfully!'),
          ),
        );
      }
    } catch (e) {
      // Handle errors
      print('Error submitting review: $e');
    }
  }
}
