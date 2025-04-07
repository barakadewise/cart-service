import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final double price;

  const Product({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, price];

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
      };

  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';

  /// 🔁 Get List from JSON
  static List<Product> getListFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
