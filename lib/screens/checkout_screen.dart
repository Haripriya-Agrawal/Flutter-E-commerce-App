import 'package:flutter/material.dart';
import '../models/product.dart';

class CheckoutScreen extends StatelessWidget {
  final List<Product> cart;

  CheckoutScreen({required this.cart});

  double get subtotal => cart.fold(0, (sum, item) => sum + item.price);
  double get tax => subtotal * 0.18; // 18% GST
  double get total => subtotal + tax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: cart.isEmpty
          ? Center(child: Text('Your cart is empty!'))
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
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.image_not_supported),
                        ),
                        title: Text(product.title),
                        subtitle: Text('₹${product.price.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                Divider(thickness: 1),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildPriceRow('Subtotal', subtotal),
                      _buildPriceRow('Tax (18%)', tax),
                      _buildPriceRow('Total', total, isBold: true),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: Icon(Icons.check_circle_outline),
                        label: Text('Place Order'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Order placed successfully!')),
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

  Widget _buildPriceRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isBold ? TextStyle(fontWeight: FontWeight.bold) : null),
          Text('₹${amount.toStringAsFixed(2)}',
              style: isBold ? TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }
}
