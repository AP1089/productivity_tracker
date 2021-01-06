import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = 'statusManagementDatabase.db';
  static final _tableName = "statusManagement";
  static final column1TaskName = "taskName";
  static final column2Status = "status";
  static final column3Tags = "tags";
  static final DatabaseHelper instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return instance;
  }

  DatabaseHelper._internal();

  static Database _database;

  Future<Database> get _getDatabase async {
    if (_database != null) return _database;

    _database = await _createDatabase();
    return _database;
  }

  _createDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _databaseName);
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  void _createTable(Database database, int version) {
    database.execute('''
      CREATE TABLE $_tableName(
      id INTEGER PRIMARY KEY,
      $column1TaskName TEXT,
      $column2Status TEXT,
      $column3Tags TEXT
      )
      ''');
  }

  Future<int> addTask(Map<String, dynamic> row) async {
    Database database = await instance._getDatabase;
    return await database.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> getStatusTasks(String status) async {
    Database database = await instance._getDatabase;
    return await database
        .query(_tableName, where: "$column2Status = ?", whereArgs: [status]);
  }
}
