import 'dart:math';
import 'package:ecommerce_test/src/features/cart/presentation/shopping_cart/shopping_cart_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common_widgets/alert_dialouges.dart';
import '../../../../common_widgets/async_value_widget.dart';
import '../../../../common_widgets/responsive_two_column_layout.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../products/data/product_repo.dart';
import '../../../products/domain/products.dart';

/// Shows a shopping cart item (or loading/error UI if needed)
class ShoppingCartItem extends ConsumerWidget {
  const ShoppingCartItem({
    super.key,
    required this.productId,
    required this.itemIndex,
    this.isEditable = true,
  });

  final ProductID productId;
  final int itemIndex;

  /// If true, a delete button will be shown
  /// If false, the item will be shown in a read-only format (used in the PaymentPage)
  final bool isEditable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productValue = ref.watch(productProvider(productId));
    return AsyncValueWidget<Product?>(
      // Show loading/error UI if necessary
      value: productValue,
      data: (product) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: ShoppingCartItemContents(
              product: product!,
              itemIndex: itemIndex,
              isEditable: isEditable,
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows a shopping cart item for a given product
class ShoppingCartItemContents extends ConsumerWidget {
  const ShoppingCartItemContents({
    super.key,
    required this.product,
    required this.itemIndex,
    required this.isEditable,
  });

  final Product product;
  final int itemIndex;
  final bool isEditable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceFormatted =
        ref.watch(currencyFormatterProvider).format(product.price);
    return ResponsiveTwoColumnLayout(
      startFlex: 1,
      endFlex: 2,
      breakpoint: 320,
      startContent: Image.network(product.image),
      spacing: Sizes.p24,
      endContent: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
          gapH24,
          Text(priceFormatted,
              style: Theme.of(context).textTheme.headlineSmall),
          gapH24,
          isEditable
              // show a delete button
              ? EditOrRemoveItemWidget(
                  product: product,
                  itemIndex: itemIndex,
                )
              // else, show the item as read-only
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
                ),
        ],
      ),
    );
  }
}

/// Custom widget to show a delete button for the item
class EditOrRemoveItemWidget extends ConsumerWidget {
  const EditOrRemoveItemWidget({
    super.key,
    required this.product,
    required this.itemIndex,
  });

  final Product product;
  final int itemIndex;

  // * Keys for testing using find.byKey()
  static Key deleteKey(int index) => Key('delete-$index');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shoppingCartScreenControllerProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          key: deleteKey(itemIndex),
          icon: Icon(Icons.delete, color: Colors.red[700]),
          onPressed: () {
            showDeleteConfirmationDialog(
              context: context,
              onDeletePressed: () {
                if (!state.isLoading) {
                  ref
                      .read(shoppingCartScreenControllerProvider.notifier)
                      .removeItemById(product.id);
                }
              },
            );
          },
        ),
        const Spacer(),
      ],
    );
  }
}
