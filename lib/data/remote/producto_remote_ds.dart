import 'package:app_ventas/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductoRemoteDS {
  final _firestore = FirebaseFirestore.instance;
  final _collection = FirebaseFirestore.instance.collection('productos');

  Future<void> addProducto(Producto producto, String uid) async {
    if (producto.id.isEmpty) throw Exception('ID de producto vacío');
    await _collection.doc(producto.id).set({...producto.toMap(), 'uid': uid});
  }

  Future<void> deleteProducto(String id) async {
    if (id.isEmpty) throw Exception('ID vacío al eliminar');
    await _collection.doc(id).delete();
  }

  Future<void> updateProducto(Producto producto, String uid) async {
    if (producto.id.isEmpty) throw Exception('ID vacío al actualizar');
    await _collection.doc(producto.id).update(producto.toMap());
  }

  Stream<List<Producto>> getProductosStream(String uid) {
    return _collection.where('uid', isEqualTo: uid).snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => Producto.fromMap(doc.data(), id: doc.id),
          ) // ← IMPORTANTE
          .toList();
    });
  }
}
