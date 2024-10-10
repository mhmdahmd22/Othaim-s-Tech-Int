import 'package:ecommerce_test/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_test/src/features/cart/presentation/add_to_cart/add_to_cart_widget.dart';
import 'package:ecommerce_test/src/features/products/data/product_repo.dart';
import 'package:ecommerce_test/src/features/products/presentation/home_app_bar/home_app_bar.dart';
import 'package:ecommerce_test/src/common_widgets/empty_placeholder.dart';
import 'package:ecommerce_test/src/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_test/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_test/src/common_widgets/responsive_two_column_layout.dart';
import 'package:ecommerce_test/src/constants/app_sizes.dart';
import 'package:ecommerce_test/src/features/products/domain/products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows the product page for a given product ID.
class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Consumer(
        builder: (context, ref, _) {
          final productValue = ref.watch(productProvider(productId));
          return AsyncValueWidget<Product?>(
            value: productValue,
            data: (product) => product == null
                ? const EmptyPlaceholderWidget(
                    message: 'Product not found',
                  )
                : CustomScrollView(
                    slivers: [
                      ResponsiveSliverCenter(
                        padding: const EdgeInsets.all(Sizes.p16),
                        child: ProductDetails(product: product),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

/// Shows all the product details along with actions to:
/// - leave a review
/// - add to cart
class ProductDetails extends ConsumerWidget {
  const ProductDetails({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceFormatted =
        ref.watch(currencyFormatterProvider).format(product.price);
    return ResponsiveTwoColumnLayout(
      startContent: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Image.network(product.image),
        ),
      ),
      spacing: Sizes.p16,
      endContent: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(product.title,
                  style: Theme.of(context).textTheme.titleLarge),
              gapH8,
              Text(product.category),
              gapH8,
              Text(product.description),
              gapH8,
              const Divider(),
              gapH8,
              Text(priceFormatted,
                  style: Theme.of(context).textTheme.headlineSmall),
              gapH8,
              const Divider(),
              gapH8,
              AddToCartWidget(product: product),
            ],
          ),
        ),
      ),
    );
  }
}
