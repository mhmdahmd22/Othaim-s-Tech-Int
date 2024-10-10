import 'package:ecommerce_test/src/features/cart/data/local/sql_cart_repo.dart';
import 'package:ecommerce_test/src/features/products/data/product_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/features/cart/data/local/local_cart_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize the databases for Cart and Products
  final dbRepo = DbRepo();
  final productRepo = ProductRepo();

  await dbRepo.database;

  /// Initialize Cart database
  await productRepo.database;

  /// Initialize Product database

  final container = ProviderContainer(
    overrides: [
      localCartRepositoryProvider.overrideWithValue(dbRepo),
    ],
  );

  /// * Entry point of the app
  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}
