import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';

class WishlistScreen extends StatelessWidget {
  final List<Product> wishlist;
  final Function(Product) addToCart;
  final Function(Product) removeFromWishlist;

  const WishlistScreen({
    required this.wishlist,
    required this.addToCart,
    required this.removeFromWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist", style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal,
      ),
      body: wishlist.isEmpty
          ? Center(
              child: Text(
                'Your wishlist is empty 🐾',
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: wishlist.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final product = wishlist[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            product.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${product.price.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () => removeFromWishlist(product),
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                ),
                                IconButton(
                                  onPressed: () => addToCart(product),
                                  icon: const Icon(Icons.add_shopping_cart, color: Colors.teal),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
