class Product {
  final String name;
  final String price;
  final String imageUrl;
  final String url;

  Product(
      {required this.name,
      required this.price,
      required this.imageUrl,
      required this.url});

  // JSON'dan veri alırken kullanmak için fromJson constructor
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        name: json['Product Name'],
        price: json['Product Price'],
        imageUrl: json['Image Url'],
        url: json['Product Url']);
  }
}
