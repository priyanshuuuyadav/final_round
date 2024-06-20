import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("articles.db");
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
    await db.execute('''
    CREATE TABLE articles (
      id INTEGER PRIMARY KEY,
      url TEXT UNIQUE
    )
    ''');
  }

  Future<void> saveArticle(String url) async {
    final db = await instance.database;
    await db.insert("articles", {"url": url},
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<bool> isArticleSaved(String url) async {
    final db = await instance.database;
    final result =
        await db.query("articles", where: "url = ?", whereArgs: [url]);
    return result.isNotEmpty;
  }

  Future<void> deleteArticle(String url) async {
    final db = await instance.database;
    await db.delete("articles", where: "url = ?", whereArgs: [url]);
  }

  Future<List<String>> getSavedArticles() async {
    final db = await instance.database;
    final result = await db.query("articles", columns: ["url"]);
    return result.map((e) => e["url"] as String).toList();
  }
}
