class Model {
  final String id;
  final String brand;
  final String version;

  Model({
    required this.id,
    required this.brand,
    required this.version,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'],
      brand: json['brand'],
      version: json['version'],
    );
  }
}