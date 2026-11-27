import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = p.join(await getDatabasesPath(), 'akademik.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE mahasiswa (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nim TEXT UNIQUE NOT NULL,
            nama TEXT NOT NULL,
            email TEXT NOT NULL,
            jurusan TEXT NOT NULL,
            password TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<bool> register(Mahasiswa m) async {
    final db = await database;
    try {
      await db.insert('mahasiswa', m.toMap()..remove('id'), conflictAlgorithm: ConflictAlgorithm.abort);
      return true;
    } catch (e) {
      return false;
    }
  }

  static String hashPassword(String plain) => sha256.convert(utf8.encode(plain)).toString();
}

class Mahasiswa {
  final int? id;
  final String nim;
  final String nama;
  final String email;
  final String jurusan;
  final String password;

  Mahasiswa({
    this.id,
    required this.nim,
    required this.nama,
    required this.email,
    required this.jurusan,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nim': nim,
    'nama': nama,
    'email': email,
    'jurusan': jurusan,
    'password': password,
  };

  factory Mahasiswa.fromMap(Map<String, dynamic> m) => Mahasiswa(
      id: m['id'] as int?,
      nim: m['nim'] as String,
      nama: m['nama'] as String,
      email: m['email'] as String,
      jurusan: m['jurusan'] as String,
      password: m['password'] as String,
    );

  @override
  String toString() {
    return 'Mahasiswa{id: $id, nim: $nim, nama: $nama, email: $email, jurusan: $jurusan}';
  }
}
