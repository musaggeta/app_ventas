class Producto {
  final String id;
  final String nombre;
  final String descripcion;
  final String unidad;
  final double valorUnidad;
  final double precio;
  final int stock;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.unidad,
    required this.valorUnidad,
    required this.precio,
    required this.stock,
  });

  factory Producto.fromMap(Map<String, dynamic> map, {String? id}) => Producto(
    id: id ?? map['id'] ?? '',
    nombre: map['nombre'] ?? '',
    descripcion: map['descripcion'] ?? '',
    unidad: map['unidad'] ?? 'und',
    valorUnidad: (map['valorUnidad'] as num?)?.toDouble() ?? 1.0,
    precio: (map['precio'] as num?)?.toDouble() ?? 0.0,
    stock: (map['stock'] as int?) ?? 0,
  );

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'descripcion': descripcion,
    'unidad': unidad,
    'valorUnidad': valorUnidad,
    'precio': precio,
    'stock': stock,
  };
}

extension ProductoCopy on Producto {
  Producto copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    String? unidad,
    double? valorUnidad,
    double? precio,
    int? stock,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      unidad: unidad ?? this.unidad,
      valorUnidad: valorUnidad ?? this.valorUnidad,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
    );
  }
}
