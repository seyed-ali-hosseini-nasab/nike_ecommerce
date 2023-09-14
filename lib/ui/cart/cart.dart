import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_ecommerce/data/repository/auth_repository.dart';
import 'package:nike_ecommerce/data/repository/cart_repository.dart';
import 'package:nike_ecommerce/ui/auth/auth.dart';
import 'package:nike_ecommerce/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_ecommerce/ui/cart/cart_item.dart';
import 'package:nike_ecommerce/ui/cart/price_info.dart';
import 'package:nike_ecommerce/ui/shipping/shipping.dart';
import 'package:nike_ecommerce/ui/widgets/empty_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? cartBloc;
  StreamSubscription? stateStreamSubscription;
  final RefreshController _refreshController = RefreshController();
  bool stateIsSuccess = false;

  @override
  void initState() {
    super.initState();
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    cartBloc?.close();
    stateStreamSubscription?.cancel();
    super.dispose();
  }

  void authChangeNotifierListener() {
    cartBloc?.add(CartAuthInfoChanged(AuthRepository.authChangeNotifier.value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("سبد خرید"),
        ),
        floatingActionButton: Visibility(
          visible: stateIsSuccess,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 48, right: 48),
            child: FloatingActionButton.extended(
              onPressed: () {
                final state = cartBloc!.state;
                if (state is CartSuccess) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShippingScreen(
                      payablePrice: state.cartResponse.payablePrice,
                      shippingCost: state.cartResponse.shippingCost,
                      totalPrice: state.cartResponse.totalPrice,
                    ),
                  ));
                }
              },
              label: const Text('پرداخت'),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: BlocProvider<CartBloc>(
          create: (context) {
            final bloc = CartBloc(cartRepository);
            stateStreamSubscription = bloc.stream.listen((state) {
              setState(() {
                stateIsSuccess = state is CartSuccess;
              });
              if (_refreshController.isRefresh) {
                if (state is CartSuccess) {
                  _refreshController.refreshCompleted();
                } else if (state is CartError) {
                  _refreshController.refreshFailed();
                }
              }
            });
            cartBloc = bloc;
            bloc.add(CartStarted(AuthRepository.authChangeNotifier.value));
            return bloc;
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CartError) {
                return Center(
                  child: Text(state.exception.massage),
                );
              } else if (state is CartSuccess) {
                return SmartRefresher(
                  controller: _refreshController,
                  header: const ClassicHeader(
                    completeText: 'با موفقیت انجام شد',
                    refreshingText: 'در حال بروزرسانی',
                    idleText: 'به پایین بکشید',
                    releaseText: 'رها کنید',
                    failedText: 'خطای نامشخص',
                    spacing: 2,
                  ),
                  onRefresh: () {
                    cartBloc?.add(CartStarted(
                        AuthRepository.authChangeNotifier.value,
                        isRefreshing: true));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemBuilder: (context, index) {
                      if (index < state.cartResponse.cartItems.length) {
                        final data = state.cartResponse.cartItems[index];
                        return CartItem(
                          data: data,
                          onDeleteButtonClick: () {
                            cartBloc?.add(CartDeleteButtonClicked(data.id));
                          },
                          onIncreaseButtonClick: () {
                            if (data.count < 5) {
                              cartBloc?.add(
                                  CartIncreaseCountButtonClicked(data.id));
                            }
                          },
                          onDecreaseButtonClick: () {
                            if (data.count > 1) {
                              cartBloc?.add(
                                  CartDecreaseCountButtonClicked(data.id));
                            }
                          },
                        );
                      } else {
                        return PriceInfo(
                          payablePrice: state.cartResponse.payablePrice,
                          shippingCost: state.cartResponse.shippingCost,
                          totalPrice: state.cartResponse.totalPrice,
                        );
                      }
                    },
                    itemCount: state.cartResponse.cartItems.length + 1,
                  ),
                );
              } else if (state is CartAuthRequired) {
                return EmptyView(
                  message:
                      'برای مشاهده سبد خرید خود ابتدا وارد حساب کاربری شوید',
                  callToAction: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AuthScreen()));
                    },
                    child: const Text('ورود به حساب کاربری'),
                  ),
                  image: SvgPicture.asset(
                    'assets/images/auth_required.svg',
                    width: 140,
                  ),
                );
              } else if (state is CartEmpty) {
                return EmptyView(
                  message: 'سبد خرید خالی است',
                  image: SvgPicture.asset(
                    'assets/images/empty_cart.svg',
                    width: 200,
                  ),
                );
              } else {
                throw Exception('current cart state is not valid');
              }
            },
          ),
        )
        // ValueListenableBuilder<AuthInfo?>(
        //   valueListenable: AuthRepository.authChangeNotifier,
        //   builder: (context, authState, child) {
        //     bool isAuthenticated =
        //         authState != null && authState.accessToken.isNotEmpty;
        //     return SizedBox(
        //       width: MediaQuery.of(context).size.width,
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Text(
        //             isAuthenticated
        //                 ? 'خوش آمدید'
        //                 : 'لطفا وارد حساب کاربری خود شوید',
        //           ),
        //           isAuthenticated
        //               ? ElevatedButton(
        //                   onPressed: () {
        //                     authRepository.signOut();
        //                   },
        //                   child: const Text('خروج از حساب کاربری'),
        //                 )
        //               : ElevatedButton(
        //                   onPressed: () {
        //                     Navigator.of(context, rootNavigator: true).push(
        //                         MaterialPageRoute(
        //                             builder: (context) => const AuthScreen()));
        //                   },
        //                   child: const Text('ورود'),
        //                 ),
        //           ElevatedButton(
        //             onPressed: () {
        //               authRepository.refreshToken();
        //             },
        //             child: const Text('Refresh Token'),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // ),
        );
  }
}
