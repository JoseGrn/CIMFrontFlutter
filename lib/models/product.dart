class Product {
  final int id;
  final String nombre;
  final String descripcion;
  final double pesoDisponible;
  final double precioPorLibra;
  final double precioPorMediaLibra;
  final int cantidadMinima;
  final String tipoEmpaque;
  final int estado;
  final DateTime fechaRegistro;
  final int pesoXCaja;

  Product({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.pesoDisponible,
    required this.precioPorLibra,
    required this.precioPorMediaLibra,
    required this.cantidadMinima,
    required this.tipoEmpaque,
    required this.estado,
    required this.fechaRegistro,
    required this.pesoXCaja,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['ProductoID'],
      nombre: json['Nombre'],
      descripcion: json['Descripcion'],
      pesoDisponible: double.parse(json['PesoDisponible']),
      precioPorLibra: double.parse(json['PrecioPorLibra']),
      precioPorMediaLibra: double.parse(json['PrecioPorMediaLibra']),
      cantidadMinima: json['CantidadMinima'],
      tipoEmpaque: json['TipoEmpaque'],
      estado: json['Estado'],
      fechaRegistro: DateTime.parse(json['FechaRegistro']),
      pesoXCaja: json['PesoXCaja'],
    );
  }
}
