import 'package:flutter/material.dart';
import 'package:football_shop/widgets/left_drawer.dart';
import 'package:football_shop/screens/product_list.dart';
import 'package:football_shop/screens/product_form.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  final String nama = 'Made Shandy Krisnanda';
  final String npm = '2406495615';
  final String kelas = 'C';

  @override
  Widget build(BuildContext context) {
    final items = [
      ItemHomepage(
        name: 'All Products',
        icon: Icons.storefront,
        color: const Color(0xFF16A34A),
        onTap: (ctx) {
          Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (context) => const ProductListPage(
                filterByUser: false,
              ),
            ),
          );
        },
      ),
      ItemHomepage(
        name: 'My Products',
        icon: Icons.inventory_2,
        color: const Color(0xFF22C55E),
        onTap: (ctx) {
          Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (context) => const ProductListPage(
                filterByUser: true,
              ),
            ),
          );
        },
      ),
      ItemHomepage(
        name: 'Create Product',
        icon: Icons.add_circle_outline,
        color: const Color(0xFFDC2626),
        onTap: (ctx) {
          Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (context) => const ProductFormPage(),
            ),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Football Shop',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section - Clean
            Text(
              'Halo, $nama!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'NPM: $npm • Kelas: $kelas',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 28),

            // Menu Section - Compact
            const Text(
              'Mulai Jelajah',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 14),

            // Menu Grid - 2 columns only
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.15,
              children: items.map((item) => ItemCard(item: item)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;
  final void Function(BuildContext context) onTap;

  ItemHomepage({
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => item.onTap(context),
        child: Container(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(height: 10),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}