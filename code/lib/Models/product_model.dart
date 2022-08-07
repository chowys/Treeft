import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'product_model.g.dart';

@HiveType(typeId: 0)
class Product extends Equatable {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final List<dynamic> images;
  @HiveField(4)
  final double price;
  @HiveField(5)
  final bool featured;
  @HiveField(6)
  final bool general;
  @HiveField(7)
  final String username;
  @HiveField(8)
  final String description;

  const Product({
    required this.uid,
    required this.name,
    required this.category,
    required this.images,
    required this.price,
    required this.featured,
    required this.general,
    required this.username,
    required this.description,
  });

  @override
  List<Object?> get props => [
        uid,
        name,
        category,
        images,
        price,
        featured,
        general,
        username,
        description
      ];

  static Product fromSnapshot(DocumentSnapshot snap) {
    Product product = Product(
        uid: snap['uid'],
        name: snap['name'],
        category: snap['category'],
        images: snap['images'],
        price: (snap['price'] as num).toDouble(),
        featured: snap['featured'],
        general: snap['general'],
        username: snap['username'],
        description: snap['description']);
    return product;
  }

  // static List<Product> products = [
  //   Product(
  //       name: 'Clothes',
  //       category: 'Clothes',
  //       images: [
  //         'https://target.scene7.com/is/image/Target/GUEST_693c1197-393c-4aa5-a4e6-70ec71be5419?wid=315&hei=315&qlt=60&fmt=pjpeg'
  //       ],
  //       price: 2.99,
  //       isFeatured: true,
  //       isGeneral: true,
  //       userName: 'hello')
  // ];
}
