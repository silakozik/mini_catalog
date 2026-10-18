import 'package:flutter/foundation.dart';
import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  // Rozet için toplam ürün adedi
  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);

  // Sepet toplamı: fiyat x adet
  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.product.price * item.quantity);

  void add(Product product) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index == -1) {
      _items.add(CartItem(product: product));
    } else {
      _items[index].quantity++;
    }
    notifyListeners();
  }

  void decrease(Product product) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index == -1) return;
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// Uygulama genelinde paylaşılan tek sepet 
final CartModel cart = CartModel();