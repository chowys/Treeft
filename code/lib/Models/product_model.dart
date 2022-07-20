import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'product_model.g.dart';

@HiveType(typeId: 0)
class Product extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final List<String> images;
  @HiveField(4)
  final double price;
  @HiveField(5)
  final bool isFeatured;
  @HiveField(6)
  final bool isGeneral;
  @HiveField(7)
  final String userName;
  @HiveField(8)
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.images,
    required this.price,
    required this.isFeatured,
    required this.isGeneral,
    required this.userName,
    required this.description,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        images,
        price,
        isFeatured,
        isGeneral,
        userName,
        description
      ];

  static Product fromSnapshot(DocumentSnapshot snap) {
    Product product = Product(
        id: snap['uid'],
        name: snap['name'],
        category: snap['category'],
        images: snap['images'],
        price: snap['price'],
        isFeatured: snap['featured'],
        isGeneral: snap['general'],
        userName: snap['username'],
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
