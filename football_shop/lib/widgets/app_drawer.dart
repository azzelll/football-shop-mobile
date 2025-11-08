import 'package:flutter/material.dart';

class AppNavigationDrawer extends StatelessWidget {
  final bool isOnHome;
  final VoidCallback onHomeSelected;
  final VoidCallback onAddProductSelected;

  const AppNavigationDrawer({
    super.key,
    required this.isOnHome,
    required this.onHomeSelected,
    required this.onAddProductSelected,
  });

  void _handleTap(BuildContext context, bool navigate, VoidCallback action) {
    Navigator.pop(context); // close the drawer first
    if (navigate) {
      // postpone navigation until after the drawer finishes closing
      Future.microtask(action);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onPrimary = colorScheme.onPrimary;

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'Football Shop',
                    style:
                        theme.textTheme.headlineSmall?.copyWith(color: onPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Belanja perlengkapan bola favoritmu',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Halaman Utama'),
              selected: isOnHome,
              onTap: () => _handleTap(context, !isOnHome, onHomeSelected),
            ),
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text('Tambah Produk'),
              selected: !isOnHome,
              onTap: () => _handleTap(context, isOnHome, onAddProductSelected),
            ),
            
          ],
        ),
      ),
    );
  }
}
