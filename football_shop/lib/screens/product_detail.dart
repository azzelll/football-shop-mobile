import 'package:flutter/material.dart';
import 'package:football_shop/models/product_entry.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductEntry product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Product Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            AspectRatio(
              aspectRatio: 1,
              child: product.fields.thumbnail.isNotEmpty
                  ? Image.network(
                      product.fields.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF3F4F6),
                          child: const Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 80,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: const Color(0xFFF3F4F6),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 80,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
            ),

            // Product Info
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges
                  if (product.fields.isFeatured || product.fields.discount > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (product.fields.isFeatured)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFFBBF24),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Color(0xFF92400E),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'FEATURED',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF92400E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (product.fields.discount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDC2626),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${product.fields.discount.toStringAsFixed(0)}% OFF',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1FAE5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF16A34A),
                              ),
                            ),
                            child: Text(
                              product.fields.categoryDisplay,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF065F46),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Brand
                  Text(
                    product.fields.brand.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B7280),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Product Name
                  Text(
                    product.fields.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Rating
                  if (product.fields.rating > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Text(
                            product.fields.getStarRating(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xFFFBBF24),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            product.fields.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const Text(
                            ' / 5.0',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const Divider(height: 32),

                  // Price Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            product.fields.formattedPrice,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                          if (product.fields.discount > 0) ...[
                            const SizedBox(width: 12),
                            Text(
                              'Rp ${product.fields.price}',
                              style: const TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.lineThrough,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (product.fields.discount > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'You save Rp ${(product.fields.price - product.fields.finalPrice).toString().replaceAllMapped(
                                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                  (Match m) => '${m[1]}.',
                                )} (${product.fields.discount.toStringAsFixed(0)}%)',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const Divider(height: 32),

                  // Availability
                  Row(
                    children: [
                      Icon(
                        product.fields.isInStock
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: product.fields.isInStock
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFDC2626),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product.fields.isInStock
                            ? 'In Stock (${product.fields.stock} units available)'
                            : 'Out of Stock',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: product.fields.isInStock
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),

                  // Available Sizes
                  if (product.fields.sizesList.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Available Sizes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: product.fields.sizesList.map((size) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFD1D5DB),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            size,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  // Description
                  const SizedBox(height: 32),
                  const Text(
                    'Product Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.fields.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            // Features Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Column(
                children: [
                  FeatureItem(
                    icon: Icons.local_shipping_outlined,
                    title: 'Free Shipping',
                    subtitle: 'For orders over Rp 500.000',
                  ),
                  Divider(height: 24),
                  FeatureItem(
                    icon: Icons.lock_outline,
                    title: 'Secure Payment',
                    subtitle: '100% secure transactions',
                  ),
                  Divider(height: 24),
                  FeatureItem(
                    icon: Icons.replay_outlined,
                    title: 'Easy Returns',
                    subtitle: '30-day return policy',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF16A34A),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}