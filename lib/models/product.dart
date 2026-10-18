class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String priceText; // Ekranda gösterilecek metin, örn. "$2,499"
  final double price; // Sepet toplamı için sayı, örn. 2499.0
  final String currency;
  final String imagePath; // Yerel asset yolu, örn. assets/images/iphone.png
  final Map<String, String> specs;

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.priceText,
    required this.price,
    required this.currency,
    required this.imagePath,
    required this.specs,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final priceText = json['price'] as String;
    final imageUrl = json['image'] as String;
    final rawSpecs = json['specs'] as Map<String, dynamic>? ?? {};

    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: json['tagline'] as String,
      description: json['description'] as String,
      priceText: priceText,
      // "$2,499" -> "2499" -> 2499.0
      price: double.parse(priceText.replaceAll(RegExp(r'[^0-9.]'), '')),
      currency: json['currency'] as String,
      // Uzaktaki adresin son parçasını alıp yerel asset yoluna çeviriyoruz
      imagePath: 'assets/images/${imageUrl.split('/').last}',
      specs: rawSpecs.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'price': priceText,
      'currency': currency,
      'image': imagePath,
      'specs': specs,
    };
  }
}