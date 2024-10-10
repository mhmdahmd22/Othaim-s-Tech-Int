import '../../products/domain/products.dart';

/// A product along with a quantity that can be added to an order/cart
class Item {
  const Item({
    required this.productID,
  });
  final ProductID productID;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item && other.productID == productID;
  }

  @override
  int get hashCode => productID.hashCode;
}
