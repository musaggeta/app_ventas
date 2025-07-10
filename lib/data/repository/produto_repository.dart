import 'package:app_ventas/application/auth_provider.dart';
import 'package:app_ventas/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local/producto_db.dart';
import '../remote/producto_remote_ds.dart';

final productoRepositoryProvider = Provider(
  (ref) => ProductoRepository(
    db: ProductoDB.instancia,
    remote: ProductoRemoteDS(),
    getUid: () => ref.read(authProvider)?.uid,
  ),
);

class ProductoRepository {
  final ProductoDB db;
  final ProductoRemoteDS remote;
  final String? Function() getUid;

  ProductoRepository({
    required this.db,
    required this.remote,
    required this.getUid,
  });

  Future<void> addProducto(Producto p) async {
    await db.insertProducto(p);
    final uid = getUid();
    if (uid != null) {
      await remote.addProducto(p, uid);
    }
  }

  Future<void> deleteProducto(String id) async {
    await db.deleteProducto(id);
    final uid = getUid();
    if (uid != null) {
      await remote.deleteProducto(id);
    }
  }

  Future<void> updateProducto(Producto p) async {
    await db.insertProducto(p);
    final uid = getUid();
    if (uid != null) {
      await remote.updateProducto(p, uid);
    }
  }

  Future<List<Producto>> getProductosLocal() => db.getProductos();

  Stream<List<Producto>> productosRemotos() {
    final uid = getUid();
    if (uid != null) {
      return remote.getProductosStream(uid);
    } else {
      return const Stream.empty();
    }
  }
}
