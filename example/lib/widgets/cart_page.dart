import 'package:example/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          final items = cartProvider.cartProducts;

          if (items.isEmpty) {
            return const Center(child: Text("Cart is empty"));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final cartItem = items[index];
              return ListTile(
                title: Text(cartItem.product.title),
                subtitle: Text("Quantity: ${cartItem.quantity}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        cartProvider.decrementCartItem(cartItem.product);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        cartProvider.incrementCartItem(cartItem.product);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
