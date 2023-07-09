import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_ecommerce/common/utils.dart';
import 'package:nike_ecommerce/data/product.dart';
import 'package:nike_ecommerce/theme.dart';
import 'package:nike_ecommerce/ui/product/comment/comment_list.dart';
import 'package:nike_ecommerce/ui/widgets/image.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          width: MediaQuery.of(context).size.width - 48,
          child: FloatingActionButton.extended(
            onPressed: () {},
            label: const Text('افزودن به سبد خرید'),
          ),
        ),
        body: CustomScrollView(
          physics: defaultScrollPhysic,
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.width * 0.8,
              flexibleSpace: ImageLoadingService(
                imageUrl: product.imageUrl,
              ),
              foregroundColor: LightThemeColors.primaryTextColor,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.heart),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              product.previousPrice.withPriceLAble,
                              style: Theme.of(context).textTheme.caption!.apply(
                                  decoration: TextDecoration.lineThrough),
                            ),
                            Text(product.price.withPriceLAble),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'این کتونی بسیار عالی است.این کتونی بسیار عالی است.این کتونی بسیار عالی است.این کتونی بسیار عالی است.این کتونی بسیار عالی است.',
                      style: TextStyle(height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'نظرات کاربران',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('ثبت نظر'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            CommentListScreen(productId: product.id),
          ],
        ),
      ),
    );
  }
}
