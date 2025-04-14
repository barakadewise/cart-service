import 'package:cart_service/cart_service.dart';
import 'package:cart_service/enums/request_enum.dart';
import 'package:cart_service/models/error/error.dart';
import 'package:example/models/product.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  final CartService<ProductModel,Null> cartService = CartService();
  final List<ProductModel> _products = [];
  List<ProductModel> get products => _products;
  ErrorMap _error = ErrorMap.empty();
  ErrorMap get err => _error;

  bool isLoading = false;
  bool _hasError = false;
  bool get hasErr => _hasError;

  Future<void> fetchProducts() async {
    try {
      isLoading = true;
      notifyListeners();
      final data = await cartService.fetchProducts(
        method: RequestEnum.get,
        fromJson: (p) => ProductModel.fromJson(p),
        endPoint: '/api/products',
      );
      data.fold((l) {
        _error = l;
        isLoading = false;
        _hasError = true;
        notifyListeners();
      }, (r) {
        _products.addAll(r);
        isLoading = false;
        _hasError = false;
        notifyListeners();
      });
    } catch (e, track) {
      debugPrint("❌ Error occurred while fetching products: $e");
      debugPrint("🧱 Stack trace: $track");
      isLoading = false;
      notifyListeners();
    }
  }
}
