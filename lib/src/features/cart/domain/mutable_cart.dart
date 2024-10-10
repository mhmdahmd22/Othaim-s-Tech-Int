import '../../products/domain/products.dart';
import 'cart.dart';
import 'item.dart';

/// Helper extension used to mutate the items in the shopping cart.
extension MutableCart on Cart {
  /// Add an item to the cart by updating the products list.
  Cart addItem(ProductID item) {
    final updatedProducts = List<ProductID>.from(products);
    updatedProducts.add(item);
    return Cart(
      id: id,
      date: date,
      products: updatedProducts,
    );
  }

  /// Add a list of items to the cart by updating the products list.
  Cart addItems(List<Item> itemsToAdd) {
    final updatedProducts = List<ProductID>.from(products);
    for (var item in itemsToAdd) {
      updatedProducts.add(item.productID);
    }
    return Cart(
      id: id,
      date: date,
      products: updatedProducts,
    );
  }

  /// If an item with the given productId is found, remove it from the cart.
  Cart removeItemById(ProductID productId) {
    final updatedProducts = List<ProductID>.from(products);
    updatedProducts.remove(productId);
    return Cart(
      id: id,
      date: date,
      products: updatedProducts,
    );
  }
}
