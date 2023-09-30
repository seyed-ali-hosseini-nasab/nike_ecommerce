import 'package:dio/dio.dart';
import 'package:nike_ecommerce/data/order.dart';
import 'package:nike_ecommerce/data/common/http_response_validator.dart';
import 'package:nike_ecommerce/data/payment_receipt.dart';

abstract class IOrderDataSource {
  Future<CreateOrderResult> submitOrder(CreateOrderParams params);

  Future<PaymentReceiptData> getPaymentReceipt(String orderId);

  Future<List<OrderEntity>> getOrders();
}

class OrderRemoteDataSource
    with HttpResponseValidator
    implements IOrderDataSource {
  final Dio httpClient;

  OrderRemoteDataSource(this.httpClient);

  @override
  Future<CreateOrderResult> submitOrder(CreateOrderParams params) async {
    final response = await httpClient.post(
      '/order/submit',
      data: {
        "first_name": params.firstName,
        "last_name": params.lastName,
        "postal_code": params.postalCode,
        "mobile": params.phoneNumber,
        "address": params.address,
        "payment_method": params.paymentMethod == PaymentMethod.online
            ? 'online'
            : 'cash_on_delivery'
      },
    );
    validateResponse(response);

    return CreateOrderResult.fromJson(response.data);
  }

  @override
  Future<PaymentReceiptData> getPaymentReceipt(String orderId) async {
    final response = await httpClient.get('/order/checkout?order_id=$orderId');

    validateResponse(response);
    return PaymentReceiptData.fromJson(response.data);
  }

  @override
  Future<List<OrderEntity>> getOrders() async {
    final response = await httpClient.get('/order/list');
    return (response.data as List).map((e) => OrderEntity.fromJson(e)).toList();
  }
}
