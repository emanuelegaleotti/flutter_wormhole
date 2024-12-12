class PaintLine {
  final String id;
  final String code;

  PaintLine({
    required this.id,
    required this.code,
  });

  factory PaintLine.fromJson(Map<String, dynamic> json) {
    return PaintLine(
      id: json['id'],
      code: json['code'],
    );
  }
}
