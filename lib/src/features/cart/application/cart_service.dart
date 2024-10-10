import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecommerce_test/src/features/cart/domain/mutable_cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../products/data/product_repo.dart';
import '../../products/domain/products.dart';
import '../data/local/local_cart_repo.dart';
import '../data/remote/remote_cart_repo.dart';
import '../domain/cart.dart';
import '../domain/item.dart';
import 'package:ecommerce_test/src/features/products/domain/products.dart';

class CartService {
  CartService(this.ref);
  final Ref ref;

  /// Check if the app has an internet connection
  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// Fetch the cart from the local or remote repository
  /// depending on the internet connectivity
  Future<Cart> _fetchCart() async {
    final isOnline = await _hasInternetConnection();
    if (isOnline) {
      return ref.read(remoteCartRepositoryProvider).fetchCart();
    } else {
      return ref.read(localCartRepositoryProvider).fetchCart();
    }
  }

  /// Save the cart to the local or remote repository
  /// depending on the internet connectivity
  Future<void> _setCart(Cart cart) async {
    final isOnline = await _hasInternetConnection();
    if (isOnline) {
      await ref.read(remoteCartRepositoryProvider).setCart(cart);
    } else {
      await ref.read(localCartRepositoryProvider).setCart(cart);
    }
  }

  /// Adds an item in the local or remote cart depending on the internet connectivity
  Future<void> addItem(Item item) async {
    final isOnline = await _hasInternetConnection();
    final cart = await _fetchCart();
    if (isOnline) {
      await ref.read(remoteCartRepositoryProvider).setCart(cart);
    } else {
      final updated = cart.addItem(item.productID);
      await _setCart(updated);
    }
  }

  /// Removes an item from the local or remote cart depending on the internet connectivity
  Future<void> removeItemById(ProductID productId) async {
    final isOnline = await _hasInternetConnection();
    final cart = await _fetchCart();
    final updated = cart.removeItemById(productId);
    await _setCart(updated);
  }
}

final cartServiceProvider = Provider<CartService>((ref) {
  return CartService(ref);
});

final cartProvider = StreamProvider<Cart>((ref) {
  final isOnlineAsync = ref.watch(internetConnectivityProvider);

  return isOnlineAsync.when(
    data: (isOnline) {
      if (isOnline) {
        return ref.watch(remoteCartRepositoryProvider).watchCart();
      } else {
        return ref.watch(localCartRepositoryProvider).watchCart();
      }
    },
    loading: () => const Stream.empty(),
    error: (err, stack) => Stream.error(err),
  );
});

final cartItemsCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).maybeMap(
        data: (cart) => cart.value.products.length,
        orElse: () => 0,
      );
});

final cartTotalProvider = Provider.autoDispose<double>((ref) {
  final cart = ref.watch(cartProvider).value ??
      Cart(id: '', date: DateTime.now(), products: []);
  final productsList = ref.watch(productsListStreamProvider).value ?? [];
  if (cart.products.isNotEmpty && productsList.isNotEmpty) {
    var total = 0.0;
    for (final productID in cart.products) {
      final product =
          productsList.firstWhere((product) => product.id == productID);
      total += product.price;
    }
    return total;
  } else {
    return 0.0;
  }
});

final internetConnectivityProvider = FutureProvider<bool>((ref) async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
});
