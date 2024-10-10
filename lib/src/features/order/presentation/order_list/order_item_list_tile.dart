import 'package:ecommerce_test/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_test/src/features/products/data/product_repo.dart';
import 'package:ecommerce_test/src/features/products/domain/products.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce_test/src/constants/app_sizes.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../cart/domain/item.dart';

/// Shows an individual order item, including price and quantity.
class OrderItemListTile extends ConsumerWidget {
  const OrderItemListTile({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productValue = ref.watch(productProvider(item.productID));
    return AsyncValueWidget<Product?>(
      value: productValue,
      data: (product) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Image.network(product!.image),
            ),
            gapW8,
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title),
                  gapH12,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
