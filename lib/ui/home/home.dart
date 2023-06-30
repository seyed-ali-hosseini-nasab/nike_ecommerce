import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/data/repository/banner_repository.dart';
import 'package:nike_ecommerce/data/repository/product_repository.dart';
import 'package:nike_ecommerce/ui/home/bloc/home_bloc.dart';

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
                  itemCount: 5,
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Image.asset(
                          'assets/images/nike_logo.png',
                          height: 32,
                        );
                      default:
                        return Container();
                    }
                  });
            } else if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(state.exception.massage),
                    ElevatedButton(
                        onPressed: () {
                          return BlocProvider.of<HomeBloc>(context)
                              .add(HomeRefresh());
                        },
                        child: const Text('تلاش دوباره'))
                  ],
                ),
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
