import 'package:ecommerce_test/src/constants/breakpoints.dart';
import 'package:ecommerce_test/src/routing/app_router.dart';
import 'package:ecommerce_test/src/features/products/presentation/home_app_bar/shopping_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Custom [AppBar] widget that is reused by the [ProductsListScreen] and
/// [ProductScreen].
/// It shows the following actions, depending on the application state:
/// - [ShoppingCartIcon]
/// - Orders button
/// - Account or Sign-in button
class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < Breakpoint.tablet) {
      return AppBar(
        title: Text('My Shop'),
        actions: [
          const ShoppingCartIcon(),
          IconButton(
            icon: Icon(Icons.inventory),
            onPressed: () {
              context.pushNamed(AppRoute.orders.name);
            },
          )
        ],
      );
    } else {
      return AppBar(
        title: Text('My Shop'),
        actions: [
          const ShoppingCartIcon(),
          IconButton(
            icon: const Icon(Icons.inventory),
            onPressed: () {
              context.pushNamed(AppRoute.orders.name);
            },
          )
        ],
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
