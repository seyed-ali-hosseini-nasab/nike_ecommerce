import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/common/utils.dart';
import 'package:nike_ecommerce/data/favorite_manager.dart';
import 'package:nike_ecommerce/data/product.dart';
import 'package:nike_ecommerce/data/repository/cart_repository.dart';
import 'package:nike_ecommerce/theme.dart';
import 'package:nike_ecommerce/ui/product/bloc/product_bloc.dart';
import 'package:nike_ecommerce/ui/product/comment/comment_list.dart';
import 'package:nike_ecommerce/ui/widgets/image.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductEntity product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  StreamSubscription<ProductState>? stateSubscription;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void dispose() {
    stateSubscription?.cancel();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc = ProductBloc(cartRepository);
          stateSubscription = bloc.stream.listen((state) {
            if (state is ProductAddToCartSuccess) {
              _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text('با موفقیت به سبد خرید اضافه شد')));
            } else if (state is ProductAddToCartError) {
              _scaffoldKey.currentState?.showSnackBar(
                  SnackBar(content: Text(state.exception.massage)));
            }
          });
          return bloc;
        },
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: MediaQuery.of(context).size.width - 48,
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) => FloatingActionButton.extended(
                  onPressed: () {
                    BlocProvider.of<ProductBloc>(context)
                        .add(CartAddButtonClick(widget.product.id));
                  },
                  label: state is ProductAddToCartButtonLoading
                      ? CupertinoActivityIndicator(
                          color: Theme.of(context).colorScheme.onSecondary,
                        )
                      : const Text('افزودن به سبد خرید'),
                ),
              ),
            ),
            body: CustomScrollView(
              physics: defaultScrollPhysic,
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width * 0.8,
                  flexibleSpace: ImageLoadingService(
                    imageUrl: widget.product.imageUrl,
                  ),
                  foregroundColor: LightThemeColors.primaryTextColor,
                  actions: [
                    IconButton(
                      onPressed: () {
                        if (favoriteManager.isFavorite(widget.product)) {
                          favoriteManager.removeFavorite(widget.product);
                        } else {
                          favoriteManager.addFavorite(widget.product);
                        }

                        setState(() {});
                      },
                      icon:  Icon(favoriteManager.isFavorite(widget.product)
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,),
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
                                widget.product.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.product.previousPrice.withPriceLAble,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .apply(
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),
                                Text(widget.product.price.withPriceLAble),
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
                              style: Theme.of(context).textTheme.titleMedium,
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
                CommentListScreen(productId: widget.product.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
