import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce/common/exceptions.dart';
import 'package:nike_ecommerce/data/payment_receipt.dart';
import 'package:nike_ecommerce/data/repository/order_repository.dart';

part 'payment_receipt_event.dart';

part 'payment_receipt_state.dart';

class PaymentReceiptBloc
    extends Bloc<PaymentReceiptEvent, PaymentReceiptState> {
  final IOrderRepository repository;

  PaymentReceiptBloc(this.repository) : super(PaymentReceiptLoading()) {
    on<PaymentReceiptEvent>((event, emit) async {
      if (event is PaymentReceiptStarted) {
        try {
          emit(PaymentReceiptLoading());
          final PaymentReceiptData paymentReceiptData =
              await repository.getPaymentReceipt(event.orderId.toString());
          emit(PaymentReceiptSuccess(paymentReceiptData));
        } catch (e) {
          PaymentReceiptError(AppException());
        }
      }
    });
  }
}
