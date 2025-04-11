import 'package:example/provider/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(listen: false, context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        actions: [
          cart.cartProducts.isNotEmpty
              ? IconButton(
                  tooltip: "Remove all items from cart",
                  onPressed: () {
                    cart.removeAllItems(cart.cartProducts);
                  },
                  icon: Icon(
                    CupertinoIcons.trash,
                    color: Colors.red.shade200,
                  ))
              : const SizedBox()
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          final items = cartProvider.cartProducts;

          if (items.isEmpty) {
            return const Center(child: Text("Cart is empty"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final cartItem = items[index];
                    return ListTile(
                      leading: Image.network(
                        cartItem.product.image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(cartItem.product.title),
                      subtitle: Text(
                        "Quantity: ${cartItem.quantity} | \$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}",
                      ),
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
                          IconButton(
                            icon: const Icon(Icons.delete_forever),
                            color: Colors.red,
                            tooltip: "Remove this item",
                            onPressed: () {
                              cartProvider.removeItem(cartItem.product);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Total: \$${cartProvider.totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (_) => Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Payment Summary',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                ...items.map((e) => ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(e.product.title),
                                      trailing: Text(
                                          "\$${(e.product.price * e.quantity).toStringAsFixed(2)}"),
                                    )),
                                const Divider(),
                                Text(
                                  'Total: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Proceeding to payment...")),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(45)),
                                  child: const Text("Proceed to Pay"),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: const Text("Checkout"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
