import 'package:equatable/equatable.dart';

class CartModel<T> extends Equatable {
  final T product;
  final int quantity;

  const CartModel({required this.product, this.quantity = 1});

  @override
  List<Object?> get props => [product, quantity];
  
  @override
  String toString() => 'CartModel<$T>($product, $quantity)';

  /// Copy with
  CartModel<T> copyWith({T? product, int? quantity}) {
    return CartModel<T>(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Convert to JSON (requires a toJson function)
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJson) {
    return {
      'product': toJson(product),
      'quantity': quantity,
    };
  }

  /// Create from JSON (requires a fromJson function)
  factory CartModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return CartModel<T>(
      product: fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  /// Get a list of CartModels from JSON array
  static List<CartModel<T>> getList<T>(
    List<dynamic> jsonList,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return jsonList.map((e) => CartModel<T>.fromJson(e, fromJson)).toList();
  }
}
