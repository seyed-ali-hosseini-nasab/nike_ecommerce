import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/data/order.dart';
import 'package:nike_ecommerce/data/repository/order_repository.dart';
import 'package:nike_ecommerce/ui/cart/price_info.dart';
import 'package:nike_ecommerce/ui/payment_webview.dart';
import 'package:nike_ecommerce/ui/receipt/payment_receipt.dart';
import 'package:nike_ecommerce/ui/shipping/bloc/shipping_bloc.dart';

class ShippingScreen extends StatefulWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  const ShippingScreen(
      {super.key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  StreamSubscription? subscription;
  final TextEditingController firstName = TextEditingController();

  final TextEditingController lastName = TextEditingController();

  final TextEditingController phoneNumber = TextEditingController();

  final TextEditingController postalCode = TextEditingController();

  final TextEditingController address = TextEditingController();

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحویل گیرنده'),
        centerTitle: false,
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final bloc = ShippingBloc(orderRepository);
          subscription = bloc.stream.listen((state) {
            if (state is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.appException.message)));
            } else if (state is ShippingSuccess) {
              if (state.result.bankGatewayUrl.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentGatewayScreen(
                        bankGatewayUrl: state.result.bankGatewayUrl),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PaymentReceiptScreen(orderId: state.result.orderId),
                  ),
                );
              }
            }
          });
          return bloc;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: firstName,
                decoration: const InputDecoration(label: Text('نام')),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lastName,
                decoration: const InputDecoration(label: Text('نام خانوادگی')),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneNumber,
                decoration: const InputDecoration(label: Text('شماره تماس')),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: postalCode,
                decoration: const InputDecoration(label: Text('کد پستی')),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: address,
                decoration: const InputDecoration(label: Text('آدرس')),
              ),
              PriceInfo(
                payablePrice: widget.payablePrice,
                shippingCost: widget.shippingCost,
                totalPrice: widget.totalPrice,
              ),
              BlocBuilder<ShippingBloc, ShippingState>(
                builder: (context, state) {
                  return state is ShippingLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                BlocProvider.of<ShippingBloc>(context).add(
                                    ShippingCreateOrder(CreateOrderParams(
                                        firstName.text,
                                        lastName.text,
                                        postalCode.text,
                                        phoneNumber.text,
                                        address.text,
                                        PaymentMethod.cashOnDelivery)));
                              },
                              child: const Text('پرداخت در محل'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<ShippingBloc>(context).add(
                                    ShippingCreateOrder(CreateOrderParams(
                                        firstName.text,
                                        lastName.text,
                                        postalCode.text,
                                        phoneNumber.text,
                                        address.text,
                                        PaymentMethod.online)));
                              },
                              child: const Text('پرداخت اینترنتی'),
                            ),
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
