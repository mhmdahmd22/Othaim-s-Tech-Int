import 'package:flutter/material.dart';
import 'package:ecommerce_test/src/constants/app_sizes.dart';
import 'package:ecommerce_test/src/features/products/domain/products.dart';
import 'package:ecommerce_test/src/utils/currency_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Used to show a single product inside a card.
class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product, this.onPressed});
  final Product product;
  final VoidCallback? onPressed;

  // * Keys for testing using find.byKey()
  static const productCardKey = Key('product-card');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceFormatted =
        ref.watch(currencyFormatterProvider).format(product.price);
    return Card(
      child: InkWell(
        key: productCardKey,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(product.image),
              gapH8,
              const Divider(),
              gapH8,
              Text(product.title,
                  style: Theme.of(context).textTheme.titleLarge),
              gapH24,
              Text(priceFormatted,
                  style: Theme.of(context).textTheme.headlineSmall),
              gapH4,
            ],
          ),
        ),
      ),
    );
  }
}
