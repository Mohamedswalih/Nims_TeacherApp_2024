
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_model.dart';

class LoginDatabase {
  static final LoginDatabase instance = LoginDatabase._init();

  static Database? _database;

  LoginDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('loginCredentialDetails.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    print(path);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    // final listType =  'LIST NOT NULL';

    await db.execute('''CREATE TABLE $tableValues( 
        ${LoginDatabaseField.id} $idType, 
        ${LoginDatabaseField.onlyTeacherData} $textType,
        ${LoginDatabaseField.otherTeacherData} $textType,
        ${LoginDatabaseField.employeeUnderHead} $textType
  )''');
  }

  Future<LoginData> create(LoginData loginData) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableValues, loginData.toJson());
    return loginData.copy(id: id);
  }

  Future<LoginData> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableValues,
      columns: LoginDatabaseField.values,
      where: '${LoginDatabaseField.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return LoginData.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<LoginData>> readAllNotes() async {
    final db = await instance.database;

    //final orderBy = '${NoteFields.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableValues);

    return result.map((json) => LoginData.fromJson(json)).toList();
  }

  Future<int> update(LoginData loginData) async {
    final db = await instance.database;

    return db.update(
      tableValues,
      loginData.toJson(),
      where: '${LoginDatabaseField.id} = ?',
      whereArgs: [loginData.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableValues,
      where: '${LoginDatabaseField.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}