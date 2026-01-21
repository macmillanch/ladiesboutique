import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/database_service.dart';

class WishlistProvider with ChangeNotifier {
  List<Product> _items = [];
  DatabaseService? _db;
  String? _userId;
  StreamSubscription<List<Product>>? _subscription;

  List<Product> get items => _items;

  void update(DatabaseService db, String? userId) {
    _db = db;
    if (_userId != userId) {
      _userId = userId;
      _subscription?.cancel();
      if (_userId != null) {
        _subscription = _db!.getWishlist(_userId!).listen((products) {
          _items = products;
          notifyListeners();
        });
      } else {
        _items = [];
        notifyListeners();
      }
    }
  }

  bool isInWishlist(String productId) {
    return _items.any((item) => item.id == productId);
  }

  Future<void> toggleWishlist(Product product) async {
    if (_userId != null && _db != null) {
      if (isInWishlist(product.id)) {
        await _db!.removeFromWishlist(_userId!, product.id);
      } else {
        await _db!.addToWishlist(_userId!, product);
      }
    } else {
      // Local only (Guest)
      if (isInWishlist(product.id)) {
        _items.removeWhere((item) => item.id == product.id);
      } else {
        _items.add(product);
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
