import 'dart:convert';

List<ProductEntry> productEntryFromJson(String str) => List<ProductEntry>.from(
    json.decode(str).map((x) => ProductEntry.fromJson(x)));

String productEntryToJson(List<ProductEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductEntry {
  String model;
  String pk;
  Fields fields;

  ProductEntry({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int user;
  String name;
  String brand;
  String category;
  String description;
  int price;
  double discount;
  int stock;
  double rating;
  String sizes;
  String thumbnail;
  bool isFeatured;

  Fields({
    required this.user,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.price,
    required this.discount,
    required this.stock,
    required this.rating,
    required this.sizes,
    required this.thumbnail,
    required this.isFeatured,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        name: json["name"],
        brand: json["brand"],
        category: json["category"],
        description: json["description"],
        price: json["price"],
        discount: (json["discount"] ?? 0).toDouble(),
        stock: json["stock"],
        rating: (json["rating"] ?? 0).toDouble(),
        sizes: json["sizes"] ?? "",
        thumbnail: json["thumbnail"] ?? "",
        isFeatured: json["is_featured"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "name": name,
        "brand": brand,
        "category": category,
        "description": description,
        "price": price,
        "discount": discount,
        "stock": stock,
        "rating": rating,
        "sizes": sizes,
        "thumbnail": thumbnail,
        "is_featured": isFeatured,
      };

  // Helper methods
  bool get isInStock => stock > 0;

  int get finalPrice => (price * (1 - discount / 100)).round();

  String get formattedPrice => 'Rp ${finalPrice.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';

  String get categoryDisplay {
    switch (category) {
      case 'shoes':
        return 'Sepatu';
      case 'clothing':
        return 'Pakaian';
      case 'gear':
        return 'Gear';
      case 'accessories':
        return 'Aksesoris';
      case 'lifestyle':
        return 'Lifestyle';
      default:
        return category;
    }
  }

  List<String> get sizesList {
    if (sizes.isEmpty) return [];
    return sizes.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  String getStarRating() {
    if (rating >= 4.5) return '★★★★★';
    if (rating >= 3.5) return '★★★★☆';
    if (rating >= 2.5) return '★★★☆☆';
    if (rating >= 1.5) return '★★☆☆☆';
    return '★☆☆☆☆';
  }
}