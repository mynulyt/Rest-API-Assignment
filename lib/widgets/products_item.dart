import 'package:assignment_restapi/Model/product_model.dart';
import 'package:flutter/material.dart';

class ProductsItem extends StatefulWidget {
  const ProductsItem({
    super.key,
    required this.product,
    required this.refreshProductList,
  });

  final ProductModel product;
  final VoidCallback refreshProductList;

  @override
  State<ProductsItem> createState() => _ProductsItemState();
}

class _ProductsItemState extends State<ProductsItem> {
  final bool _deleteProgress = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        width: 30,
        Widget.product.image,
        errorBuilder: (_, __, ___) {
          return Icon(Icons.error_outline, size: 30);
        },
      ),
      title: Text(Widget.product.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Code: ${Widget.product.code}'),
          Row(
            spacing: 16,
            children: [
              Text('Quantity: ${Widget.product.quantity}'),
              Text('Quantity: ${Widget.product.UnitPrice}'),
            ],
          ),
        ],
      ),
      trailing: Visibility(
        visible: _deleteProgress == false,
        replacement: CircularProgressIndicator(),

        child: PopupMenuButton<ProductOptions>(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: ProductOptions.Update,
                child: Text("Update"),
              ),
              PopupMenuItem(
                value: ProductOptions.delete,
                child: Text("delete"),
              ),
            ];
          },
          onSelected: (ProductO),
        ),
      ),
    );
  }
}
