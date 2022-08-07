import 'package:code/Page/Screens.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:code/Models/product_model.dart';

class WishListModel extends Equatable {
  final List<Product> products;

  const WishListModel({this.products = const <Product>[]});

  @override
  List<Object?> get props => [products];
}
