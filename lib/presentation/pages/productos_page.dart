import 'package:app_ventas/presentation/pages/producto_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_ventas/application/producto_provider.dart';
import 'package:app_ventas/models/product_model.dart';

class ProductoPage extends ConsumerWidget {
  const ProductoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productos = ref.watch(productoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: productos.isEmpty
          ? const Center(child: Text('No hay productos'))
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final p = productos[index];
                return Dismissible(
                  key: ValueKey(p.id),
                  background: Container(
                    color: Colors.red.shade700,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    ref.read(productoProvider.notifier).eliminarProducto(p.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Producto "${p.nombre}" eliminado'),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(p.nombre),
                      subtitle: Text('${p.descripcion} • Stock: ${p.stock}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (_) => ProductoForm(producto: p),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            showDialog(context: context, builder: (_) => const ProductoForm()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
