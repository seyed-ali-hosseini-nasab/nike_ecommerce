import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_ecommerce/data/product.dart';

final favoriteManager = FavoriteManager();

class FavoriteManager {
  static const _boxName = "favorites";
  final _box = Hive.box<ProductEntity>(_boxName);

  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductEntityAdapter());
    Hive.openBox<ProductEntity>(_boxName);
  }

  ValueListenable<Box<ProductEntity>> get listenable => _box.listenable();

  void addFavorite(ProductEntity product) {
    _box.put(product.id, product);
  }

  void removeFavorite(ProductEntity product) {
    _box.delete(product.id);
  }

  List<ProductEntity> get favorites => _box.values.toList();

  bool isFavorite(ProductEntity product) => _box.containsKey(product.id);
}
