import 'package:flutter/material.dart';
import 'package:football_shop/config.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:football_shop/models/product_entry.dart';
import 'package:football_shop/screens/product_detail.dart';
import 'package:football_shop/widgets/left_drawer.dart';

class ProductListPage extends StatefulWidget {
  final bool filterByUser;

  const ProductListPage({
    super.key,
    this.filterByUser = false,
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    try {
      // PENTING: Sesuaikan URL dengan environment Anda
      // - Android Emulator: http://10.0.2.2:8000
      // - iOS Simulator: http://127.0.0.1:8000
      // - Real Device: http://YOUR_COMPUTER_IP:8000
      
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
            onPressed: () {
              setState(() {}); // Trigger rebuild to refresh data
            },
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
              onRetry: () {
                setState(() {}); // Trigger rebuild to retry
              },
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _EmptyState(filterByUser: widget.filterByUser);
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {}); // Trigger rebuild to refresh
            },
            color: const Color(0xFF16A34A),
            child: _ProductList(products: snapshot.data!),
          );
        },
      ),
    );
  }
}

// Loading State Widget
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF16A34A),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          const Text(
            'Loading products...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

// Error State Widget
class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 60,
                color: Color(0xFFDC2626),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Failed to Load Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Please check your connection\nand try again',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Empty State Widget
class _EmptyState extends StatelessWidget {
  final bool filterByUser;

  const _EmptyState({required this.filterByUser});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 60,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              filterByUser ? 'No Products Yet' : 'No Products Available',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              filterByUser
                  ? 'Start by adding your first product\nto showcase your items'
                  : 'No products have been added yet\nCheck back later',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            if (filterByUser) ...[
              const SizedBox(height: 32),
              FilledButton.icon(
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Your First Product'),
                onPressed: () {
                  Navigator.pushNamed(context, '/product/add');
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Product List Widget
class _ProductList extends StatelessWidget {
  final List<ProductEntry> products;

  const _ProductList({required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _ProductCard(product: products[index]);
      },
    );
  }
}

// Product Card Widget
class _ProductCard extends StatelessWidget {
  final ProductEntry product;

  const _ProductCard({required this.product});

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductImage(product: product),
            _ProductInfo(product: product),
          ],
        ),
      ),
    );
  }
}

// Product Image Widget  
class _ProductImage extends StatelessWidget {
  final ProductEntry product;

  const _ProductImage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: product.fields.thumbnail.isNotEmpty
              ? Image.network(
                  product.fields.thumbnail,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: const Color(0xFF16A34A),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder();
                  },
                )
              : _buildPlaceholder(),
        ),
        if (product.fields.isFeatured || product.fields.discount > 0)
          Positioned(
            top: 12,
            right: 12,
            child: _ProductBadges(product: product),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF3F4F6),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 64,
          color: Color(0xFF9CA3AF),
        ),
      ),
    );
  }
}

// Product Badges Widget
class _ProductBadges extends StatelessWidget {
  final ProductEntry product;

  const _ProductBadges({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (product.fields.isFeatured)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 14, color: Color(0xFF92400E)),
                SizedBox(width: 4),
                Text(
                  'FEATURED',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF92400E),
                  ),
                ),
              ],
            ),
          ),
        if (product.fields.discount > 0) ...[
          if (product.fields.isFeatured) const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFDC2626),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '-${product.fields.discount.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// Product Info Widget
class _ProductInfo extends StatelessWidget {
  final ProductEntry product;

  const _ProductInfo({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductBrand(brand: product.fields.brand),
          const SizedBox(height: 6),
          _ProductName(name: product.fields.name),
          const SizedBox(height: 10),
          _CategoryBadge(category: product.fields.categoryDisplay),
          const SizedBox(height: 12),
          if (product.fields.rating > 0) _ProductRating(product: product),
          _ProductPrice(product: product),
          const SizedBox(height: 12),
          _StockStatus(product: product),
          const SizedBox(height: 10),
          _ProductDescription(description: product.fields.description),
        ],
      ),
    );
  }
}

// Individual Info Components
class _ProductBrand extends StatelessWidget {
  final String brand;

  const _ProductBrand({required this.brand});

  @override
  Widget build(BuildContext context) {
    return Text(
      brand.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Color(0xFF6B7280),
        letterSpacing: 0.8,
      ),
    );
  }
}

class _ProductName extends StatelessWidget {
  final String name;

  const _ProductName({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF111827),
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;

  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFD1FAE5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        category,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF065F46),
        ),
      ),
    );
  }
}

class _ProductRating extends StatelessWidget {
  final ProductEntry product;

  const _ProductRating({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            product.fields.getStarRating(),
            style: const TextStyle(fontSize: 16, color: Color(0xFFFBBF24)),
          ),
          const SizedBox(width: 8),
          Text(
            product.fields.rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductPrice extends StatelessWidget {
  final ProductEntry product;

  const _ProductPrice({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          product.fields.formattedPrice,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF16A34A),
          ),
        ),
        if (product.fields.discount > 0) ...[
          const SizedBox(width: 10),
          Text(
            'Rp ${product.fields.price}',
            style: const TextStyle(
              fontSize: 14,
              decoration: TextDecoration.lineThrough,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ],
    );
  }
}

class _StockStatus extends StatelessWidget {
  final ProductEntry product;

  const _StockStatus({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: product.fields.isInStock
            ? const Color(0xFFD1FAE5)
            : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            product.fields.isInStock ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: product.fields.isInStock
                ? const Color(0xFF16A34A)
                : const Color(0xFFDC2626),
          ),
          const SizedBox(width: 6),
          Text(
            product.fields.isInStock
                ? 'In Stock (${product.fields.stock})'
                : 'Out of Stock',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: product.fields.isInStock
                  ? const Color(0xFF16A34A)
                  : const Color(0xFFDC2626),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductDescription extends StatelessWidget {
  final String description;

  const _ProductDescription({required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: const TextStyle(
        fontSize: 13,
        color: Color(0xFF6B7280),
        height: 1.5,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
