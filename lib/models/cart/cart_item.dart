import 'package:cart_service/models/cart/abstract_product.dart';
import 'package:equatable/equatable.dart';

class CartModel<T> extends Equatable implements HasProduct<T> {
  @override
  final T product;

  final int quantity;

  const CartModel({
    required this.product,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [product, quantity];

  @override
  String toString() => 'CartModel<$T>($product, $quantity)';

  CartModel<T> copyWith({
    T? product,
    int? quantity,
  }) {
    return CartModel<T>(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJson) {
    return {
      'product': toJson(product),
      'quantity': quantity,
    };
  }

  factory CartModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return CartModel<T>(
      product: fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}
