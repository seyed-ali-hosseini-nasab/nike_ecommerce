import 'package:flutter/material.dart';
import 'package:nike_ecommerce/common/exceptions.dart';

class AppErrorWidget extends StatelessWidget {
  final AppException exception;
  final GestureTapCallback onPressed;

  const AppErrorWidget({
    Key? key,
    required this.exception,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(exception.massage),
          ElevatedButton(onPressed: onPressed, child: const Text('تلاش دوباره'))
        ],
      ),
    );
  }
}
