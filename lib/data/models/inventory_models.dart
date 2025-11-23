class FruitItem {
  final String id;
  final String name;
  final int dateAdded;      // Timestamp (milliseconds)
  final int expiryDate;     // Timestamp (milliseconds)
  final int freshness;      // 0-100
  final String grade;       // A/B/C
  final String? imageUri;   // Path file lokal atau URL
  final String aiDescription;
  final String storageAdvice;
  final List<String> recipes;

  FruitItem({
    required this.id,
    required this.name,
    required this.dateAdded,
    required this.expiryDate,
    required this.freshness,
    required this.grade,
    this.imageUri,
    this.aiDescription = "Analisa AI belum tersedia.",
    this.storageAdvice = "Simpan di tempat sejuk dan kering.",
    this.recipes = const [],
  });

  // --- Helper Methods (Opsional untuk JSON) --- 
  
  factory FruitItem.fromJson(Map<String, dynamic> json) {
    return FruitItem(
      id: json['id'],
      name: json['name'],
      dateAdded: json['dateAdded'],
      expiryDate: json['expiryDate'],
      freshness: json['freshness'],
      grade: json['grade'],
      imageUri: json['imageUri'],
      aiDescription: json['aiDescription'] ?? "Analisa AI belum tersedia.",
      storageAdvice: json['storageAdvice'] ?? "Simpan di tempat sejuk dan kering.",
      recipes: List<String>.from(json['recipes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dateAdded': dateAdded,
      'expiryDate': expiryDate,
      'freshness': freshness,
      'grade': grade,
      'imageUri': imageUri,
      'aiDescription': aiDescription,
      'storageAdvice': storageAdvice,
      'recipes': recipes,
    };
  }
}