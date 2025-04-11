import 'package:cart_service/enums/request_enum.dart';
import 'package:cart_service/models/cart/cart_item.dart';
import 'package:cart_service/models/error/error.dart';
import 'package:cart_service/repository/cart_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';

class CartService<T> {
  CartService() {
    assert(T != dynamic,
        'You must explicitly specify the type parameter <T> when creating CartService');
  }

  /// List to hold cart items
  final List<CartModel<T>> _cartItems = [];

  /// Method to add a single item to the cart
  /// if quantity not given default value for the product
  /// will be int quantinty =1
  void addItem(CartModel<T> product) {
    // Check if the item is already in the cart
    final existingItemIndex =
        _cartItems.indexWhere((item) => item.product == product.product);

    if (existingItemIndex != -1) {
      // If item exists, increment the quantity
      final existingItem = _cartItems[existingItemIndex];
      _cartItems[existingItemIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + product.quantity);
      debugPrint(
          '${product.product} already in the cart, incrementing quantity.');
    } else {
      // If item doesn't exist, add it to the cart
      _cartItems.add(product);
      debugPrint('${product.product} added to the cart.');
    }
  }

  ///add multiple products to cart
  void addMultipleItems(List<CartModel<T>> items) {
    for (var item in items) {
      // Check if the product already exists in the cart
      final existingItemIndex =
          _cartItems.indexWhere((cartItem) => cartItem.product == item.product);

      if (existingItemIndex != -1) {
        // If the product exists, increment its quantity
        final existingItem = _cartItems[existingItemIndex];
        _cartItems[existingItemIndex] = existingItem.copyWith(
            quantity: existingItem.quantity + item.quantity);
        debugPrint(' Product ${item.product} exist Incrementing quantity.');
      } else {
        // If the product doesn't exist, add it to the cart
        _cartItems.add(item);
        debugPrint('Added ${item.product} to the cart.');
      }
    }
  }

  /// get map list of products in cart with their quantities
  List<Map<String, dynamic>> currentUserOrders(
      Map<String, dynamic> Function(T) toJson) {
    return _cartItems.map((item) => item.toJson(toJson)).toList();
  }

  ///increment single  product on the cart
  void incrementItem(T item) {
    final index = _cartItems.indexWhere((e) => e.product == item);

    /// throw product not found if not in the list
    assert(index != -1, 'Error: Product $item not found in the cart!');
    if (index != -1) {
      final current = _cartItems[index];
      _cartItems[index] = current.copyWith(quantity: current.quantity + 1);
    }
  }

  ///decrement item  in the cart
  void decrementItem(T item) {
    final index = _cartItems.indexWhere((e) => e.product == item);

    ///throw an error if the product was not found in the cart
    assert(index != -1, 'Error: Product $item not found in the cart!');
    if (index != -1) {
      final current = _cartItems[index];

      if (current.quantity > 1) {
        _cartItems[index] = current.copyWith(quantity: current.quantity - 1);
      } else {
        _cartItems.removeAt(index);
      }
    }
  }

  /// Remove single product(single product)
  /// Use this method only when you need to remove specific
  /// product form the cartitems regardless its quantity
  /// T is your specified productmodel example
  /// cartService.removeItem(ProductModel product)
  void removeItem(T item) {
    _cartItems.removeWhere((i) => i.product == item);
  }

  ///remove all related items (multiple products)
  ///Use this in case you  need to specify spicific
  ///array of cart items and not the whole cart items
  ///for this method you have to specific Cartmodel<T>
  ///where <T>  is you Productmodel (e.g CartModel<ProductModel>)

  void removeItems(List<CartModel<T>> itemsToRemove) {
    final toRemove =
        _cartItems.where((e) => itemsToRemove.contains(e)).toList();
    for (var item in toRemove) {
      _cartItems.remove(item);
    }
  }

  ///calculate the products total prcices
  double getTotalPrice(double Function(T product) priceExtractor) {
    double total = 0.0;
    for (var item in _cartItems) {
      total += priceExtractor(item.product) * item.quantity;
    }
    return total;
  }

  /// Return all items in  cart
  List<CartModel<T>> getItems() {
    return _cartItems;
  }

  ///method to clear all cart
  void clearCart() {
    _cartItems.clear();
  }

  ///return user carts list  from APi
  List<CartModel<T>> userOrder(
      List<dynamic> data, T Function(Map<String, dynamic>) fromJson) {
    List<CartModel<T>> list = [];
    try {
      for (var i in data) {
        list.add(CartModel.fromJson(i, fromJson));
      }
      return list;
    } catch (e, stack) {
      debugPrint("Errror occured while adding data to cart:$stack");
      rethrow;
    }
  }

  /// send cart order to server
  /// http method is default post if no  method selected from [RequestEnum]
  /// params are null by default  and token are null by default
  Future<Either<ErrorMap, List<T>>> serverRequest({
    RequestEnum method = RequestEnum.post,
    Map<String, dynamic>? params,
    String? token,
    required T Function(Map<String, dynamic>) fromJson,
    required String endPoint,
  }) async {
    try {
      switch (method) {
        case RequestEnum.get:
          debugPrint(
              "📥 Sending GET request for endpoint: $endPoint with params: $params");
          return await CartRepository<T>().productItems(
            endPoint: endPoint,
            token: token,
            params: params,
            fromJson: fromJson,
          );

        case RequestEnum.post:
          debugPrint("📤 Sending POST request with params: $params");
          // TODO: Implement POST logic
          return Left(ErrorMap());

        case RequestEnum.delete:
          debugPrint("🗑️ Sending DELETE request with params: $params");
          // TODO: Implement DELETE logic
          return Left(ErrorMap());

        case RequestEnum.put:
          debugPrint("🛠️ Sending PUT request with params: $params");
          // TODO: Implement PUT logic
          return Left(ErrorMap());
      }
    } catch (e, stack) {
      debugPrint("🔥 Exception in serverRequest: $e");
      debugPrint("🧱 Stack Trace: $stack");
      rethrow;
    }
  }
}
