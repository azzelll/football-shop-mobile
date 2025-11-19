import 'package:flutter/material.dart';
import 'package:football_shop/models/product_entry.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductEntry product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
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
                      errorBuilder: (c, e, s) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),

            // Product Info
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges
                  if (product.fields.isFeatured || product.fields.discount > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (product.fields.isFeatured)
                            _buildBadge('FEATURED', const Color(0xFFFEF3C7), const Color(0xFF92400E), Icons.star),
                          if (product.fields.discount > 0)
                            _buildBadge('${product.fields.discount.toInt()}% OFF', const Color(0xFFDC2626), Colors.white, Icons.local_fire_department),
                          _buildBadge(product.fields.categoryDisplay, const Color(0xFFD1FAE5), const Color(0xFF065F46), null),
                        ],
                      ),
                    ),

                  // Brand
                  Text(
                    product.fields.brand.toUpperCase(),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6B7280), letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 6),

                  // Product Name
                  Text(
                    product.fields.name,
                    style: TextStyle(fontSize: isTablet ? 26 : 22, fontWeight: FontWeight.bold, color: const Color(0xFF111827), height: 1.2),
                  ),
                  const SizedBox(height: 12),

                  // Rating
                  if (product.fields.rating > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Text(product.fields.getStarRating(), style: const TextStyle(fontSize: 18, color: Color(0xFFFBBF24))),
                          const SizedBox(width: 6),
                          Text(product.fields.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const Text(' / 5.0', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),

                  const Divider(height: 24),

                  // Price Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            product.fields.formattedPrice,
                            style: TextStyle(fontSize: isTablet ? 28 : 24, fontWeight: FontWeight.bold, color: const Color(0xFF16A34A)),
                          ),
                          if (product.fields.discount > 0) ...[
                            const SizedBox(width: 10),
                            Text(
                              'Rp ${product.fields.price}',
                              style: const TextStyle(fontSize: 16, decoration: TextDecoration.lineThrough, color: Color(0xFF9CA3AF)),
                            ),
                          ],
                        ],
                      ),
                      if (product.fields.discount > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'You save Rp ${(product.fields.price - product.fields.finalPrice).toString().replaceAllMapped(
                                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                  (Match m) => '${m[1]}.',
                                )} (${product.fields.discount.toInt()}%)',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF16A34A)),
                          ),
                        ),
                    ],
                  ),

                  const Divider(height: 24),

                  // Availability
                  Row(
                    children: [
                      Icon(
                        product.fields.isInStock ? Icons.check_circle : Icons.cancel,
                        color: product.fields.isInStock ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product.fields.isInStock ? 'In Stock (${product.fields.stock} units)' : 'Out of Stock',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: product.fields.isInStock ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),

                  // Available Sizes
                  if (product.fields.sizesList.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text('Available Sizes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: product.fields.sizesList.map((size) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFD1D5DB), width: 1.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(size, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                        );
                      }).toList(),
                    ),
                  ],

                  // Description
                  const SizedBox(height: 24),
                  const Text('Product Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  const SizedBox(height: 10),
                  Text(
                    product.fields.description,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF374151), height: 1.5),
                  ),
                ],
              ),
            ),

            // Features Section
            Padding(
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              child: Container(
                padding: EdgeInsets.all(isTablet ? 16 : 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const Column(
                  children: [
                    _FeatureItem(
                      icon: Icons.local_shipping_outlined,
                      title: 'Free Shipping',
                      subtitle: 'For orders over Rp 500.000',
                    ),
                    Divider(height: 20),
                    _FeatureItem(
                      icon: Icons.lock_outline,
                      title: 'Secure Payment',
                      subtitle: '100% secure transactions',
                    ),
                    Divider(height: 20),
                    _FeatureItem(
                      icon: Icons.replay_outlined,
                      title: 'Easy Returns',
                      subtitle: '30-day return policy',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF3F4F6),
      child: const Center(
        child: Icon(Icons.broken_image_outlined, size: 70, color: Color(0xFF9CA3AF)),
      ),
    );
  }

  Widget _buildBadge(String text, Color bg, Color textColor, IconData? icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: icon == null ? null : Border.all(color: textColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 5),
          ],
          Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: const Color(0xFF16A34A), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
            ],
          ),
        ),
      ],
    );
  }
}