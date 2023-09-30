import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_ecommerce/common/utils.dart';
import 'package:nike_ecommerce/data/favorite_manager.dart';
import 'package:nike_ecommerce/data/product.dart';
import 'package:nike_ecommerce/ui/product/details.dart';
import 'package:nike_ecommerce/ui/widgets/image.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
    required this.product,
    required this.borderRadius,
    this.itemWidth = 176,
    this.itemHeight = 189,
  }) : super(key: key);

  final ProductEntity product;
  final BorderRadius borderRadius;
  final double itemWidth;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
                  product: product,
                ))),
        child: SizedBox(
          width: itemWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: itemWidth / itemHeight,
                    child: ImageLoadingService(
                      imageUrl: product.imageUrl,
                      borderRadius: borderRadius,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: InkWell(
                      onTap: () {
                        if (favoriteManager.isFavorite(product)) {
                          favoriteManager.removeFavorite(product);
                        } else {
                          favoriteManager.addFavorite(product);
                        }
                      },
                      child: ValueListenableBuilder<Box<ProductEntity>>(
                        valueListenable: favoriteManager.listenable,
                        builder: (context, box, child) {
                          return Container(
                            height: 32,
                            width: 32,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              favoriteManager.isFavorite(product)
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  product.previousPrice.withPriceLAble,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(decoration: TextDecoration.lineThrough),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                child: Text(product.price.withPriceLAble),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
