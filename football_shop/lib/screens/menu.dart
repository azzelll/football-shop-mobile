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
        title: const Text('Football Shop'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'Halo, $nama!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Selamat datang kembali di Football Shop.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6B7280),
                  ),
            ),
            const SizedBox(height: 24),

            // Info Cards
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                final cards = [
                  InfoCard(title: 'NPM', content: npm),
                  InfoCard(title: 'Name', content: nama),
                  InfoCard(title: 'Class', content: kelas),
                ];

                if (isWide) {
                  return Row(
                    children: List.generate(
                      cards.length,
                      (index) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: index == cards.length - 1 ? 0 : 16,
                          ),
                          child: cards[index],
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: cards
                      .map(
                        (card) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: card,
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 32),

            // Menu Section
            Text(
              'Mulai Jelajah',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
            ),
            const SizedBox(height: 16),

            // Menu Grid
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: items.map((item) => ItemCard(item: item)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                color: Colors.white,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}