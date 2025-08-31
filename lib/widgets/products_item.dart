import 'package:assignment_restapi/Model/product_model.dart';
import 'package:assignment_restapi/Utils/urls.dart';
import 'package:assignment_restapi/screen/update_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
    required this.product,
    required this.refreshProductList,
  });

  final ProductModel product;
  final VoidCallback refreshProductList;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _deleteInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.product.image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Icon(
                  Icons.inventory_2_outlined,
                  size: 30,
                  color: Colors.grey.shade400,
                );
              },
              loadingBuilder: (
                BuildContext context,
                Widget child,
                ImageChunkEvent? loadingProgress,
              ) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value:
                        loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                    strokeWidth: 2,
                  ),
                );
              },
            ),
          ),
        ),
        title: Text(
          widget.product.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Code: ${widget.product.code}',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.inventory_2,
                    text: 'Qty: ${widget.product.quantity}',
                    color: Colors.blue.shade100,
                    textColor: Colors.blue.shade800,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    icon: Icons.attach_money,
                    text: '\$${widget.product.uniPrice}',
                    color: Colors.green.shade100,
                    textColor: Colors.green.shade800,
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: SizedBox(
          width: 48,
          child:
              _deleteInProgress
                  ? const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : PopupMenuButton<ProductOptions>(
                    icon: const Icon(Icons.more_vert),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    itemBuilder: (ctx) {
                      return [
                        PopupMenuItem(
                          value: ProductOptions.update,
                          child: Row(
                            children: const [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text('Update'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: ProductOptions.delete,
                          child: Row(
                            children: const [
                              Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: Colors.red,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                    onSelected: (ProductOptions selectedOption) {
                      if (selectedOption == ProductOptions.delete) {
                        _showDeleteConfirmationDialog();
                      } else if (selectedOption == ProductOptions.update) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => UpdateProductScreen(
                                  product: widget.product,
                                ),
                          ),
                        ).then((_) => widget.refreshProductList());
                      }
                    },
                  ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
            'Are you sure you want to delete "${widget.product.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct() async {
    setState(() {
      _deleteInProgress = true;
    });

    Uri uri = Uri.parse(Urls.deleteProductsUrl(widget.product.id));
    Response response = await get(uri);

    debugPrint(response.statusCode.toString());
    debugPrint(response.body);

    if (response.statusCode == 200) {
      widget.refreshProductList();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${widget.product.name}" deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete product'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _deleteInProgress = false;
    });
  }
}

enum ProductOptions { update, delete }
