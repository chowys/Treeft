import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String name;
  final String imageUrl;

  const Category({
    required this.name,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [name, imageUrl];

  static List<Category> categories = [
    Category(
        name: 'Clothings',
        imageUrl:
            'https://images.theconversation.com/files/293774/original/file-20190924-54793-157i3zo.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=1200.0&fit=crop'),
    Category(
        name: 'Electronics',
        imageUrl:
            'https://www.greenbiz.com/sites/default/files/2022-04/varietyofelectronics_shutterstock_DAMRONGRATTANAPONG.jpeg'),
    Category(
        name: 'Furniture',
        imageUrl:
            'https://static.thehoneycombers.com/wp-content/uploads/sites/2/2020/02/online-furniture-stores-singapore.png'),
    Category(
        name: 'Food',
        imageUrl:
            'https://www.getdinkum.com/wp-content/uploads/2020/10/Dinkum-Matilda-900x600-1.jpg'),
  ];
}
