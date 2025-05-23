import 'package:cart_service/models/cart/cart_item.dart';
import 'package:example/models/product.dart';
import 'package:example/provider/cart_provider.dart';
import 'package:example/widgets/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(product.productUrl, height: 150)),
            const SizedBox(height: 16),
            Text(product.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Tzs${product.price}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Text(product.description),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add to Cart'),
                    onPressed: () {
                      cartProvider.addCart(CartModel(product: product));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                cartProvider.cartProducts.isNotEmpty
                    ? Expanded(
                        child: ElevatedButton.icon(
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text('cart'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CartPage()))),
                      )
                    : const SizedBox()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
