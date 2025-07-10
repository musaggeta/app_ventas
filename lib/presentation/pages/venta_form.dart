import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_ventas/application/venta_provider.dart';
import 'package:app_ventas/application/producto_provider.dart';
import 'package:app_ventas/models/product_model.dart';

class VentaForm extends ConsumerStatefulWidget {
  const VentaForm({super.key});

  @override
  ConsumerState<VentaForm> createState() => _VentaFormState();
}

class _VentaFormState extends ConsumerState<VentaForm> {
  String? _selectedProductId;
  int _cantidad = 1;
  double _total = 0.0;

  @override
  Widget build(BuildContext context) {
    final productos = ref.watch(productoProvider);

    if (_selectedProductId != null) {
      final prod = productos.firstWhere((p) => p.id == _selectedProductId);
      _total = prod.precio * _cantidad;
    } else {
      _total = 0.0;
    }

    return AlertDialog(
      title: const Text('Nueva Venta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedProductId,
            decoration: const InputDecoration(labelText: 'Producto'),
            items: productos.map((p) {
              return DropdownMenuItem(
                value: p.id,
                child: Text('${p.nombre} (Stock: ${p.stock})'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedProductId = value);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: '1',
            decoration: const InputDecoration(labelText: 'Cantidad'),
            keyboardType: TextInputType.number,
            onChanged: (text) {
              final qty = int.tryParse(text) ?? 1;
              setState(() => _cantidad = qty < 1 ? 1 : qty);
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:'),
              Text('\$${_total.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_selectedProductId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Selecciona un producto')),
              );
              return;
            }
            // 1) Validación de stock en el UI
            final productos = ref.read(productoProvider);
            final prod = productos.firstWhere(
              (p) => p.id == _selectedProductId,
            );
            if (_cantidad > prod.stock) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No hay suficiente stock')),
              );
              return;
            }

            // 2) Llama al provider **sin riesgo**
            await ref
                .read(ventaProvider.notifier)
                .addVenta(
                  productoId: _selectedProductId!,
                  cantidad: _cantidad,
                  total: _total,
                );

            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
