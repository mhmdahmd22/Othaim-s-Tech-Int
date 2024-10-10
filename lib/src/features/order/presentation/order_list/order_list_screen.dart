import 'package:ecommerce_test/src/features/order/presentation/order_list/order_card.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_test/src/common_widgets/responsive_center.dart';

import '../../../../constants/app_sizes.dart';
import '../../domain/orders.dart';
import 'order_card.dart';

/// Shows the list of orders placed by the signed-in user.
class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      Order(
        id: 'abc',
        userId: '123',
        items: {
          '1': 1,
          '2': 2,
          '3': 3,
        },
        orderStatus: OrderStatus.confirmed,
        orderDate: DateTime.now(),
        total: 104,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: orders.isEmpty
          ? Center(
              child: Text(
                'No previous orders',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
            )
          : CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => ResponsiveCenter(
                      padding: const EdgeInsets.all(Sizes.p8),
                      child: OrderCard(
                        order: orders[index],
                      ),
                    ),
                    childCount: orders.length,
                  ),
                ),
              ],
            ),
    );
  }
}
