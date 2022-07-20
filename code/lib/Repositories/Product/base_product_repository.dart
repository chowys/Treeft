import 'package:code/Models/models.dart';

abstract class BaseProductRepository {
  Stream<List<Product>> getAllProducts();
}
