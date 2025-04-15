// import 'package:cart_service/models/cart/base_cart_model.dart';
// import 'package:equatable/equatable.dart';

// class DefaultCartModel<T> extends CartBaseModel<T> with EquatableMixin {
//   @override
//   final T product;
//   @override
//   final int quantity;

//   DefaultCartModel({
//     required this.product,
//     this.quantity = 1,
//   });

//   @override
//   List<Object?> get props => [product, quantity];

//   @override
//   DefaultCartModel<T> copyWith({T? product, int? quantity}) {
//     return DefaultCartModel(
//       product: product ?? this.product,
//       quantity: quantity ?? this.quantity,
//     );
//   }

//   @override
//   Map<String, dynamic> toJson(Map<String, dynamic> Function(T) productToJson) {
//     return {
//       'product': productToJson(product),
//       'quantity': quantity,
//     };
//   }

//   static DefaultCartModel<T> fromJson<T>(
//     Map<String, dynamic> json,
//     T Function(Map<String, dynamic>) fromJson,
//   ) {
//     return DefaultCartModel(
//       product: fromJson(json['product']),
//       quantity: json['quantity'],
//     );
//   }
// }
