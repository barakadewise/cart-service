import 'package:cart_service/models/product/product_category.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

// class ProductModel extends Equatable {
//   final int id;
//   final String title;
//   final double price;
//   final String description;
//   final String category;
//   final String image;
//   final Rating rating;

//   const ProductModel({
//     required this.id,
//     required this.title,
//     required this.price,
//     required this.description,
//     required this.category,
//     required this.image,
//     required this.rating,
//   });

//   /// Factory constructor to create a ProductModel from JSON
//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     return ProductModel(
//       id: json['id'],
//       title: json['title'],
//       price: (json['price'] as num).toDouble(),
//       description: json['description'],
//       category: json['category'],
//       image: json['image'],
//       rating: Rating.fromJson(json['rating']),
//     );
//   }

//   /// Convert ProductModel to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'price': price,
//       'description': description,
//       'category': category,
//       'image': image,
//       'rating': rating.toJson(),
//     };
//   }

//   /// Create a list of ProductModels from a JSON list
//   static List<ProductModel> getListFromJson(List<dynamic> data) {
//     return data.map((e) => ProductModel.fromJson(e)).toList();
//   }

//   /// Create a copy with optional overrides
//   ProductModel copyWith({
//     int? id,
//     String? title,
//     double? price,
//     String? description,
//     String? category,
//     String? image,
//     Rating? rating,
//   }) {
//     return ProductModel(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       price: price ?? this.price,
//       description: description ?? this.description,
//       category: category ?? this.category,
//       image: image ?? this.image,
//       rating: rating ?? this.rating,
//     );
//   }

//   @override
//   List<Object?> get props =>
//       [id, title, price, description, category, image, rating];
// }

// class Rating extends Equatable {
//   final double rate;
//   final int count;

//   const Rating({
//     required this.rate,
//     required this.count,
//   });

//   factory Rating.fromJson(Map<String, dynamic> json) {
//     return Rating(
//       rate: (json['rate'] as num).toDouble(),
//       count: json['count'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'rate': rate,
//       'count': count,
//     };
//   }

//   Rating copyWith({
//     double? rate,
//     int? count,
//   }) {
//     return Rating(
//       rate: rate ?? this.rate,
//       count: count ?? this.count,
//     );
//   }

//   @override
//   List<Object?> get props => [rate, count];
// }

class ProductModel extends Equatable {
  final int id;
  final String name;
  final String picture;
  final String productUrl;
  final double price;
  final double oldPrice;
  final String description;
  final String startAt;
  final String endAt;
  final String teamId;
  final ProductCategory category;
  final String teamAwayId;
  final String stadiumId;
  final String categoryId;
  final double capacity;
  final String level;
  final String vendorId;
  final double totalContribution;
  final double amountPerInstallment;
  // final TeamModel team;
  // final TeamModel teamAway;
  // final StadiumModel stadium;
  // final List<PriceListModel> prices;
  // final List<FeatureModel> features;
  // final List<AttachmentModel> attachments;
  final int initialDepositFixed;
  final double initialDeposit;
  final int hasInstallment;
  final double totalSavingAmount;
  final double totalPaidAmount;
  // final List<TariffModel> tariffs;

  const ProductModel({
    required this.id,
    required this.name,
    required this.picture,
    required this.price,
    required this.oldPrice,
    required this.description,
    required this.startAt,
    required this.endAt,
    required this.teamId,
    required this.category,
    required this.teamAwayId,
    required this.stadiumId,
    required this.categoryId,
    required this.vendorId,
    required this.capacity,
    required this.level,
    required this.totalContribution,
    required this.totalPaidAmount,
    // required this.team,
    // required this.teamAway,
    // required this.stadium,
    // required this.prices,
    required this.productUrl,
    // required this.features,
    required this.amountPerInstallment,
    required this.initialDepositFixed,
    required this.initialDeposit,
    required this.hasInstallment,
    required this.totalSavingAmount,
    // required this.attachments,
    // required this.tariffs,
  });

