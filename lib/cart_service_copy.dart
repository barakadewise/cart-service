import 'package:cart_service/config/network_config.dart';
import 'package:cart_service/config/request.dart';
import 'package:cart_service/models/cart/base_cart_model.dart';
import 'package:cart_service/models/error/error.dart';
import 'package:either_dart/either.dart';

import 'package:flutter/foundation.dart';

/// A generic and flexible cart service for managing cart items and performing
/// product-related operations, such as adding/removing items and fetching from APIs.
///
/// This service is designed to support any cart item that extends [CartBaseModel<T>].
/// - [T] is the type of the underlying product model (e.g., ProductModel)
/// - [C] is the specific cart item model extending [CartBaseModel<T>]
///
/// ## Example usage:
/// ```dart
/// final cartService = CartServiceCopy<ProductModel, CartModell>();
/// cartService.addItem(CartModell(product: product, quantity: 1));
/// ```
///
/// Make sure your cart model:
/// - Implements `isSameItemAs()` to compare similar cart entries
/// - Implements `mergeWith()` to combine duplicate cart entries
/// - Provides a `copyWith()` method for immutability
class CartServiceCopy<T, C extends CartBaseModel<T>> {
  /// Constructor enforces explicit typing of [T] to avoid runtime type errors.
  CartServiceCopy() {
    assert(T != dynamic,
        'You must explicitly specify the type parameter <T> when creating CartService');
  }

  /// Internal list storing cart items
  final List<C> _cartItems = [];

  /// Internal list storing products
  final List<C> _products = [];

  /// Public getter to expose cart items
  List<C> get cartItems => _cartItems;

  /// Public getter to expose products
  List<C> get products => _products;

  /// Adds a new item to the cart.
  /// If an equivalent item exists (based on `isSameItemAs()`), it merges quantities.
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

  /// Removes a list of items from the cart by matching their product.
  void removeItems(List<C> itemsToRemove) {
    _cartItems.removeWhere((cartItem) {
      return itemsToRemove.any((itemToRemove) {
        return cartItem.product == itemToRemove.product;
      });
    });
  }

  /// Increments the quantity of a single item in the cart.
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

  /// Removes a specific item from the cart completely.
  void removeItem(C item) {
    _cartItems.removeWhere((e) => e.isSameItemAs(item));
  }

  /// Decrements the quantity of an item in the cart.
  /// If quantity reaches 0 or less, the item is removed.
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

  /// Clears all items from the cart.
  void clearItems() {
    _cartItems.clear();
  }

  /// Fetches a list of products from the server.
  ///
  /// - [dataKey] – key under which the list exists in the response (default: 'products')
  /// - [params] – optional query parameters
  /// - [extraHeaders] – optional headers
  /// - [token] – authentication token
  /// - [endPoint] – API endpoint path
  /// - [fromJson] – factory method to convert map to [T]
  Future<Either<ErrorMap, List<T>>> getProducts({
    String? dataKey,
    Map<String, dynamic>? params,
    Map<String, dynamic>? extraHeaders,
    String? token,
    required String endPoint,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    Map errorMap = {};
    try {
      var res = await ApplicationBaseRequest.get(
        CartNetworkConfig.baseUrl,
        endPoint,
        extraHeaders: extraHeaders,
        params: params,
        token: token ?? "",
      ).request();

      if (res.status ~/ 100 == 2 && res.data[CartNetworkConfig.apiSuccessKey]) {
        List<dynamic> data = res.data[dataKey ?? 'products'];
        debugPrint("Products are: ${res.data}");
        return Right(data.map((e) => fromJson(e)).toList());
      } else {
        errorMap = res.data;
        return Left(ErrorMap(errorMap: res.data));
      }
    } catch (e, stack) {
      debugPrint(
          "Exception caught: Server response $errorMap\nStacktrace:\n$stack");
      rethrow;
    }
  }

  /// Fetches a single product from the server.
  Future<Either<ErrorMap, T>> getProduct({
    String? dataKey,
    Map<String, dynamic>? params,
    Map<String, dynamic>? extraHeaders,
    String? token,
    required String endPoint,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      var res = await ApplicationBaseRequest.get(
        CartNetworkConfig.baseUrl,
        endPoint,
        extraHeaders: extraHeaders,
        params: params,
        token: token ?? "",
      ).request();

      if (res.status ~/ 100 == 2 && res.data[CartNetworkConfig.apiSuccessKey]) {
        return Right(fromJson(res.data[dataKey ?? 'product']));
      } else {
        return Left(ErrorMap(errorMap: res.data));
      }
    } catch (e, stack) {
      debugPrint("Exception caught: $e\nStacktrace:\n$stack");
      rethrow;
    }
  }
}
