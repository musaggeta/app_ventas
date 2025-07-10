import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_ventas/models/product_model.dart';
import 'package:app_ventas/application/producto_provider.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

class ProductoForm extends ConsumerWidget {
  final Producto? producto;
  const ProductoForm({super.key, this.producto});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nombreCtrl = TextEditingController(text: producto?.nombre ?? '');
    final descCtrl = TextEditingController(text: producto?.descripcion ?? '');
    final precioCtrl = TextEditingController(
      text: producto?.precio.toString() ?? '',
    );
    final stockCtrl = TextEditingController(
      text: producto?.stock.toString() ?? '',
    );

    return AlertDialog(
      title: Text(producto == null ? 'Nuevo Producto' : 'Editar Producto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: precioCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio'),
            ),
            TextField(
              controller: stockCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stock'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            print('Producto original al editar: ${producto?.id}');
            final productoNuevo = Producto(
              id: producto?.id ?? uuid.v4(),
              nombre: nombreCtrl.text.trim(),
              descripcion: descCtrl.text.trim(),
              unidad: 'und',
              valorUnidad: 1,
              precio: double.tryParse(precioCtrl.text) ?? 0,
              stock: int.tryParse(stockCtrl.text) ?? 0,
            );

            if (producto == null) {
              ref
                  .read(productoProvider.notifier)
                  .agregarProducto(productoNuevo);
            } else {
              ref
                  .read(productoProvider.notifier)
                  .actualizarProducto(productoNuevo);
            }

            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