  factory ProductModel.empty() {
    return ProductModel(
      id: 0,
      name: '',
      picture: '',
      price: 0.0,
      oldPrice: 0.0,
      description: '',
      startAt: '',
      endAt: '',
      teamId: '',
      category: ProductCategory.empty(),
      teamAwayId: '',
      stadiumId: '',
      categoryId: '',
      capacity: 0.0,
      amountPerInstallment: 0.0,
      level: '',
      vendorId: '',
      productUrl: '',
      totalContribution: 0.0,
      totalSavingAmount: 0,
      totalPaidAmount: 0.0,
      // features: [],
      // team: TeamModel.empty(),
      // teamAway: TeamModel.empty(),
      // stadium: StadiumModel.empty(),
      // prices: [],
      initialDepositFixed: 0,
      initialDeposit: 0.0,
      hasInstallment: 0,
      // attachments: [],
      // tariffs: [],
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ProductModel.empty();
    }
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      picture: json['picture'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      oldPrice: (json['old_price'] ?? 0).toDouble(),
      amountPerInstallment:
          double.parse((json['amount_per_installment'] ?? "0").toString()),
      description: json['description'] ?? '',
      startAt: json['start_at'] ?? '',
      endAt: json['end_at'] ?? '',
      vendorId: json['vendor_id'] ?? '',
      productUrl: json['product_url'] ?? '',
      teamId: (json['team_id'] ?? '0').toString(),
      category: ProductCategory.fromJson(json['category']),
      teamAwayId: json['team_away_id'].toString(),
      stadiumId: json['stadium_id'].toString(),
      categoryId: (json['category_id'] ?? '').toString(),
      capacity: (json['capacity'] ?? 0).toDouble(),
      level: json['level'] ?? '',
      totalContribution: (json['total_contribution'] ?? 0).toDouble(),
      totalPaidAmount: (json['total_paid_amount'] ?? 0).toDouble(),
      // features: FeatureModel.getList(
      //   json['feature_list'] ?? [],
      // ),
      // team: TeamModel.fromJson(json['team']),
      // teamAway: TeamModel.fromJson(
      //   json['team_away'] ?? null,
      // ),
      // stadium: StadiumModel.fromJson(
      //   json['stadium'] ?? null,
      // ),
      // prices: PriceListModel.getList(
      //   json['price_list'] ?? [],
      // ),
      initialDepositFixed: json["initial_deposit_fixed"] ?? 0,
      initialDeposit: (json["initial_deposit"] ?? 0).toDouble(),
      hasInstallment: json["has_installment"] ?? 0,
      totalSavingAmount:
          double.parse((json["total_saving_amount"] ?? "0").toString()),
      // attachments: AttachmentModel.getList(
      //   json['attachments'] ?? [],
      // ),
      // tariffs: TariffModel.getList(
      //   json['tariffs'],
      // ),
    );
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? picture,
    double? price,
    double? oldPrice,
    String? description,
    String? startAt,
    String? endAt,
    String? teamId,
    ProductCategory? category,
    String? teamAwayId,
    String? stadiumId,
    String? categoryId,
    double? capacity,
    String? level,
    String? vendorId,
    String? productUrl,
    double? totalContribution,
    double? amountPerInstallment,
    // TeamModel? team,
    // TeamModel? teamAway,
    // StadiumModel? stadium,
    // List<PriceListModel>? prices,
    // List<FeatureModel>? features,
    // List<AttachmentModel>? attachments,
    int? initialDepositFixed,
    double? initialDeposit,
    double? totalPaidAmount,
    int? hasInstallment,
    double? totalSavingAmount,
    // List<TariffModel>? tariffs
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      description: description ?? this.description,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      teamId: teamId ?? this.teamId,
      category: category ?? this.category,
      productUrl: productUrl ?? this.productUrl,
      teamAwayId: teamAwayId ?? this.teamAwayId,
      stadiumId: stadiumId ?? this.stadiumId,
      categoryId: categoryId ?? this.categoryId,
      capacity: capacity ?? this.capacity,
      level: level ?? this.level,
      totalContribution: totalContribution ?? this.totalContribution,
      // team: team ?? this.team,
      vendorId: vendorId ?? this.vendorId,
      // teamAway: teamAway ?? this.teamAway,
      // stadium: stadium ?? this.stadium,
      // prices: prices ?? this.prices,
      // features: features ?? this.features,
      amountPerInstallment: amountPerInstallment ?? this.amountPerInstallment,
      initialDepositFixed: initialDepositFixed ?? this.initialDepositFixed,
      initialDeposit: initialDeposit ?? this.initialDeposit,
      hasInstallment: hasInstallment ?? this.hasInstallment,
      totalSavingAmount: totalSavingAmount ?? this.totalSavingAmount,
      // attachments: attachments ?? this.attachments,
      totalPaidAmount: totalPaidAmount ?? this.totalPaidAmount,
      // tariffs: tariffs ?? this.tariffs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'picture': picture,
      'price': price,
      'old_price': oldPrice,
      'description': description,
      'start_at': startAt,
      'end_at': endAt,
      'team_id': teamId,
      'category': category.toMap(),
      'team_away_id': teamAwayId,
      'stadium_id': stadiumId,
      'category_id': categoryId,
      'capacity': capacity,
      'level': level,
      'product_url': productUrl,
      'total_contribution': totalContribution,
      "amount_per_installment": amountPerInstallment,
      "initial_deposit_fixed": initialDepositFixed,
      "initial_deposit": initialDeposit,
      "has_installment": hasInstallment,
      'vendor_id': vendorId,
      "total_saving_amount": totalSavingAmount,
      // 'team': team.toMap(),
      // 'team_away': teamAway.toMap(),
      // 'stadium': stadium.toMap(),
      // 'price_list': prices.map((e) => e.toMap()).toList(),
      // 'feature_list': features.map((e) => e.toMap()).toList(),
      // 'attachments': attachments.map((e) => e.toMap()).toList(),
      // 'tariffs': tariffs.map((e) => e.toMap()).toList(),
      'total_paid_amount': totalPaidAmount,
    };
  }

  static List<ProductModel> getList(json) {
    List<ProductModel> lists = [];
    try {
      for (var j in json) {
        lists.add(ProductModel.fromJson(j));
      }
    } catch (e, trace) {
      if (kDebugMode) {
        print(e);
        print(trace);
      }
      lists = [];
    }
    return lists;
  }

  bool get productHasInstallment =>
      hasInstallment == 1 && amountPerInstallment > 0;

  double get productPrice => getProductPrice();

  double getProductPrice() {
    if (category.isSavings) {
      return totalSavingAmount;
    }
    if (category.isRoyalties) {
      return amountPerInstallment;
    }
    return price;
  }

  Map<String, dynamic>? getCharge(int amount) {
    //   for (final tariff in tariffs) {
    //     if (amount >= tariff.min && amount <= tariff.max) {
    //       return {
    //         "message": "Note: Charges for withdraw $amount is ${tariff.charges}",
    //         "success": true,
    //       };
    //     }
    //   }
    //   if (amount < 1000) {
    //     return {
    //       "message": "Minimum withdraw amount is TZS 1,000",
    //       "success": false,
    //     };
    //   }
    //   return {
    //     "message": "Maximum withdraw amount is TZS 5,000,000",
    //     "success": false,
    //   };
    // }
  }
  double get depositAmount =>
      productHasInstallment ? initialDeposit : productPrice;

  DateTime get endDate => DateTime.tryParse(endAt) ?? DateTime.now();

  DateTime get startDate => DateTime.tryParse(startAt) ?? DateTime.now();

  @override
  List<Object?> get props => [
        id,
        name,
        picture,
        price,
        oldPrice,
        description,
        startAt,
        endAt,
        teamId,
        category.props,
        teamAwayId,
        stadiumId,
        categoryId,
        capacity,
        level,
        totalContribution,
        amountPerInstallment,
        initialDepositFixed,
        initialDeposit,
        // features,
        // team,
        // vendorId,
        // teamAway,
        // stadium,
        // prices,
        productUrl,
        hasInstallment,
        totalSavingAmount,
        // attachments,
        totalPaidAmount,
        // tariffs,
      ];
}
