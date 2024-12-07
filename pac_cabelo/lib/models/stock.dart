import 'package:pac_cabelo/models/product.dart';

class Stock {
  String id;
  final String name;
  List<Product> products;

  Stock({
    required this.id,
    required this.name,
    this.products = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'products': products.map((product) => product.toMap()).toList(),
    };
  }

  // Corrigindo o método `fromMap` para aceitar Map<String, dynamic>
  factory Stock.fromMap(Map<String, dynamic> map, String id) {
    return Stock(
      id: id,
      name: map['name'] as String,
      // Ajustando para tratar a lista de produtos corretamente
      products: (map['products'] as List<dynamic>?)
              ?.map((productMap) =>
                  Product.fromMap(productMap as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
