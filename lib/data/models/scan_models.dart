class ScanResultModel {
  final String name;
  final String grade;
  final int freshness;
  final String description;

  ScanResultModel({
    required this.name,
    required this.grade,
    required this.freshness,
    required this.description,
  });

  // Helper untuk konversi dari Map (jika data dikirim via arguments navigasi)
  factory ScanResultModel.fromMap(Map<String, dynamic> map) {
    return ScanResultModel(
      name: map['name'] ?? 'Unknown',
      grade: map['grade'] ?? '-',
      freshness: map['freshness'] is int ? map['freshness'] : 0,
      description: map['desc'] ?? '',
    );
  }
}
