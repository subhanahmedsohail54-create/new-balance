import 'package:subhan/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'shoes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE shoes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT
          )
        ''');
      },
    );
  }

  // Insert Shoe
  Future<void> insertShoe(Shoe shoe) async {
    final db = await database;

    await db.insert(
      'shoes',
      shoe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get All Shoes
  Future<List<Shoe>> getAllShoes() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query('shoes');

    return List.generate(maps.length, (i) {
      return Shoe(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
      );
    });
  }
}