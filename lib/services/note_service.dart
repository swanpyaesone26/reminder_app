import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';
import '../models/subnote_model.dart';

class NoteService {
  static final NoteService _instance = NoteService._internal();
  factory NoteService() => _instance;
  NoteService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // ─── Initialize Database ───────────────────────────────────────
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Notes table
    await db.execute('''
      CREATE TABLE notes (
        id TEXT PRIMARY KEY,
        text TEXT NOT NULL,
        isDone INTEGER NOT NULL DEFAULT 0,
        type TEXT NOT NULL,
        reminder TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Subnotes table
    await db.execute('''
      CREATE TABLE subnotes (
        id TEXT PRIMARY KEY,
        noteId TEXT NOT NULL,
        text TEXT NOT NULL,
        isDone INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (noteId) REFERENCES notes (id) ON DELETE CASCADE
      )
    ''');
  }

  // ─── NOTE CRUD ─────────────────────────────────────────────────

  // Add note
  Future<void> addNote(Note note) async {
    final db = await database;
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all notes by type (daily / monthly / yearly)
  Future<List<Note>> getNotesByType(String type) async {
    final db = await database;
    final maps = await db.query(
      'notes',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  // Update note (eg: mark as done)
  Future<void> updateNote(Note note) async {
    final db = await database;
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Delete note
  Future<void> deleteNote(String id) async {
    final db = await database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ─── SUBNOTE CRUD ──────────────────────────────────────────────

  // Add subnote
  Future<void> addSubnote(Subnote subnote) async {
    final db = await database;
    await db.insert(
      'subnotes',
      subnote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all subnotes for a note
  Future<List<Subnote>> getSubnotes(String noteId) async {
    final db = await database;
    final maps = await db.query(
      'subnotes',
      where: 'noteId = ?',
      whereArgs: [noteId],
      orderBy: 'createdAt ASC',
    );
    return maps.map((map) => Subnote.fromMap(map)).toList();
  }

  // Update subnote (eg: mark as done)
  Future<void> updateSubnote(Subnote subnote) async {
    final db = await database;
    await db.update(
      'subnotes',
      subnote.toMap(),
      where: 'id = ?',
      whereArgs: [subnote.id],
    );
  }

  // Delete subnote
  Future<void> deleteSubnote(String id) async {
    final db = await database;
    await db.delete(
      'subnotes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}