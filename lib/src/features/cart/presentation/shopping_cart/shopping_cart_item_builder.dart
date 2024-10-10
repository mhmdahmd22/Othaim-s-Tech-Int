import 'package:flutter/material.dart';

import '../../../../common_widgets/decorated_box_with_shadow.dart';
import '../../../../common_widgets/empty_placeholder.dart';
import '../../../../common_widgets/responsive_center.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/breakpoints.dart';
import '../../../products/domain/products.dart';
import '../cart_total/cart_total_with_cta.dart';

/// Responsive widget showing the cart items and the checkout button
class ShoppingCartItemsBuilder extends StatelessWidget {
  const ShoppingCartItemsBuilder({
    super.key,
    required this.products,
    required this.itemBuilder,
    required this.ctaBuilder,
  });

  final List<ProductID> products;
  final Widget Function(BuildContext, ProductID, int) itemBuilder;
  final WidgetBuilder ctaBuilder;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const EmptyPlaceholderWidget(
        message: 'Your shopping cart is empty',
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= Breakpoint.tablet) {
      return ResponsiveCenter(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
                itemBuilder: (context, index) {
                  final productId = products[index];
                  return itemBuilder(context, productId, index);
                },
                itemCount: products.length,
              ),
            ),
            gapW16,
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
                child: CartTotalWithCTA(ctaBuilder: ctaBuilder),
              ),
            ),
          ],
        ),
      );
    } else {
      /// On narrow layouts, show a Column with a scrollable list of items
      /// and a pinned box at the bottom with the checkout button
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(Sizes.p16),
              itemBuilder: (context, index) {
                final productId = products[index];
                return itemBuilder(context, productId, index);
              },
              itemCount: products.length,
            ),
          ),
          DecoratedBoxWithShadow(
            child: CartTotalWithCTA(ctaBuilder: ctaBuilder),
          ),
        ],
      );
    }
  }
}
