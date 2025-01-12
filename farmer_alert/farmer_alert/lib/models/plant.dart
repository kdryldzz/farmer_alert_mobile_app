class Plant {
  final String name;
  final String description;
  final String imageUrl;

  Plant({
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
