import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?>? get db async {
    if (_db == null) {
      _db = await initializeDb();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> initializeDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "Notes.db");
    Database mydb = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 12,
      onUpgrade: _onUpgrade,
    );
    return mydb;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Vérifier si la colonne "color" existe déjà
    bool columnExists = await db
        .rawQuery('PRAGMA table_info(notes)')
        .then((result) => result.any((column) => column['name'] == 'date'));

    // Si la colonne n'existe pas, l'ajouter à la table
    if (!columnExists) {
      await db.execute("ALTER TABLE notes ADD COLUMN date TEXT");
    }
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notes (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "note" TEXT NOT NULL,
      "title" TEXT NOT NULL,
      "date" TEXT NOT NULL
    )
  ''');
  }

  //** Read data **//
  Future<List<Map<String, dynamic>>> readData(String sql) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.rawQuery(sql);

    return response;
  }

  //** Insert data **//
  Future<int> insertData(String sql, List<Object?> arguments) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql, arguments);
    return response;
  }

  //** Update data **//
  Future<int> updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  //** Delete data **//
  Future<int> deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  Future<void> mydeleteDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "Notes.db");
    await deleteDatabase(path);
  }

  //** Read data **//
  Future<List<Map<String, dynamic>>> read(String table) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.query(table);

    return response;
  }

  //** Insert data **//
  Future<int> insert(String table, Map<String, Object?> values) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, values);

    return response;
  }

  //** Update data **//
  Future<int> update(
    String table,
    Map<String, Object?> values,
    String? mywhere,
  ) async {
    Database? mydb = await db;
    int response = await mydb!.update(
      table,
      values,
      where: mywhere,
    );

    return response;
  }

  //** Delete data **//
  Future<int> delete(
    String table,
    String? mywhere,
  ) async {
    Database? mydb = await db;
    int response = await mydb!.delete(
      table,
      where: mywhere,
    );

    return response;
  }

  Future<int> deleteAll(String tableName) async {
    Database mydb = await initializeDb();
    int result = await mydb.delete(tableName);

    return result;
  }
}
