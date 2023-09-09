import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce/common/exceptions.dart';
import 'package:nike_ecommerce/data/auth_info.dart';
import 'package:nike_ecommerce/data/cart_response.dart';
import 'package:nike_ecommerce/data/repository/cart_repository.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepository;

  CartBloc(this.cartRepository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          await loadCartItem(emit, event.isRefreshing);
        }
      } else if (event is CartDeleteButtonClicked) {
        try {
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final index = successState.cartResponse.cartItems
                .indexWhere((element) => element.id == event.cartItemId);
            successState.cartResponse.cartItems[index].deleteButtonLoading =
                true;
            emit(CartSuccess(successState.cartResponse));
          }
          await cartRepository.delete(event.cartItemId);
          await cartRepository.count();
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            successState.cartResponse.cartItems
                .removeWhere((element) => element.id == event.cartItemId);
            if (successState.cartResponse.cartItems.isEmpty) {
              emit(CartEmpty());
            } else {
              emit(calculatePriceInfo(successState.cartResponse));
            }
          }
        } catch (e) {}
      } else if (event is CartAuthInfoChanged) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          if (state is CartAuthRequired) {
            await loadCartItem(emit, false);
          }
        }
      } else if (event is CartIncreaseCountButtonClicked ||
          event is CartDecreaseCountButtonClicked) {
        final int cartItemId = event is CartIncreaseCountButtonClicked
            ? event.cartItemId
            : (event as CartDecreaseCountButtonClicked).cartItemId;
        try {
          late final int newCount;
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final index = successState.cartResponse.cartItems
                .indexWhere((element) => element.id == cartItemId);
            successState.cartResponse.cartItems[index].changeCountLoading =
                true;
            emit(CartSuccess(successState.cartResponse));
            newCount = event is CartIncreaseCountButtonClicked
                ? ++successState.cartResponse.cartItems[index].count
                : --successState.cartResponse.cartItems[index].count;
            await cartRepository.changeCount(cartItemId, newCount);
            await cartRepository.count();
          }
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            successState.cartResponse.cartItems
                .firstWhere((element) => element.id == cartItemId)
              ..count = newCount
              ..changeCountLoading = false;
            emit(calculatePriceInfo(successState.cartResponse));
          }
        } catch (e) {}
      }
    });
  }

  Future<void> loadCartItem(Emitter<CartState> emit, bool isRefreshing) async {
    try {
      if (!isRefreshing) {
        emit(CartLoading());
      }
      final result = await cartRepository.getAll();
      if (result.cartItems.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartSuccess(result));
      }
    } catch (e) {
      emit(CartError(AppException()));
    }
  }

  CartSuccess calculatePriceInfo(CartResponse cartResponse) {
    int payablePrice = 0;
    int shippingCost = 0;
    int totalPrice = 0;
    for (var cartItem in cartResponse.cartItems) {
      totalPrice += cartItem.product.previousPrice * cartItem.count;
      payablePrice += cartItem.product.price * cartItem.count;
    }
    shippingCost = payablePrice > 250000 ? 0 : 30000;
    cartResponse.payablePrice = payablePrice;
    cartResponse.shippingCost = shippingCost;
    cartResponse.totalPrice = totalPrice;

    return CartSuccess(cartResponse);
  }
}
