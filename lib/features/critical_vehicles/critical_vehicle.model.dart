class CriticalVehicle {
  final String id;
  final String brand;
  final String version;
  final String paint_line;
  final String serial;

  CriticalVehicle({
    required this.id,
    required this.brand,
    required this.paint_line,
    required this.serial,
    required this.version,
  });

  factory CriticalVehicle.fromJson(Map<String, dynamic> json) {
    return CriticalVehicle(
      id: json['id'],
      brand: json['brand'],
      paint_line: json['paint_line'],
      serial: json['serial'],
      version: json['version'],
    );
  }
}
