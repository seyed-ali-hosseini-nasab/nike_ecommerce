import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/common/utils.dart';
import 'package:nike_ecommerce/data/repository/order_repository.dart';
import 'package:nike_ecommerce/ui/order/bloc/order_history_bloc.dart';
import 'package:nike_ecommerce/ui/widgets/image.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderHistoryBloc(orderRepository)..add(OrderHistoryStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سوابق سفارش'),
          centerTitle: true,
        ),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistorySuccess) {
              final orders = state.orders.reversed.toList();
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          height: 56,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('شناسه سفارش'),
                              Text(order.id.toString()),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Container(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          height: 56,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('مبلغ'),
                              Text(order.payablePrice.withPriceLAble),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        SizedBox(
                          height: 132,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            itemCount: order.items.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 100,
                                height: 100,
                                margin:
                                    const EdgeInsets.only(left: 4, right: 4),
                                child: ImageLoadingService(
                                  borderRadius: BorderRadius.circular(8),
                                  imageUrl: order.items[index].imageUrl,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is OrderHistoryLoading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state is OrderHistoryError) {
              return Center(child: Text(state.exception.message));
            } else {
              throw Exception('Invalid state');
            }
          },
        ),
      ),
    );
  }
}
