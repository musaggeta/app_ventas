import 'package:app_ventas/models/product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductoDB {
  static final ProductoDB instancia = ProductoDB._();
  ProductoDB._();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'productos.db');
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _db!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE productos (
        id TEXT PRIMARY KEY,
        nombre TEXT,
        descripcion TEXT,
        unidad TEXT,
        valorUnidad REAL,
        precio REAL,
        stock INTEGER
      )
    ''');
  }

  Future<void> insertProducto(Producto p) async {
    final database = await db;
    await database.insert(
      'productos',
      p.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Producto>> getProductos() async {
    final database = await db;
    final result = await database.query('productos');
    return result.map((e) => Producto.fromMap(e)).toList();
  }

  Future<void> deleteProducto(String id) async {
    final database = await db;
    await database.delete('productos', where: 'id = ?', whereArgs: [id]);
  }
}
