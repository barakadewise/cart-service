import 'package:cart_service/config/network_config.dart';
import 'package:example/models/product.dart';
import 'package:example/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  CartNetworkConfig.init("fakestoreapi.com");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'Product Fetcher',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

// Home Screen with View Products Button
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: ElevatedButton(
          child: const Text("View Products"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductListScreen()),
            );
          },
        ),
      ),
    );
  }
}

// Product List Page
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: FutureBuilder(
        future: productProvider.fetchProducts(),
        builder: (context, snapshot) {
          return Consumer<ProductProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (provider.hasErr) {
                return Center(child: Text('Error: ${provider.err.message}'));
              } else if (provider.products.isEmpty) {
                return const Center(child: Text('No products found'));
              } else {
                return ListView.builder(
                  itemCount: provider.products.length,
                  itemBuilder: (context, index) {
                    final product = provider.products[index];
                    return ListTile(
                      leading:
                          Image.network(product.image, width: 50, height: 50),
                      title: Text(product.title),
                      subtitle: Text('\$${product.price}'),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
