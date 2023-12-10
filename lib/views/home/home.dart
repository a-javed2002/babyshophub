import 'package:babyshophub/controllers/auth_controller.dart';
import 'package:babyshophub/views/authentication/login.dart';
import 'package:babyshophub/views/common/user-scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AuthController();
  }

  @override
  Widget build(BuildContext context) {
    return UserCustomScaffold(
      appBarTitle: 'Home Page',
      body: Column(
        children: [
          Container(
            child: Center(
              child: Text('Welcome to the Home Page'),
            ),
          ),
          SizedBox(height: 20),
          CategorySlider(),
        ],
      ),
    );
  }
}

class CategorySlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<QueryDocumentSnapshot> categories = snapshot.data!.docs;

        if (categories.isEmpty) {
          return Center(
            child: Text('No categories found.'),
          );
        }

        // Only take the top 5 categories
        List<QueryDocumentSnapshot> topCategories = categories.take(5).toList();

        return CarouselSlider.builder(
          itemCount: topCategories.length + 1, // +1 for the custom text card
          itemBuilder: (context, index, realIndex) {
            if (index == topCategories.length) {
              // Last card, add custom text
              return GestureDetector(
                onTap: () {
                  // Navigate to all categories screen
                  // Add your navigation logic here
                },
                child: Card(
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      'All Categories',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              // Normal category card
              var category = topCategories[index];
              return Card(
                child: Center(
                  child: Text(category['name']),
                ),
              );
            }
          },
          options: CarouselOptions(
            height: 200,
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            aspectRatio: 16 / 9,
          ),
        );
      },
    );
  }
}

class CustomCard extends StatelessWidget {
  final Map<String, dynamic> category;

  CustomCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              category['imageUrl'],
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  category['description'].substring(0, 20),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Example usage:

// CustomCard(category: {
//   'name': 'Category Name',
//   'imageUrl': 'https://example.com/image.jpg',
 