import 'package:equatable/equatable.dart';

class CartModel<T, D> extends Equatable{
  final T product;
  final D? details;
  final int quantity;

  const CartModel({required this.product, this.quantity = 1, this.details});

  @override
  List<Object?> get props => [product, quantity];

  @override
  String toString() => 'CartModel<$T>($product, $quantity)';

  /// Copy with
  CartModel<T, D> copyWith({T? product, int? quantity, D? details}) {
    return CartModel<T, D>(
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
        details: details ?? this.details);
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
    D ?Function(Map<String,dynamic>) detailsFromJson,
  ) {
    return CartModel<T,D>(
      product: fromJson(json['product']),
      quantity: json['quantity'],
      details: detailsFromJson(json['details'])
      
    );
  }

  /// Get a list of CartModels from JSON array
  // static List<CartModel<T,D>> getList<T>(
  //   List<dynamic> jsonList,
  //   T Function(Map<String, dynamic>) fromJson,
  // ) {
  //   return jsonList.map((e) => CartModel<T>.fromJson(e, fromJson)).toList();
  // }
}
