import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String name;
  final String category;
  final String imageUrl;
  final double price;
  final bool isFeatured;

  const Product({
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.isFeatured,
  });

  @override
  List<Object?> get props => [name, category, imageUrl, price, isFeatured];

  static List<Product> products = [
    Product(
        name: 'Clothes',
        category: 'Clothes',
        imageUrl:
            'https://target.scene7.com/is/image/Target/GUEST_693c1197-393c-4aa5-a4e6-70ec71be5419?wid=315&hei=315&qlt=60&fmt=pjpeg',
        price: 2.99,
        isFeatured: true)
  ];
}
