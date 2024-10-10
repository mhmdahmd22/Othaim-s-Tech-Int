import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../products/domain/products.dart';
import '../../domain/cart.dart';

class RemoteCartRepo {
  RemoteCartRepo({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;
  static const String cartUrl = 'https://fakestoreapi.com/carts/1';
  static const String addCartUrl = 'https://fakestoreapi.com/carts/1';

  /// Fetch the cart
  Future<Cart> fetchCart() async {
    try {
      final response = await _dio.get(cartUrl);
      final data = response.data;
      return Cart(
        id: data['id']?.toString() ?? '',
        date: DateTime.parse(data['date'] ?? DateTime.now().toString()),
        products: List<ProductID>.from(
          data['products'].map((product) => product['productId'].toString()),
        ),
      );
    } catch (e) {
      print('Error fetching cart: $e');
      return Cart(
        id: '1',
        date: DateTime.now(),
        products: [],
      );
    }
  }

  /// Stream the cart for real-time updates (using a single fetch for now)
  Stream<Cart> watchCart() async* {
    yield await fetchCart();
  }

  /// Set or update the cart is not supported by the remote API
  Future<void> setCart(Cart cart) async {
    try {
      final response = await _dio.post(
        addCartUrl,
        data: {
          'userId': 5,
          'date': DateTime.now().toIso8601String(),
          'products': cart.products
              .map((productId) => {
                    'productId': productId,
                    'quantity': 1,
                  })
              .toList(),
        },
      );
      print('Cart updated: ${response.data}');
    } catch (e) {
      print('Error updating cart: $e');
    }
  }
}

/// Provider to access the RemoteCartRepo
final remoteCartRepositoryProvider = Provider<RemoteCartRepo>((ref) {
  final dio = Dio();
  return RemoteCartRepo(dio: dio);
});
