import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/cart.dart';
import 'local_cart_repo.dart';

class DbRepo implements LocalCartRepository {
  static const String tableCart = 'cart';
  static const String columnId = 'id';
  static const String columnDate = 'date';
  static const String columnProducts = 'products';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cart.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableCart (
            $columnId TEXT PRIMARY KEY,
            $columnDate TEXT,
            $columnProducts TEXT
          )
        ''');
      },
    );
  }

  @override
  Future<Cart> fetchCart() async {
    final db = await database;
    final maps = await db.query(tableCart);

    if (maps.isNotEmpty) {
      return Cart.fromMap(maps.first);
    } else {
      return Cart(
        id: '1',
        date: DateTime.now(),
        products: [],
      );
    }
  }

  @override
  Stream<Cart> watchCart() async* {
    final db = await database;

    yield await fetchCart();
  }

  @override
  Future<void> setCart(Cart cart) async {
    final db = await database;
    await db.insert(
      tableCart,
      cart.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
