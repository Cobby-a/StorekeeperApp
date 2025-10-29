import 'package:flutter/material.dart';
import '../models/product.dart';
import '../database/database_helper.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Product> get products => _searchQuery.isEmpty ? _products : _filteredProducts;
  bool get isLoading => _isLoading;
  int get productCount => _products.length;
  
  double get totalInventoryValue {
    return _products.fold(0.0, (sum, product) => sum + (product.price * product.quantity));
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await DatabaseHelper.instance.getAllProducts();
      if (_searchQuery.isNotEmpty) {
        _filterProducts(_searchQuery);
      }
    } catch (e) {
      debugPrint('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProduct(Product product) async {
    try {
      final newProduct = await DatabaseHelper.instance.createProduct(product);
      _products.insert(0, newProduct);
      if (_searchQuery.isNotEmpty) {
        _filterProducts(_searchQuery);
      }
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding product: $e');
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      await DatabaseHelper.instance.updateProduct(product);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product.copyWith(updatedAt: DateTime.now());
        if (_searchQuery.isNotEmpty) {
          _filterProducts(_searchQuery);
        }
        notifyListeners();
      }
      return true;
    } catch (e) {
      debugPrint('Error updating product: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await DatabaseHelper.instance.deleteProduct(id);
      _products.removeWhere((product) => product.id == id);
      if (_searchQuery.isNotEmpty) {
        _filterProducts(_searchQuery);
      }
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting product: $e');
      return false;
    }
  }

  void searchProducts(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredProducts = [];
    } else {
      _filterProducts(query);
    }
    notifyListeners();
  }

  void _filterProducts(String query) {
    _filteredProducts = _products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredProducts = [];
    notifyListeners();
  }

  Product? getProductById(int id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}