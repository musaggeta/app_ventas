import 'package:app_ventas/models/venta_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class VentaDB {
  static final VentaDB instancia = VentaDB._();
  VentaDB._();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'ventas.db');
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _db!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ventas (
        id TEXT PRIMARY KEY,
        productoId TEXT,
        cantidad INTEGER,
        total REAL,
        fecha TEXT
      )
    ''');
  }

  Future<void> insertVenta(Venta v) async {
    final database = await db;
    await database.insert(
      'ventas',
      v.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Venta>> getVentas() async {
    final database = await db;
    final result = await database.query('ventas');
    return result.map((e) => Venta.fromMap(e)).toList();
  }

  Future<void> deleteVenta(String id) async {
    final database = await db;
    await database.delete('ventas', where: 'id = ?', whereArgs: [id]);
  }
}
