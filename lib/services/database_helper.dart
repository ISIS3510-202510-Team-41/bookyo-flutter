import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bookyo_cache.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE listings (
            id TEXT PRIMARY KEY,
            data TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE user_library (
            id TEXT PRIMARY KEY,
            data TEXT
          )
        ''');
      },
    );
  }

  // Listings
  Future<void> insertListings(List<Map<String, dynamic>> listings) async {
    final database = await db;
    final batch = database.batch();
    for (final listing in listings) {
      batch.insert(
        'listings',
        {'id': listing['id'], 'data': jsonEncode(listing)},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getListings() async {
    final database = await db;
    final maps = await database.query('listings');
    return maps.map((e) => jsonDecode(e['data'] as String) as Map<String, dynamic>).toList();
  }

  Future<void> clearListings() async {
    final database = await db;
    await database.delete('listings');
  }

  // User Library
  Future<void> insertUserLibrary(List<Map<String, dynamic>> books) async {
    final database = await db;
    final batch = database.batch();
    for (final book in books) {
      batch.insert(
        'user_library',
        {'id': book['id'], 'data': jsonEncode(book)},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getUserLibrary() async {
    final database = await db;
    final maps = await database.query('user_library');
    return maps.map((e) => jsonDecode(e['data'] as String) as Map<String, dynamic>).toList();
  }

  Future<void> clearUserLibrary() async {
    final database = await db;
    await database.delete('user_library');
  }
} 