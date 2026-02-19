import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> products = [];
  bool isLoading = false;
  String? error;

  Future<void> loadProducts() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final res = await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        products = data.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        error = 'Failed to load products (${res.statusCode})';
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}