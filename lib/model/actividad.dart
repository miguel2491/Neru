class Actividad {
  final int id;
  final int idvariable;
  final String nombre;
  final String ruta;
  final String estatus;

  Actividad({
    required this.id,
    required this.idvariable,
    required this.nombre,
    required this.ruta,
    required this.estatus,
  });

  factory Actividad.fromJson(Map<String, dynamic> json) {
    return Actividad(
      id: int.parse(json['id'].toString()),
      idvariable: int.parse(json['id_variable'].toString()),
      nombre: json['nombre'],
      ruta: json['ruta'],
      estatus: json['estatus'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idvariable': idvariable,
      'nombre': nombre,
      'ruta': ruta,
      'estatus': estatus,
    };
  }

  @override
  String toString() =>
      'Actividad(id: $id, idvariable: $idvariable,  nombre: $nombre, ruta: $ruta, estatus: $estatus)';
}
