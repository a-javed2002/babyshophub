import 'package:animate_do/animate_do.dart';
import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/views/Product/product-details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babyshophub/views/common/user-scaffold.dart';

class CategoryShow extends StatelessWidget {
  const CategoryShow({Key? key});

  @override
  Widget build(BuildContext context) {
    return UserCustomScaffold(
      appBarTitle: "All Categories",
      body: CategoryGrid(),
    );
  }
}

class CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(categoriesCollection)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        List<QueryDocumentSnapshot> categories = snapshot.data!.docs;

        if (categories.isEmpty) {
          return Center(
            child: Text('No categories found.'),
          );
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            var category = categories[index];
            return Card(
              child: InkWell(
                onTap: () {
                  // Handle category tap
                  print("id is ${category.id}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryPage(
                        title: category['name'],
                        image: category['imageUrl'],
                        id: category.id,
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Add category-specific widgets here
                    Text(category['name']),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CategoryPage extends StatefulWidget {
  final String? title;
  final String? image;
  final String? id;

  const CategoryPage({Key? key, this.title, this.image, this.id})
      : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("id in cat page is ${widget.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Hero(
              tag: widget.id!,
              child: Material(
                child: Container(
                  height: 360,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(.8),
                          Colors.black.withOpacity(.1),
                        ],
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FadeInUp(
                                  duration: Duration(milliseconds: 1200),
                                  child: IconButton(
                                    icon:
                                        Icon(Icons.search, color: Colors.white),
                                    onPressed: () {},
                                  ),
                                ),
                                FadeInUp(
                                  duration: Duration(milliseconds: 1200),
                                  child: IconButton(
                                    icon: Icon(Icons.favorite,
                                        color: Colors.white),
                                    onPressed: () {},
                                  ),
                                ),
                                FadeInUp(
                                  duration: Duration(milliseconds: 1300),
                                  child: IconButton(
                                    icon: Icon(Icons.shopping_cart,
                                        color: Colors.white),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 1200),
                          child: Text(
                            widget.title!,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 40),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  FadeInUp(
                    duration: Duration(milliseconds: 1400),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "New Product",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "View More",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.arrow_forward_ios,
                                size: 11, color: Colors.grey),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeInUp(
                    duration: Duration(milliseconds: 1500),
                    child: makeProduct(id: widget.id!),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget makeProduct({required String id}) {
    print("making product of id ${widget.id}");
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection(productsCollection).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        List<QueryDocumentSnapshot> products = snapshot.data!.docs;
        List<Widget> productWidgets = [];

        if (products.isEmpty) {
          return Center(
            child: Text('No products found.'),
          );
        }

        for (var product in products) {
          if (product['category_id_fk'] == id) {
            productWidgets.add(
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductDetails(productId: product.id,)),
                  );
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        product['imageUrls'],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(.8),
                          Colors.black.withOpacity(.1),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FadeInUp(
                          duration: Duration(milliseconds: 1400),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.favorite_border,
                                color: Colors.white),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FadeInUp(
                                  duration: Duration(milliseconds: 1500),
                                  child: Text(product['name'],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ),
                                FadeInUp(
                                  duration: Duration(milliseconds: 1500),
                                  child: Text(product['price'].toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            FadeInUp(
                              duration: Duration(milliseconds: 2000),
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Icon(Icons.add_shopping_cart,
                                      size: 18, color: Colors.grey[700]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }

        if (productWidgets.isEmpty) {
          return Center(
            child: Text('No products found with the specified ID.'),
          );
        }

        return Column(
          children: productWidgets,
        );
      },
    );
  }
}
