import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/venta_model.dart';

class VentaRemoteDS {
  final _collection = FirebaseFirestore.instance.collection('ventas');

  Future<void> addVenta(Venta venta, String uid) async {
    if (venta.id.isEmpty) throw Exception('ID vacío al guardar venta');
    await _collection.doc(venta.id).set({...venta.toMap(), 'uid': uid});
  }

  Future<void> deleteVenta(String id) async {
    if (id.isEmpty) throw Exception('ID vacío al eliminar venta');
    await _collection.doc(id).delete();
  }

  Stream<List<Venta>> getVentasStream(String uid) {
    return _collection.where('uid', isEqualTo: uid).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // pasamos doc.id y doc.data() al factory
        return Venta.fromMap(doc.data(), id: doc.id);
      }).toList();
    });
  }
}
