import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  void addItem(Product product, String size, String color, int quantity) {
    // Check if exists
    // For simplicity, just add.
    _items.add(
      CartItem(
        productId: product.id,
        name: product.name,
        price: product.discountedPrice,
        selectedSize: size,
        selectedColor: color,
        quantity: quantity,
        image: product.images.isNotEmpty ? product.images.first : '',
      ),
    );
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
