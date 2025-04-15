abstract class CartBaseModel<T> {
  T get product;
  int get quantity;

  /// Determines if two cart items are considered the same (e.g., same product + size)
  bool isSameItemAs(CartBaseModel<T> other);

  /// Defines how to merge two items that are considered the same
  CartBaseModel<T> mergeWith(CartBaseModel<T> other);
  CartBaseModel<T> copyWith({T? product, int? quantity});
}
