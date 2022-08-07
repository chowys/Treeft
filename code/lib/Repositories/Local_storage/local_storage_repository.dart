import 'package:hive/hive.dart';

import 'package:code/Repositories/repositories.dart';
import '/Models/models.dart';

class LocalStorageRepository extends BaseLocalStorageRepository {
  String boxName = 'wishlist_products';
  Type boxType = Product;

  @override
  Future<Box> openBox() async {
    Box box = await Hive.openBox<Product>(boxName);
    return box;
  }

  @override
  List<Product> getWishlist(Box box) {
    return box.values.toList() as List<Product>;
  }

  @override
  Future<void> addProductToWishlist(Box box, Product product) async {
    await box.put(product.uid, product);
  }

  @override
  Future<void> removeProductFromWishlist(Box box, Product product) async {
    await box.delete(product.uid);
  }

  @override
  Future<void> clearWishlist(Box box) async {
    await box.clear();
  }
}
