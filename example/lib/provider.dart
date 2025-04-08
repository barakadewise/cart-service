import 'package:example/models/product.dart';
import 'package:flutter/material.dart';

class Provider extends ChangeNotifier {
 final 
  List<ProductModel> _products=[];
  List<ProductModel> get products=>_products;

  bool isLoading=false;

  Future<void> fetchProducts()async{


  }
}