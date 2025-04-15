import 'package:cart_service/cart_service.dart';
import 'package:cart_service/cart_service_copy.dart';
import 'package:cart_service/models/cart/base_cart_model.dart';
import 'package:cart_service/models/cart/cart_item.dart';
import 'package:example/models/cart_model.dart';

import 'package:example/models/product.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final CartService<ProductModel> cartService = CartService();
  final CartServiceCopy<ProductModel, CartModell> cartServiceCopy =
      CartServiceCopy();

  // Add to cart
  void addCart(CartModel<ProductModel> product) {
    cartService.addItem(product);
    // cartServiceCopy.addItem();
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
  List<CartModel<ProductModel>> get cartProducts => cartService.getItems();

// cart price
  double get totalAmount => cartService.getTotalPrice((p) => p.price);

  //remove all products
  void removeAllItems(List<CartModel<ProductModel>> products) {
    cartService.removeItems(products);
    notifyListeners();
  }

  void removeItem(ProductModel product) {
    cartService.removeItem(product);
    notifyListeners();
  }
}
