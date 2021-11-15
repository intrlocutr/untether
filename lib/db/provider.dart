import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untether/model/reports.dart';

class ReportDatabase {

  // Constants used by the database.
  static const String _dbName = 'report_database.db';
  static const String _tblName = 'report';
  static const int _dbVersion = 1;

  // The ReportDatabase model will be a singleton.
  ReportDatabase._privateConstructor();
  static final ReportDatabase _instance = ReportDatabase._privateConstructor();
  factory ReportDatabase() => _instance;

  static Database? _db;

  Future<Database?> get database async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    return await openDatabase(
        join(await getDatabasesPath(), _dbName),
        version: _dbVersion,
        onCreate: _onCreate
    );
  }

  Future _onCreate(Database db, int version) {
    return db.execute(
      'CREATE TABLE $_tblName(timestamp INTEGER PRIMARY KEY, usageMinutes INTEGER, score DOUBLE)',
    );
  }

  /// Inserts a `report` into the database.
  Future insertReport(Report report) async {
    Database? db = await _instance.database;
    await db!.insert(
      _tblName,
      report.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Reads the report from the day of `timestamp`.
  Future<Report> readReport(DateTime timestamp) async {
    Database? db = await _instance.database;

    // Get the times in between which we should be looking.
    // [gteTime, ltTime)
    final DateTime minDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
    final int gteTime = minDate.millisecondsSinceEpoch;
    final int ltTime = minDate.add(const Duration(days: 1)).millisecondsSinceEpoch;

    final List<Map<String, dynamic>> q = await db!.query(
        _tblName,
        where: 'timestamp >= $gteTime AND timestamp < $ltTime'
    );

    return Report.fromMap(q[0]);
  }

  /// Updates the report in the database with `report`.
  Future updateReport(Report report) async {
    Database? db = await _instance.database;
    await db!.update(
        _tblName,
        report.toMap(),
        where: 'timestamp = ?',
        whereArgs: [report.timestamp.millisecondsSinceEpoch]
    );
  }

  /// Removes the report matching `report` from the database.
  Future deleteReport(Report report) async {
    Database? db = await _instance.database;
    await db!.delete(
        _tblName,
        where: 'timestamp = ?',
        whereArgs: [report.timestamp.millisecondsSinceEpoch]
    );
  }

  /// Reads the reports within the range.
  Future<Iterable<Report>> readReports(DateTimeRange range) async {
    Database? db = await _instance.database;

    final List<Map<String, dynamic>> q = await db!.query(
        _tblName,
        where: 'timestamp BETWEEN ${range.start.millisecondsSinceEpoch} AND ${range.end.millisecondsSinceEpoch}'
    );

    return q.map((Map<String, dynamic> r) => Report.fromMap(r));
  }
}