import 'package:ecommerce_test/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_test/src/features/cart/presentation/shopping_cart/shopping_cart_item.dart';
import 'package:ecommerce_test/src/features/cart/presentation/shopping_cart/shopping_cart_item_builder.dart';
import 'package:ecommerce_test/src/utils/async_value_ui.dart';
import 'package:ecommerce_test/src/features/cart/presentation/shopping_cart/shopping_cart_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../common_widgets/primary_button.dart';
import '../../../../routing/app_router.dart';
import '../../application/cart_service.dart';
import '../../domain/cart.dart';

/// Shopping cart screen showing the items in the cart and a button to checkout.
class ShoppingCartScreen extends ConsumerWidget {
  const ShoppingCartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      shoppingCartScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(shoppingCartScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final cartValue = ref.watch(cartProvider);
          return AsyncValueWidget<Cart>(
            value: cartValue,
            data: (cart) => ShoppingCartItemsBuilder(
              products: cart!.products,
              itemBuilder: (_, productId, index) => ShoppingCartItem(
                productId: productId,
                itemIndex: index,
              ),
              ctaBuilder: (_) => PrimaryButton(
                text: 'Checkout',
                isLoading: state.isLoading,
                onPressed: () => context.pushNamed(AppRoute.checkout.name),
              ),
            ),
          );
        },
      ),
    );
  }
}
