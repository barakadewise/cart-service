import 'package:cart_service/models/cart/base_cart_model.dart';
import 'package:equatable/equatable.dart';
import 'package:example/models/product.dart';

class CartModell extends Equatable implements CartBaseModel<ProductModel> {
  @override
  final int quantity;
  final String size;
  final String? frequency;
  final String vendorId;
  final double price;
  final double initialDeposit;
  final double amountPerDay;

  @override
  final ProductModel product;

  const CartModell({
    required this.quantity,
    required this.size,
    required this.frequency,
    required this.vendorId,
    required this.price,
    required this.initialDeposit,
    required this.product,
    required this.amountPerDay,
  });

  @override
  bool isSameItemAs(CartBaseModel<ProductModel> other) {
    if (other is! CartModell) return false;
    return product.id == other.product.id && size == other.size;
  }

  @override
  CartModell mergeWith(CartBaseModel<ProductModel> other) {
    if (other is! CartModell) return this;
    return copyWith(
      quantity: quantity + other.quantity,
    );
  }

  factory CartModell.empty() {
    return CartModell(
      quantity: 0,
      size: '',
      frequency: '',
      vendorId: '',
      price: 0,
      initialDeposit: 0,
      amountPerDay: 0,
      product: ProductModel.empty(),
    );
  }

  factory CartModell.fromJson(Map<String, dynamic>? json,
      {String productKey = "product"}) {
    if (json == null) return CartModell.empty();

    return CartModell(
      quantity: json['quantity'] ?? 0,
      size: json['size'] ?? '',
      frequency: json['frequency'] ?? '',
      vendorId: json['vendor_id'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      initialDeposit: (json['initial_deposit'] ?? 0).toDouble(),
      amountPerDay: (json['amount_per_day'] ?? 0).toDouble(),
      product: ProductModel.fromJson(json[productKey] ?? {}),
    );
  }

  @override
  CartModell copyWith({
    int? quantity,
    String? size,
    String? frequency,
    String? vendorId,
    double? price,
    double? initialDeposit,
    double? amountPerDay,
    ProductModel? product,
  }) {
    return CartModell(
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      frequency: frequency ?? this.frequency,
      vendorId: vendorId ?? this.vendorId,
      price: price ?? this.price,
      initialDeposit: initialDeposit ?? this.initialDeposit,
      amountPerDay: amountPerDay ?? this.amountPerDay,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'size': size,
      'frequency': frequency,
      'vendor_id': vendorId,
      'price': price,
      'initial_deposit': initialDeposit,
      'amount_per_day': amountPerDay,
      'product': product.toMap(),
    };
  }

  static List<CartModell> getList(dynamic json) {
    List<CartModell> lists = [];
    try {
      for (var j in json) {
        lists.add(CartModell.fromJson(j));
      }
    } catch (e) {
      lists = [];
    }
    return lists;
  }

  @override
  List<Object?> get props => [
        quantity,
        size,
        frequency,
        vendorId,
        price,
        initialDeposit,
        amountPerDay,
        product,
      ];
}
