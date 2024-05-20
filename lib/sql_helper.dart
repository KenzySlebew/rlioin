import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:sqflite/sqflite.dart' as sql;

// Membuat Database
class SQLHelper {
  static Future<void> createDatabase(sql.Database database) async {
    await database.execute("""
  CREATE TABLE biodata(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nama TEXT,
    alamat TEXT
  )
""");
  }

  // Membuka Database
  static Future<sql.Database> db() async {
    return sql.openDatabase('biodata.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createDatabase(database);
    });
  }

  // Menambah Database
  static Future<int> tambahBiodata(String nama, String alamat) async {
    final db = await SQLHelper.db();
    final data = {'nama': nama, 'alamat': alamat};
    return await db.insert('biodata', data);
  }

  // Mengambil Data
  static Future<List<Map<String, dynamic>>> getBiodata() async {
    final db = await SQLHelper.db();
    return await db.query('biodata');
  }
}
