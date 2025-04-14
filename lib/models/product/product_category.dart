import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductCategory extends Equatable {
  final int id;
  final String name;
  final String vendorId;
  final String slug;

  const ProductCategory(
      {required this.id,
      required this.name,
      required this.vendorId,
      required this.slug});

  factory ProductCategory.empty() {
    return const ProductCategory(id: 0, name: '', vendorId: '', slug: '');
  }

  factory ProductCategory.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ProductCategory.empty();
    }
    return ProductCategory(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        vendorId: json['vendor_id'] ?? '',
        slug: json['slug']);
  }

  ProductCategory copyWith(
      {int? id,
      String? name,
      String? productId,
      String? vendorId,
      String? slug}) {
    return ProductCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        vendorId: vendorId ?? this.vendorId,
        slug: slug ?? this.slug);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'vendorId': vendorId, 'slug': slug};
  }

  static List<ProductCategory> getList(json) {
    List<ProductCategory> lists = [];
    try {
      for (var j in json) {
        lists.add(ProductCategory.fromJson(j));
      }
    } catch (e) {
      lists = [];
    }
    return lists;
  }

  bool get isKits => this.slug == "kits";
  bool get isSavings => this.slug == "savings";
  bool get isRoyalties => this.slug == "royalties";
  bool get isMemberships => this.slug == "memberships";
  bool get isTickets => this.slug == "tickets";
  bool get isWallet => this.slug == "wallets";

  IconData get icon => getIcon();

  IconData getIcon() {
    if (isKits) {
      return CupertinoIcons.cart_fill;
    }
    if (isTickets) {
      return CupertinoIcons.tickets_fill;
    }
    if (isMemberships) {
      return CupertinoIcons.person_2_fill;
    }
    if (isRoyalties) {
      return CupertinoIcons.person_2_square_stack_fill;
    }
    if (isSavings) {
      return CupertinoIcons.creditcard_fill;
    }
    if (isWallet) {
      return CupertinoIcons.creditcard;
    }
    return CupertinoIcons.person_2_fill;
  }

  @override
  List<Object> get props => [id, name, vendorId, slug];
}
