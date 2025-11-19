import 'package:flutter/material.dart';
import 'package:football_shop/config.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:football_shop/models/product_entry.dart';
import 'package:football_shop/screens/product_detail.dart';
import 'package:football_shop/widgets/left_drawer.dart';

class ProductListPage extends StatefulWidget {
  final bool filterByUser;

  const ProductListPage({super.key, this.filterByUser = false});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    try {
      final endpoint = widget.filterByUser
          ? '$baseUrl/flutter/products/?user=me'
          : '$baseUrl/flutter/products/';

      final response = await request.get(endpoint);

      List<ProductEntry> listProduct = [];
      for (var d in response) {
        if (d != null) {
          listProduct.add(ProductEntry.fromJson(d));
        }
      }
      return listProduct;
    } catch (e) {
      debugPrint('Error fetching products: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filterByUser ? 'My Products' : 'All Products'),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => setState(() {}),
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      backgroundColor: const Color(0xFFF9FAFB),
      body: FutureBuilder(
        future: fetchProducts(request),
        builder: (context, AsyncSnapshot<List<ProductEntry>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingState();
          }

          if (snapshot.hasError) {
            return _ErrorState(
              error: snapshot.error.toString(),
              onRetry: () => setState(() {}),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _EmptyState(filterByUser: widget.filterByUser);
          }

          return RefreshIndicator(
            onRefresh: () async => setState(() {}),
            color: const Color(0xFF16A34A),
            child: _ProductList(products: snapshot.data!),
          );
        },
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF16A34A), strokeWidth: 3),
          SizedBox(height: 16),
          Text('Loading products...', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(Icons.error_outline, size: 50, color: Color(0xFFDC2626)),
            ),
            const SizedBox(height: 20),
            const Text('Failed to Load', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Please check connection', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool filterByUser;

  const _EmptyState({required this.filterByUser});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.inventory_2_outlined, size: 50, color: Color(0xFF9CA3AF)),
            ),
            const SizedBox(height: 20),
            Text(
              filterByUser ? 'No Products Yet' : 'No Products Available',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              filterByUser ? 'Start by adding your first product' : 'No products available',
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
            if (filterByUser) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Product'),
                onPressed: () => Navigator.pushNamed(context, '/product/add'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  final List<ProductEntry> products;

  const _ProductList({required this.products});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    return ListView.builder(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      itemCount: products.length,
      itemBuilder: (context, index) => _ProductCard(product: products[index]),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductEntry product;

  const _ProductCard({required this.product});

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetailPage(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    return Card(
      margin: EdgeInsets.only(bottom: isTablet ? 14 : 12),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: product.fields.thumbnail.isNotEmpty
                      ? Image.network(
                          product.fields.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
                // Badges
                if (product.fields.isFeatured || product.fields.discount > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (product.fields.isFeatured)
                          _buildBadge('FEATURED', const Color(0xFFFEF3C7), const Color(0xFF92400E), Icons.star),
                        if (product.fields.discount > 0) ...[
                          if (product.fields.isFeatured) const SizedBox(height: 4),
                          _buildBadge('-${product.fields.discount.toInt()}%', const Color(0xFFDC2626), Colors.white, null),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
            // Info
            Padding(
              padding: EdgeInsets.all(isTablet ? 14 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.fields.brand.toUpperCase(),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6B7280), letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.fields.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827), height: 1.2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Category + Rating row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1FAE5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          product.fields.categoryDisplay,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF065F46)),
                        ),
                      ),
                      if (product.fields.rating > 0) ...[
                        const Spacer(),
                        Text(product.fields.getStarRating(), style: const TextStyle(fontSize: 13, color: Color(0xFFFBBF24))),
                        const SizedBox(width: 4),
                        Text('${product.fields.rating.toStringAsFixed(1)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Price
                  Row(
                    children: [
                      Text(
                        product.fields.formattedPrice,
                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                      ),
                      if (product.fields.discount > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          'Rp ${product.fields.price}',
                          style: const TextStyle(fontSize: 12, decoration: TextDecoration.lineThrough, color: Color(0xFF9CA3AF)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Stock
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: product.fields.isInStock ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          product.fields.isInStock ? Icons.check_circle : Icons.cancel,
                          size: 14,
                          color: product.fields.isInStock ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          product.fields.isInStock ? 'Stock: ${product.fields.stock}' : 'Out of Stock',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: product.fields.isInStock ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.fields.description,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
        child: Icon(Icons.image_not_supported_outlined, size: 50, color: Color(0xFF9CA3AF)),
      ),
    );
  }

  Widget _buildBadge(String text, Color bg, Color textColor, IconData? icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 3, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }
}