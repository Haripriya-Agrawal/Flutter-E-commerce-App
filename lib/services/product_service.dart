import 'package:flutter/material.dart';
import '../models/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  static Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<Product> fetchProductById(int id) async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  static Future<List<Product>> searchProducts(String query) async {
    final products = await fetchProducts();
    return products.where((product) =>
      product.title.toLowerCase().contains(query.toLowerCase()) ||
      product.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
