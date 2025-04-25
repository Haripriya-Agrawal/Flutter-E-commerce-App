// main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/product_list_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/wishlist_screen.dart';
import 'models/product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  List<Product> _cart = [];
  List<Product> _wishlist = [];
  List<Product> _localProducts = [];

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
  }

  void _addToCart(Product product) {
    setState(() => _cart.add(product));
  }

  void _removeFromCart(Product product) {
    setState(() => _cart.remove(product));
  }

  void _addToWishlist(Product product) {
    setState(() {
      if (!_wishlist.contains(product)) _wishlist.add(product);
    });
  }

  void _removeFromWishlist(Product product) {
    setState(() => _wishlist.remove(product));
  }

  void _addLocalProduct(Product product) {
    setState(() => _localProducts.add(product));
  }

  void _editLocalProduct(Product updatedProduct) {
    setState(() {
      final index = _localProducts.indexWhere((p) => p.id == updatedProduct.id);
      if (index != -1) _localProducts[index] = updatedProduct;
    });
  }

  void _deleteLocalProduct(Product product) {
    setState(() => _localProducts.removeWhere((p) => p.id == product.id));
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      primaryColor: Color(0xFFf9a825),
      scaffoldBackgroundColor: Color.fromARGB(255,255, 253, 236),
      appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(255,134, 167, 136),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Color.fromARGB(255, 249, 168, 37),
        secondary: Color(0xFF6d4c41),
      ),
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFFf9a825),
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      scaffoldBackgroundColor: Color(0xFF121212),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF1F1F1F),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );

    return MaterialApp(
      theme: _isDarkMode ? darkTheme : baseTheme,
      routes: {
        '/cart': (context) => CartScreen(cart: _cart, removeFromCart: _removeFromCart),
        '/profile': (context) => ProfileScreen(),
        '/wishlist': (context) => WishlistScreen(
              wishlist: _wishlist,
              addToCart: _addToCart,
              removeFromWishlist: _removeFromWishlist,
            ),
      },
      home: ProductListScreen(
        cart: _cart,
        wishlist: _wishlist,
        addToCart: _addToCart,
        addToWishlist: _addToWishlist,
        removeFromWishlist: _removeFromWishlist,
        toggleTheme: _toggleTheme,
        localProducts: _localProducts,
        addLocalProduct: _addLocalProduct,
        editLocalProduct: _editLocalProduct,
        deleteLocalProduct: _deleteLocalProduct,
      ),
    );
  }
}
