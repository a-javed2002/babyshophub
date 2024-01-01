import 'package:babyshophub/views/Product/checkout.dart';
import 'package:flutter/material.dart';

class ProductDetailsPopup extends StatefulWidget {
  final String productId;
  final String productName;
  final double productPrice;
  final String productImage;

  ProductDetailsPopup({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
  });

  @override
  _ProductDetailsPopupState createState() => _ProductDetailsPopupState();
}

class _ProductDetailsPopupState extends State<ProductDetailsPopup> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            widget.productImage,
            width: 120,
            height: 120,
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.productName),
                Text('Price: \$${widget.productPrice.toString()}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                ),
                Text('$quantity'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen([
                      {
                        "productId": widget.productId,
                        "quantity": quantity,
                        "name": widget.productName,
                        "price": widget.productPrice,
                        "imageUrls": widget.productName,
                      }
                    ]),
                  ),
                );
                Navigator.pop(context); // Close the pop-up
              },
              child: Text('Buy Now'),
            ),
          ),
        ],
      ),
    );
  }
}
