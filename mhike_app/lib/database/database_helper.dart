import 'dart:async';
import 'package:mhike_app/models/hike_model.dart';
import 'package:mhike_app/models/observation_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  late Database _database;

  // Add a function to initialize the database
  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'm_hike_database.db');
    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _database;
  }

  // Add a function to create the database
  void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS users (
      userid INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT,
      email TEXT,
      password TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS hikes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      location TEXT NOT NULL,
      date TEXT NOT NULL,
      partner TEXT NOT NULL,
      parkingAvailable INTEGER NOT NULL,
      length REAL NOT NULL,
      difficulty TEXT NOT NULL,
      description TEXT,
      image TEXT
    )
  ''');

  await db.execute('''
  CREATE TABLE IF NOT EXISTS observations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    observationDetail TEXT NOT NULL,
    time TEXT NOT NULL,
    weather TEXT,
    additionalComments TEXT,
    locationDetail TEXT,
    image TEXT,
    hikeName TEXT NOT NULL,
    FOREIGN KEY (hikeName) REFERENCES hikes (name) ON DELETE CASCADE
  )
''');
  }
  // Add a function to log in a user
  Future<bool> login(String email, String password) async {
    final Database db = await initDatabase();

    List<Map<String, dynamic>> results = await db.query('users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
        limit: 1);

    return results.isNotEmpty;
  }
  // Add a function to sign up a new user
  Future<void> signUp(String username, String email, String password) async {
    final Database db = await initDatabase();

    await db.insert(
        'users',
        {
          'username': username,
          'email': email,
          'password': password,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
  // Add a function to add a hike to the database
  Future<void> addHike(Hike hike) async {
    final Database db = await initDatabase();

    await db.insert(
      'hikes',
      hike.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  // Add a function to get all hikes from the database
  Future<List<Hike>> getHikes() async {
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> results = await db.query('hikes');
    return results.map((map) => Hike.fromMap(map)).toList();
  }
  // Add a function to search for hikes by name
  Future<List<Hike>> searchHikes(String name) async {
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> results = await db.query(
      'hikes',
      where: 'name LIKE ?',
      whereArgs: ['%$name%'],
    );
    return results.map((map) => Hike.fromMap(map)).toList();
  }
  // Delete a hike from the database
  Future<void> deleteHike(String name) async {
    final Database db = await initDatabase();
    await db.delete(
      'hikes',
      where: 'name = ?',
      whereArgs: [name],
    );
  }
  // Add a function to add observation from the database
Future<void> addObservation(Observation observation) async {
  final Database db = await initDatabase();

  await db.insert(
    'observations',
    observation.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Observation>> getObservationsForHike(String hikeName) async {
  final Database db = await initDatabase();
  final List<Map<String, dynamic>> results = await db.query(
    'observations',
    where: 'hikeName = ?',
    whereArgs: [hikeName],
  );
  return results.map((map) => Observation.fromMap(map)).toList();
}

Future<void> editObservation(Observation observation) async {
  final Database db = await initDatabase();

  await db.update(
    'observations',
    observation.toMap(),
    where: 'hikeName = ? AND time = ?',
    whereArgs: [observation.hikeName, observation.time.toIso8601String()],
  );
}
// Add a method to get a single hike by its name
Future<Hike?> getHikeByName(String name) async {
  final Database db = await initDatabase();
  List<Map<String, dynamic>> results = await db.query(
    'hikes',
    where: 'name = ?',
    whereArgs: [name],
  );
  if (results.isNotEmpty) {
    return Hike.fromMap(results.first);
  } else {
    return null;
  }
}

// Add a method to update a hike
Future<void> updateHike(Hike hike) async {
  final Database db = await initDatabase();
  await db.update(
    'hikes',
    hike.toMap(),
    where: 'id = ?', // Update this line
    whereArgs: [hike.id], // Update this line
  );
}

  // Add a function to delete an observation from the database
  Future<void> deleteObservation(String name, DateTime time) async {
    final Database db = await initDatabase();
    await db.delete(
      'observations',
      where: 'hikeName = ? AND time = ?',
      whereArgs: [name, time.toIso8601String()],
    );
  }
}
