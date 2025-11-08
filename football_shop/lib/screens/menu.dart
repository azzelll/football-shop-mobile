import 'package:flutter/material.dart';
import 'package:football_shop/screens/add_product_page.dart';
import 'package:football_shop/widgets/app_drawer.dart';

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
        color: Theme.of(context).colorScheme.primary,
        onTap: (ctx) {
          ScaffoldMessenger.of(ctx)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Fitur katalog akan hadir segera!')),
            );
        },
      ),
      ItemHomepage(
        name: 'My Products',
        icon: Icons.inventory_2,
        color: Colors.green,
        onTap: (ctx) {
          ScaffoldMessenger.of(ctx)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Pantau koleksi pribadimu di sini.')),
            );
        },
      ),
      ItemHomepage(
        name: 'Create Product',
        icon: Icons.add_circle_outline,
        color: Colors.red,
        onTap: (ctx) {
          Navigator.pushNamed(ctx, AddProductPage.routeName);
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Football Shop'),
      ),
      drawer: AppNavigationDrawer(
        isOnHome: true,
        onHomeSelected: () => Navigator.pushReplacementNamed(context, '/'),
        onAddProductSelected: () =>
            Navigator.pushReplacementNamed(context, AddProductPage.routeName),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, $nama!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Selamat datang kembali di Football Shop.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
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
              Text(
                'Mulai Jelajah',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: items
                    .map(
                      (item) => ItemCard(item: item),
                    )
                    .toList(),
              ),
            ],
          ),
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge,
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
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => item.onTap(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                color: Colors.white,
                size: 42,
              ),
              const SizedBox(height: 12),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
