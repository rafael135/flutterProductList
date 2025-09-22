import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(product.image, width: 50, height: 50, fit: BoxFit.cover),
      title: Text(product.title),
      subtitle: Text('${product.category}\nR\$ ${product.price.toStringAsFixed(2)}'),
      isThreeLine: true,
    );
  }
}
