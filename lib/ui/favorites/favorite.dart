import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_ecommerce/common/utils.dart';
import 'package:nike_ecommerce/data/favorite_manager.dart';
import 'package:nike_ecommerce/data/product.dart';
import 'package:nike_ecommerce/theme.dart';
import 'package:nike_ecommerce/ui/product/details.dart';
import 'package:nike_ecommerce/ui/widgets/image.dart';

class FavoriteListScreen extends StatelessWidget {
  const FavoriteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست علاقه مندی ها'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<ProductEntity>>(
        valueListenable: favoriteManager.listenable,
        builder: (context, box, child) {
          final products = box.values.toList();
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 100),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: product),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 110,
                            height: 110,
                            child: ImageLoadingService(
                              imageUrl: product.imageUrl,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              favoriteManager.removeFavorite(product);
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(CupertinoIcons.delete_simple),
                                Text(
                                  'حذف از لیست',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: LightThemeColors.primaryTextColor,
                                  ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              product.previousPrice.withPriceLAble,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            ),
                            Text(product.price.withPriceLAble),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
