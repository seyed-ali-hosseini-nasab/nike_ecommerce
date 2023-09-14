import 'package:flutter/material.dart';
import 'package:nike_ecommerce/ui/cart/price_info.dart';

class ShippingScreen extends StatelessWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  const ShippingScreen(
      {super.key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحویل گیرنده'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(label: Text('نام و نام خانوادکی')),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(label: Text('شماره تماس')),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(label: Text('کد پستی')),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(label: Text('آدرس')),
            ),
            PriceInfo(
              payablePrice: payablePrice,
              shippingCost: shippingCost,
              totalPrice: totalPrice,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('پرداخت در محل'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('پرداخت اینترنتی'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
