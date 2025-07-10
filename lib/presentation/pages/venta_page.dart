import 'package:app_ventas/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_ventas/application/venta_provider.dart';
import 'package:app_ventas/application/producto_provider.dart';
import 'package:app_ventas/models/venta_model.dart';
import 'package:intl/intl.dart';
import 'venta_form.dart';

class VentaPage extends ConsumerWidget {
  const VentaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ventas = ref.watch(ventaProvider);
    final productos = ref.watch(productoProvider);
    final dateFmt = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(title: const Text('Ventas')),
      body: ventas.isEmpty
          ? const Center(child: Text('No hay ventas registradas'))
          : ListView.builder(
              itemCount: ventas.length,
              itemBuilder: (context, i) {
                final v = ventas[i];
                // Buscamos el producto correspondiente
                final prod = productos.firstWhere(
                  (p) => p.id == v.productoId,
                  orElse: () => Producto(
                    id: v.productoId,
                    nombre: 'Desconocido',
                    descripcion: '',
                    unidad: '',
                    valorUnidad: 0,
                    precio: 0,
                    stock: 0,
                  ),
                );
                return Dismissible(
                  key: ValueKey(v.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red.shade700,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    ref.read(ventaProvider.notifier).deleteVenta(v.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Venta de "${prod.nombre}" eliminada'),
                      ),
                    );
                  },
                  child: Card(
                    // El color y forma vienen del theme global
                    child: ListTile(
                      title: Text(prod.nombre),
                      subtitle: Text(
                        'Cantidad: ${v.cantidad}\n'
                        'Total: \$${v.total.toStringAsFixed(2)}\n'
                        'Fecha: ${dateFmt.format(v.fecha)}',
                      ),
                      isThreeLine: true,
                      onTap: () {
                        // Si implementas edición, podrías pasar `v` aquí
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            showDialog(context: context, builder: (_) => const VentaForm()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
