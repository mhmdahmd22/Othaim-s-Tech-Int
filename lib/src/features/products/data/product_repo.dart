import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../domain/products.dart';

class ProductRepo {
  ProductRepo();
  final Dio _dio = Dio();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the SQLite database
  static Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'products.db');

    /// Create and return the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE products (
            id TEXT PRIMARY KEY,
            title TEXT,
            price REAL,
            category TEXT,
            description TEXT,
            image TEXT
          )
          ''',
        );
      },
    );
  }

  Future<List<Product>> _fetchProductsFromApi() async {
    try {
      final response = await _dio.get('https://fakestoreapi.com/products');
      if (response.statusCode == 200) {
        List<Product> products = (response.data as List)
            .map((json) => Product.fromJson(json))
            .toList();

        // Cache products in SQLite
        await _cacheProductsInDb(products);
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Cache products in SQLite
  Future<void> _cacheProductsInDb(List<Product> products) async {
    final db = await database; // Ensure database is initialized
    final batch = db.batch();

    for (var product in products) {
      batch.insert(
        'products',
        {
          'id': product.id,
          'title': product.title,
          'price': product.price,
          'category': product.category,
          'description': product.description,
          'image': product.image,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  // Fetch products from SQLite
  Future<List<Product>> _fetchProductsFromDb() async {
    final db = await database; // Ensure database is initialized
    final List<Map<String, dynamic>> maps = await db.query('products');

    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Product(
          id: maps[i]['id'],
          title: maps[i]['title'],
          price: maps[i]['price'],
          category: maps[i]['category'],
          description: maps[i]['description'],
          image: maps[i]['image'],
        );
      });
    } else {
      return [];
    }
  }

  // Fetch products list: either from SQLite or API
  Future<List<Product>> fetchProductsList() async {
    final productsFromDb = await _fetchProductsFromDb();
    if (productsFromDb.isEmpty) {
      /// If no products in the local database, fetch from API
      return await _fetchProductsFromApi();
    }
    return productsFromDb;
  }

  Stream<List<Product>> watchProductsList() async* {
    yield await fetchProductsList();
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList().map((products) => _getProduct(products, id));
  }

  static Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> setProduct(Product product) async {
    final products = await fetchProductsList();
    final index = products.indexWhere((p) => p.id == product.id);
    if (index == -1) {
      products.add(product);
    } else {
      products[index] = product;
    }
    await _cacheProductsInDb(products);
  }

  Future<List<Product>> searchProducts(String query) async {
    final productsList = await fetchProductsList();
    return productsList
        .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

final productsRepositoryProvider = Provider<ProductRepo>((ref) {
  return ProductRepo();
});

/// Provider for streaming products list
final productsListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProductsList();
});

/// Future provider for fetching the products list
final productsListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.fetchProductsList();
});

/// Provider for fetching a single product by ID
final productProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProduct(id);
});

/// Provider for searching products by a query
final productsListSearchProvider = FutureProvider.autoDispose
    .family<List<Product>, String>((ref, query) async {
  final link = ref.keepAlive();

  /// * Keep previous search results in memory for 60 seconds
  final timer = Timer(const Duration(seconds: 60), () {
    link.close();
  });
  ref.onDispose(() => timer.cancel());
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.searchProducts(query);
});
