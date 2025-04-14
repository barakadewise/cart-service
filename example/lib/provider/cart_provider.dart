import 'package:cart_service/cart_service.dart';
import 'package:cart_service/models/cart/cart_item.dart';
import 'package:example/models/product.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final CartService<ProductModel, Null> cartService = CartService();

  // Add to cart
  void addCart(CartModel<ProductModel, Null> product) {
    cartService.addItem(product);
    notifyListeners();
  }

  // Remove from cart
  void removeCart(ProductModel product) {
    cartService.removeItem(product);
    notifyListeners();
  }

  // Increment quantity
  void incrementCartItem(ProductModel product) {
    cartService.incrementItem(product);
    notifyListeners();
  }

  // Decrement quantity
  void decrementCartItem(ProductModel product) {
    cartService.decrementItem(product);
    notifyListeners();
  }

  // Clear all items
  void clearCart() {
    cartService.clearCart();
    notifyListeners();
  }

  // Get cart items directly from service
  List<CartModel<ProductModel, Null>> get cartProducts =>
      cartService.getItems();

// cart price
  double get totalAmount => cartService.getTotalPrice((p) => p.price);

  //remove all products
  void removeAllItems(List<CartModel<ProductModel, Null>> products) {
    cartService.removeItems(products);
    notifyListeners();
  }

  void removeItem(ProductModel product) {
    cartService.removeItem(product);
    notifyListeners();
  }
}
