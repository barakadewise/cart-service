import 'package:cart_service/config/network_config.dart';
import 'package:example/models/product.dart';
import 'package:flutter/material.dart';

void main() {
  //initilialize cart  baser url
  CartNetworkConfig.init("fakestoreapi.com");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Fetcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // late Future<List<ProductModel>> _productList;
  // final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    // _productList = _cartService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _productList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          } else {
            List<ProductModel> products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: Image.network(product.image, width: 50, height: 50),
                  title: Text(product.title),
                  subtitle: Text('\$${product.price.toString()}'),
                  onTap: () {
                    // You can add any functionality here when the product is tapped
                    print('Tapped on ${product.title}');
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
