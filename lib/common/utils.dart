import 'package:flutter/material.dart';

const defaultScrollPhysic = BouncingScrollPhysics();


extension PriceLable on int{
  String get withPriceLAble => '$thisتومان ';
}