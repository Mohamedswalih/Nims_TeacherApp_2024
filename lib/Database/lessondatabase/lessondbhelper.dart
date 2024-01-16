import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'lessonmodel.dart';

class LessonDatabase {
  static final LessonDatabase instance = LessonDatabase._init();

  static Database? _database;

  LessonDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('lesson.db');
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

    await db.execute('''CREATE TABLE $tableNotes( 
        ${Lessonfields.id} $idType, 
        ${Lessonfields.teachername} $textType,
        ${Lessonfields.observername} $textType,
        ${Lessonfields.observerid} $textType,
        ${Lessonfields.teacherid} $textType,
        ${Lessonfields.subjectid} $textType,
        ${Lessonfields.topic} $textType,
        ${Lessonfields.subjectname} $textType,
        ${Lessonfields.schoolid} $textType,
        ${Lessonfields.classid} $textType,
        ${Lessonfields.classname} $textType,
        ${Lessonfields.batchid} $textType,
        ${Lessonfields.academicyear} $textType,
        ${Lessonfields.areas_for_improvement} $textType,
        ${Lessonfields.strengths} $textType,
        ${Lessonfields.remedial_measures} $textType,
        ${Lessonfields.role_ids} $textType,
        ${Lessonfields.upper_hierarchy} $textType,
        ${Lessonfields.session_id} $textType,
        ${Lessonfields.curriculum_id} $textType,
        ${Lessonfields.isJoin} $textType,
        ${Lessonfields.tempnam} $textType
  )''');
  }

  Future<Lesson> create(Lesson note) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Lesson> readNotes(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: Lessonfields.values,
      where: '${Lessonfields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Lesson.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Lesson>> readAllNotes() async {
    final db = await instance.database;

    //final orderBy = '${NoteFields.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableNotes);

    return result.map((json) => Lesson.fromJson(json)).toList();
  }

  Future<int> update(Lesson note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${Lessonfields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete() async {
    final db = await instance.database;
    return await db.delete(tableNotes);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
