class Variable {
  final int id;
  final String nombre;
  final String estatus;

  Variable({required this.id, required this.nombre, required this.estatus});

  factory Variable.fromJson(Map<String, dynamic> json) {
    return Variable(
      id: int.parse(json['id'].toString()),
      nombre: json['nombre'],
      estatus: json['estatus'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre': nombre, 'estatus': estatus};
  }

  @override
  String toString() => 'Variable(id: $id, nombre: $nombre, estatus: $estatus)';
}
