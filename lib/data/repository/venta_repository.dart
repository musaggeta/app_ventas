import 'package:app_ventas/application/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/venta_model.dart';
import '../local/venta_db.dart';
import '../remote/venta_remote_ds.dart';

final ventaRepositoryProvider = Provider(
  (ref) => VentaRepository(
    db: VentaDB.instancia,
    remote: VentaRemoteDS(),
    uid: ref.watch(authProvider)!.uid,
  ),
);

class VentaRepository {
  final VentaDB db;
  final VentaRemoteDS remote;
  final String uid;

  VentaRepository({required this.db, required this.remote, required this.uid});

  Future<void> addVenta(Venta v) async {
    await db.insertVenta(v);
    await remote.addVenta(v, uid);
  }

  Future<void> deleteVenta(String id) async {
    await db.deleteVenta(id);
    await remote.deleteVenta(id);
  }

  Future<List<Venta>> getVentasLocal() => db.getVentas();

  Stream<List<Venta>> ventasRemotas() => remote.getVentasStream(uid);
}
