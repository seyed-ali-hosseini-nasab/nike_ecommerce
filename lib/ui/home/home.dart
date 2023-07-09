import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/common/utils.dart';
import 'package:nike_ecommerce/data/product.dart';
import 'package:nike_ecommerce/data/repository/banner_repository.dart';
import 'package:nike_ecommerce/data/repository/product_repository.dart';
import 'package:nike_ecommerce/ui/home/bloc/home_bloc.dart';
import 'package:nike_ecommerce/ui/product/product.dart';
import 'package:nike_ecommerce/ui/widgets/error.dart';
import 'package:nike_ecommerce/ui/widgets/slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(
            productRepository: productRepository,
            bannerRepository: bannerRepository);
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        body: SafeArea(child: BlocBuilder<HomeBloc, HomeState>(
          builder: ((context, state) {
            if (state is HomeSuccess) {
              return ListView.builder(
                  physics: defaultScrollPhysic,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Container(
                          height: 56,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/nike_logo.png',
                            height: 24,
                            fit: BoxFit.fitHeight,
                          ),
                        );
                      case 2:
                        return BannerSlider(
                          banners: state.banners,
                        );
                      case 3:
                        return _HorizontalProductList(
                          title: 'جدیدترین',
                          onTab: () {},
                          products: state.latestProducts,
                        );
                      case 4:
                        return _HorizontalProductList(
                          title: 'پربازدیدترین',
                          onTab: () {},
                          products: state.popularProducts,
                        );
                      default:
                        return Container();
                    }
                  });
            } else if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeError) {
              return AppErrorWidget(
                exception: state.exception,
                onPressed: () {
                  return BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                },
              );
            } else {
              throw Exception('State is not supported');
            }
          }),
        )),
      ),
    );
  }
}

class _HorizontalProductList extends StatelessWidget {
  final String title;
  final GestureTapCallback onTab;
  final List<ProductEntity> products;

  const _HorizontalProductList({
    Key? key,
    required this.title,
    required this.onTab,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              TextButton(onPressed: onTab, child: const Text('مشاهده همه')),
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: ListView.builder(
            physics: defaultScrollPhysic,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductItem(
                product: product,
                borderRadius: BorderRadius.circular(12),
              );
            },
            padding: const EdgeInsets.only(left: 8, right: 8),
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
          ),
        )
      ],
    );
  }
}
