import 'package:cart_service/models/cart/base_cart_model.dart';

import 'package:flutter/foundation.dart';

class CartServiceCopy<T, C extends CartBaseModel<T>> {
  CartServiceCopy() {
    assert(T != dynamic,
        'You must explicitly specify the type parameter <T> when creating CartService');
  }

  final List<C> _cartItems = [];
  List<C> get cartItems => _cartItems;

  /// Method to add a single item to the cart
  /// if quantity not given default value for the product
  /// will be int quantinty =1  exmple usage cartService.addItem(CartModel(product: product))
  /// where [product] is the  product to added to cart.
  /// sample usage with quantity given cartService.addItem(CartModel(product: product,quantity: 20))
  void addItem(C item) {
    final existingIndex = _cartItems.indexWhere((e) => e.isSameItemAs(item));
    if (existingIndex != -1) {
      final updated = _cartItems[existingIndex].mergeWith(item) as C;
      _cartItems[existingIndex] = updated;
      debugPrint(
          ' updated in cart item to ${_cartItems[existingIndex].quantity}');
    } else {
      _cartItems.add(item);
      debugPrint('${item.quantity} added to cart');
    }
  }

  ///remove all related items (multiple products)
  ///Use this in case you  need to specify spicific
  ///array of cart items and not the whole cart items
  ///for this method you have to specific Cartmodel<T>
  ///where <T>  is you Productmodel (e.g CartModel<ProductModel>)
  void removeItems(List<C> itemsToRemove) {
    _cartItems.removeWhere((cartItem) {
      return itemsToRemove.any((itemToRemove) {
        return cartItem.product == itemToRemove.product;
      });
    });
  }

  ///decrement item  in the cart
  void incrementItem(C item) {
    final index = _cartItems.indexWhere((e) => e.isSameItemAs(item));
    if (index != -1) {
      final existing = _cartItems[index];
      _cartItems[index] = existing.copyWith(
        quantity: existing.quantity + 1,
      ) as C;
      debugPrint(
          "product incremented from ${existing.quantity} to ${_cartItems[index].quantity}");
    }
  }

  /// Remove single product(single product)
  /// Use this method only when you need to remove specific
  /// product form the cartitems regardless its quantity
  /// T is your specified productmodel example
  /// cartService.removeItem(ProductModel product)
  void removeItem(C item) {
    _cartItems.removeWhere((e) => e.isSameItemAs(item));
  }

  ///increment single  product on the cart
  void decrementItem(C item) {
    final index = _cartItems.indexWhere((e) => e.isSameItemAs(item));
    if (index != -1) {
      final existing = _cartItems[index];
      if (existing.quantity == 1) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index] =
            existing.copyWith(quantity: existing.quantity - 1) as C;
      }
    }
  }

  //Clear item in cart
  void clearItems() {
    _cartItems.clear();
  }
}
