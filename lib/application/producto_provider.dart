import 'dart:async';
import 'package:app_ventas/data/repository/produto_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_ventas/models/product_model.dart';
import 'package:uuid/uuid.dart';

final productoProvider =
    StateNotifierProvider<ProductoNotifier, List<Producto>>((ref) {
      final repository = ref.read(productoRepositoryProvider);
      return ProductoNotifier(repository);
    });

class ProductoNotifier extends StateNotifier<List<Producto>> {
  final ProductoRepository repository;
  StreamSubscription<List<Producto>>? _sub;
  final _uuid = const Uuid();

  ProductoNotifier(this.repository) : super([]) {
    _load();
  }

  void _load() {
    _sub?.cancel();
    _sub = repository.productosRemotos().listen((productos) {
      state = productos;
    });
  }

  Future<void> agregarProducto(Producto p) async {
    final nuevoProducto = p.id.isEmpty ? p.copyWith(id: _uuid.v4()) : p;

    await repository.addProducto(nuevoProducto);
  }

  Future<void> actualizarProducto(Producto p) async {
    await repository.updateProducto(p);
  }

  Future<void> eliminarProducto(String id) async {
    await repository.deleteProducto(id);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
