import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/common/utils.dart';
import 'package:nike_ecommerce/data/repository/order_repository.dart';
import 'package:nike_ecommerce/theme.dart';
import 'package:nike_ecommerce/ui/receipt/bloc/payment_receipt_bloc.dart';

class PaymentReceiptScreen extends StatelessWidget {
  final int orderId;

  const PaymentReceiptScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('رسید پرداخت'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: BlocProvider<PaymentReceiptBloc>(
          create: (context) => PaymentReceiptBloc(orderRepository)
            ..add(PaymentReceiptStarted(orderId)),
          child: BlocBuilder<PaymentReceiptBloc, PaymentReceiptState>(
            builder: (context, state) {
              if (state is PaymentReceiptSuccess) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: themeData.dividerColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            state.paymentReceiptData.purchaseSuccess
                                ? 'پرداخت با موفقیت انجام شد'
                                : 'پرداخت ناموفق',
                            style: themeData.textTheme.titleLarge!.apply(
                              color: themeData.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'وضعیت سفارش',
                                style: TextStyle(
                                  color: LightThemeColors.secondaryTextColor,
                                ),
                              ),
                              Text(
                                state.paymentReceiptData.paymentStatus,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 32,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'مبلغ',
                                style: TextStyle(
                                  color: LightThemeColors.secondaryTextColor,
                                ),
                              ),
                              Text(
                                state.paymentReceiptData.payablePrice
                                    .withPriceLAble,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: const Text('بازگشت به صفحه اصلی'),
                    ),
                  ],
                );
              } else if (state is PaymentReceiptError) {
                return Center(child: Text(state.exception.massage));
              } else if (state is PaymentReceiptLoading) {
                return const Center(child: CupertinoActivityIndicator());
              } else {
                throw Exception('state is not defined');
              }
            },
          ),
        ),
      ),
    );
  }
}
