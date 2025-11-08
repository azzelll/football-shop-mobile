import 'package:flutter/material.dart';

class ProductSummaryData {
  final String name;
  final String brand;
  final String category;
  final String description;
  final int price;
  final double discount;
  final int stock;
  final double rating;
  final List<String> sizes;
  final String thumbnailUrl;
  final bool isFeatured;

  const ProductSummaryData({
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.price,
    required this.discount,
    required this.stock,
    required this.rating,
    required this.sizes,
    required this.thumbnailUrl,
    required this.isFeatured,
  });
}

Future<void> showProductSummaryDialog(
  BuildContext context,
  ProductSummaryData data,
) {
  return showDialog<void>(
    context: context,
    builder: (context) => ProductSummaryDialog(data: data),
  );
}

class ProductSummaryDialog extends StatelessWidget {
  final ProductSummaryData data;

  const ProductSummaryDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final displaySizes = data.sizes.isEmpty ? '-' : data.sizes.join(', ');

    return AlertDialog(
      title: const Text('Produk berhasil dibuat'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DialogRow(title: 'Product Name', value: data.name),
          _DialogRow(title: 'Brand', value: data.brand),
          _DialogRow(title: 'Category', value: data.category),
          _DialogRow(title: 'Price (Rp)', value: 'Rp${data.price}'),
          _DialogRow(title: 'Discount (%)', value: '${data.discount}'),
          _DialogRow(title: 'Stock', value: '${data.stock}'),
          _DialogRow(title: 'Rating (0-5)', value: '${data.rating}'),
          _DialogRow(title: 'Available Sizes', value: displaySizes),
          _DialogRow(
            title: 'Featured Product',
            value: data.isFeatured ? 'Yes' : 'No',
          ),
          const SizedBox(height: 8),
          const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(data.description),
          const SizedBox(height: 8),
          const Text(
            'Thumbnail Image URL',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(data.thumbnailUrl),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }
}

class _DialogRow extends StatelessWidget {
  final String title;
  final String value;

  const _DialogRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
