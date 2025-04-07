import 'package:cart_service/cart_service.dart';
import 'package:cart_service/models/cart/cart_item.dart';
import 'package:cart_service/models/product/product.dart';

void main() {
  final cartService = CartService<Product>();
  //test sample
  List<dynamic> apiSampleData = [
    {
      "product": {"id": "1", "name": "Smartphone", "price": 3000.0},
      "quantity": 40
    },
    {
      "product": {"id": "2", "name": "Laptop", "price": 10000.0},
      "quantity": 100
    },
    {
      "product": {"id": "3", "name": "Smartwatch", "price": 5000.0},
      "quantity": 1
    }
  ];

  const teabag = Product(id: "4", name: 'TeamBag', price: 500);
  const smartphone = Product(id: "5", name: 'Smartphone', price: 3000);
  const laptop = Product(id: "6", name: 'Laptop', price: 10000);
  const smartwatch = Product(id: "7", name: 'Smartwatch', price: 5000);
  const headphones = Product(id: "8", name: 'Headphones', price: 1500);
  const camera = Product(id: "9", name: 'Camera', price: 7500);
  const printer = Product(id: "10", name: 'Printer', price: 2000);
  const deskChair = Product(id: "11", name: 'Office Desk Chair', price: 1200);
  const gamingConsole = Product(id: "12", name: 'Gaming Console', price: 8000);
  const airConditioner =
      Product(id: "13", name: 'Air Conditioner', price: 15000);

  // Stopwatch to measure execution time
  final stopwatch = Stopwatch()..start();

  // Add items
  print("🚀 Adding items to the cart...");
  cartService.addItem(CartModel(product: smartphone, quantity: 40));
  print("✔️ Added ${smartphone.name} with quantity 40.");
  cartService.addItem(CartModel(product: laptop, quantity: 100));
  print("✔️ Added ${laptop.name} with quantity 100.");
  cartService.addItem(CartModel(product: smartphone));
  print("✔️ Added ${smartphone.name} with quantity 1.");

  // Print all items in the cart
  print('\n🛒 Cart Items initially:');
  for (var item in cartService.getItems()) {
    print('🛍 ${item.product.name} - Quantity: ${item.quantity}');
  }

  // Remove an item
  print('\n❌ Removing Smartphone...');
  cartService.removeItem(smartphone);
  print('✔️ ${smartphone.name} removed.');

  // Print cart items after removal
  print('\n🛒 Cart Items after removal:');
  for (var item in cartService.getItems()) {
    print('🛍 ${item.product.name} - Quantity: ${item.quantity}');
  }

  // Increment and decrement product quantities
  print('\n🔼 Incrementing and Decrementing Product Quantities...');
  for (int i = 1; i <= 10; i++) {
    // Valid increments and decrements
    cartService.addItem(CartModel(product: teabag));
    print('✔️ added to cart  ${teabag.name}.');
    cartService.decrementProduct(laptop);
    print('✔️ Decremented quantity of ${laptop.name}.');
  }

  // Print cart items after removal
  print('\n🛒 After incrememntation:');
  for (var item in cartService.getItems()) {
    print('🛍 ${item.product.name} - Quantity: ${item.quantity}');
  }

  cartService.addMultipleItems([
    const CartModel(product: teabag, quantity: 30),
    const CartModel(product: camera, quantity: 100),
    const CartModel(product: deskChair)
  ]);

  print(
      "ASSOCIATED USER CARTS ARE:${cartService.userOrder(apiSampleData, (json) => Product.fromJson(json))}");
  print(
      "ALL PRODUCTS CART HERE :${cartService.printCartItemsAsJson((product) => product.toJson())}");

  // Stop the stopwatch and print the execution time
  stopwatch.stop();
  print('\n⏱ Program executed in ${stopwatch.elapsedMilliseconds}ms');
}
