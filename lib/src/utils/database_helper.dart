import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/product_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('favorites.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT';
    const intType = 'INTEGER';
    const boolType = 'INTEGER';

    await db.execute('''
  CREATE TABLE favorites ( 
    id $idType, 
    name $textType NOT NULL,
    price $intType NOT NULL,
    discountPrice $intType NOT NULL,
    images $textType NOT NULL,
    isPrescriptionDrugs $boolType NOT NULL,
    description $textType, -- Allowing NULL here
    returnTerms $textType,
    ratingAverage $textType,
    ratingCount $intType,
    reviewCount $intType,
    isFavorite $boolType NOT NULL
  )
  ''');
  }

  Future<void> insertFavorite(ProductModel product) async {
    final db = await instance.database;
    await db.insert('favorites', product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteFavorite(String id) async {
    final db = await instance.database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllFavorites() async {
    final db = await instance.database;
    await db.delete('favorites');
  }

  Future<List<ProductModel>> fetchFavorites() async {
    final db = await instance.database;
    final result = await db.query('favorites');

    return result.map((json) => ProductModel.fromMap(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
