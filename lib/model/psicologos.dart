class Psicologo {
  final String nombre;
  final String descripcion;
  final String imagenUrl;
  final String? celular;
  final String? correo;

  Psicologo({
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
    this.celular,
    this.correo,
  });

  factory Psicologo.fromJson(Map<String, dynamic> json) {
    return Psicologo(
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      imagenUrl: json['imagenUrl'],
      celular: json['celular'].toString(),
      correo: json['correo'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'imagenUrl': imagenUrl,
      'celular': celular,
      'correo': correo,
    };
  }

  @override
  String toString() =>
      'Psicologos(nombre: $nombre, descripcion: $descripcion, imagenUrl: $imagenUrl, celular: $celular, correo: $correo)';
}
