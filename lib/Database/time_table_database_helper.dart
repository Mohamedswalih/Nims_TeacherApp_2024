
import 'package:bmteacher/Database/timetable_database_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_model.dart';

class TimeTableDatabase {
  static final TimeTableDatabase instance = TimeTableDatabase._init();

  static Database? _database;

  TimeTableDatabase._init();

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

    await db.execute('''CREATE TABLE $timetableValues( 
        ${TimeTableDatabaseField.id} $idType, 
        ${TimeTableDatabaseField.monday} $textType,
        ${TimeTableDatabaseField.tuesday} $textType,
        ${TimeTableDatabaseField.wednesday} $textType,
        ${TimeTableDatabaseField.thursday} $textType,
        ${TimeTableDatabaseField.friday} $textType,
        ${TimeTableDatabaseField.saturday} $textType
  )''');
  }

  Future<TimeTableData> create(TimeTableData timeTableData) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(timetableValues, timeTableData.toJson());
    return timeTableData.copy(id: id);
  }

  Future<TimeTableData> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      timetableValues,
      columns: TimeTableDatabaseField.values,
      where: '${TimeTableDatabaseField.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TimeTableData.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<TimeTableData>> readAllNotes() async {
    final db = await instance.database;

    //final orderBy = '${NoteFields.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(timetableValues);

    return result.map((json) => TimeTableData.fromJson(json)).toList();
  }

  Future<int> update(TimeTableData timeTableData) async {
    final db = await instance.database;

    return db.update(
      timetableValues,
      timeTableData.toJson(),
      where: '${TimeTableDatabaseField.id} = ?',
      whereArgs: [timeTableData.id],
    );
  }

  Future<int> delete() async {
    final db = await instance.database;
    return await db.delete(
      timetableValues,
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}