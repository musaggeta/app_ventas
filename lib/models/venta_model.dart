class Venta {
  final String id;
  final String productoId;
  final int cantidad;
  final double total;
  final DateTime fecha;

  Venta({
    required this.id,
    required this.productoId,
    required this.cantidad,
    required this.total,
    required this.fecha,
  });

  factory Venta.fromMap(Map<String, dynamic> map, {String? id}) {
    return Venta(
      id: id ?? map['id'] ?? '',
      productoId: map['productoId'] ?? '',
      cantidad: (map['cantidad'] as num?)?.toInt() ?? 0,
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      fecha: map['fecha'] != null
          ? DateTime.parse(map['fecha'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'productoId': productoId,
    'cantidad': cantidad,
    'total': total,
    'fecha': fecha.toIso8601String(),
  };
}
