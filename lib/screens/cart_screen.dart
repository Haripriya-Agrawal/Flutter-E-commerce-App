import 'package:flutter/material.dart';
import '../models/product.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final List<Product> cart;
  final Function(Product) removeFromCart;

  CartScreen({required this.cart, required this.removeFromCart});

  double getTotal() => cart.fold(0, (sum, item) => sum + item.price);

  @override
  Widget build(BuildContext context) {
    double total = getTotal();

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: cart.isEmpty
          ? Center(
              child: Text('Your cart is empty!',
                  style: TextStyle(fontSize: 18)),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (ctx, i) {
                      final product = cart[i];
                      return ListTile(
                        leading: Image.network(
                          product.image,
                          width: 50,
                          errorBuilder: (_, __, ___) =>
                              Icon(Icons.image_not_supported),
                        ),
                        title: Text(product.title),
                        subtitle:
                            Text('₹${product.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () => removeFromCart(product),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('₹${total.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: Icon(Icons.payment),
                        label: Text('Proceed to Checkout'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CheckoutScreen(cart: cart),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
