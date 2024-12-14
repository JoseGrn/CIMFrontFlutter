class Combo {
  final int id;
  final String nombreCombo;
  final String descripcion;
  final double precioCombo;
  final int estado;
  final DateTime fechaCreacion;

  Combo({
    required this.id,
    required this.nombreCombo,
    required this.descripcion,
    required this.precioCombo,
    required this.estado,
    required this.fechaCreacion,
  });

  factory Combo.fromJson(Map<String, dynamic> json) {
    return Combo(
      id: json['ComboID'],
      nombreCombo: json['NombreCombo'],
      descripcion: json['Descripcion'],
      precioCombo: double.parse(json['PrecioCombo']),
      estado: json['Estado'],
      fechaCreacion: DateTime.parse(json['FechaCreacion']),
    );
  }
}
