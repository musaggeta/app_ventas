import 'dart:async';
import 'package:app_ventas/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:app_ventas/data/repository/venta_repository.dart';
import 'package:app_ventas/models/venta_model.dart';
import 'package:app_ventas/application/producto_provider.dart';

/// Provider que expone la lista de ventas
final ventaProvider = StateNotifierProvider<VentaNotifier, List<Venta>>((ref) {
  return VentaNotifier(ref);
});

class VentaNotifier extends StateNotifier<List<Venta>> {
  final Ref _ref;
  late final VentaRepository _repository;
  StreamSubscription<List<Venta>>? _sub;
  final _uuid = const Uuid();

  VentaNotifier(this._ref) : super([]) {
    // Inicializa el repositorio desde ref
    _repository = _ref.read(ventaRepositoryProvider);
    _load();
  }

  void _load() {
    _sub?.cancel();
    _sub = _repository.ventasRemotas().listen((ventas) {
      state = ventas;
    });
  }

  Future<void> addVenta({
    required String productoId,
    required int cantidad,
    required double total,
  }) async {
    // ya no validamos stock aquí

    final venta = Venta(
      id: _uuid.v4(),
      productoId: productoId,
      cantidad: cantidad,
      total: total,
      fecha: DateTime.now(),
    );
    await _repository.addVenta(venta);

    // actualizar stock sigue igual
    final productos = _ref.read(productoProvider);
    final prod = productos.firstWhere((p) => p.id == productoId);
    final actualizado = prod.copyWith(stock: prod.stock - cantidad);
    await _ref.read(productoProvider.notifier).actualizarProducto(actualizado);
  }

  Future<void> deleteVenta(String id) async {
    await _repository.deleteVenta(id);
    // Opcional: podrías revertir stock aquí
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
