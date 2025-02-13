class Plant {
  final String name;
  final String description;
  final String imageUrl;
  final String wateringInterval; // Sulama aralığı
  final String plantingSeason;  // Ekilme zamanı
  final String harvestTime;     // Hasat süresi

  Plant({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.wateringInterval,
    required this.plantingSeason,
    required this.harvestTime,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      wateringInterval: json['wateringInterval'], // JSON'dan alınıyor
      plantingSeason: json['plantingSeason'],     // JSON'dan alınıyor
      harvestTime: json['harvestTime'],           // JSON'dan alınıyor
    );
  }
}
