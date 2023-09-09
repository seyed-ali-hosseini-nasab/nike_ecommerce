import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const defaultScrollPhysic = BouncingScrollPhysics();

extension PriceLable on int {
  String get withPriceLAble => this > 0 ? '$separateByComma تومان' : 'رایگان';

  String get separateByComma{
    final numberFormat = NumberFormat.decimalPattern();
    return numberFormat.format(this);
  }
}
