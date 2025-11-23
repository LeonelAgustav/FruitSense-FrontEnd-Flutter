class FruitItem {
  final String id;
  final String name;
  final String? imageUri;
  final String grade;
  final int freshness;
  final int expiryDate;
  final String aiDescription;
  final String storageAdvice;
  final int stock;
  final int dateAdded; // Properti yang sebelumnya hilang
  final List<String> recipes;

  FruitItem({
    required this.id,
    required this.name,
    this.imageUri,
    required this.grade,
    required this.freshness,
    required this.expiryDate,
    required this.aiDescription,
    required this.storageAdvice,
    required this.stock,
    required this.dateAdded,
    this.recipes = const [],
  });

  factory FruitItem.fromJson(Map<String, dynamic> json) {
    int parseDate(String? dateStr) {
      if (dateStr == null) return 0;
      try {
        return DateTime.parse(dateStr).millisecondsSinceEpoch;
      } catch (e) {
        return 0;
      }
    }

    int calcFreshness(dynamic daysLeft) {
      if (daysLeft == null) return 50;
      int days = daysLeft is int
          ? daysLeft
          : int.tryParse(daysLeft.toString()) ?? 0;
      if (days < 0) return 0;
      if (days > 7) return 100;
      return (days / 7 * 100).clamp(0, 100).toInt();
    }

    return FruitItem(
      id: json['id'].toString(),
      name: json['fruit_name'] ?? 'Tanpa Nama',
      imageUri: json['image_url'],
      grade: json['grade'] ?? 'Unknown',
      stock: json['stock_quantity'] ?? 0,
      aiDescription: json['nutrients'] ?? "Analisa nutrisi tersedia.",
      storageAdvice: "Simpan di suhu ruang atau kulkas sesuai jenis.",
      expiryDate: parseDate(json['expiration_date']),
      freshness: calcFreshness(json['days_until_expired']),
      // Mengambil tanggal dibuat dari backend (created_at)
      dateAdded: parseDate(json['created_at']),
      recipes: [],
    );
  }
}
