import 'package:flutter/material.dart';
import 'package:football_shop/widgets/app_drawer.dart';
import 'package:football_shop/widgets/product_summary_dialog.dart';

class AddProductPage extends StatefulWidget {
  static const routeName = '/add-product';

  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController(text: '0');
  final _stockController = TextEditingController();
  final _ratingController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sizesController = TextEditingController();
  final _thumbnailController = TextEditingController();
  final List<String> _categories = const [
    'Sepatu',
    'Pakaian',
    'Gear (Bola, Pelindung, Alat Latihan)',
    'Aksesoris',
    'Lifestyle / Merchandise',
  ];

  String? _selectedCategory;
  bool _isFeatured = false;

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _stockController.dispose();
    _ratingController.dispose();
    _descriptionController.dispose();
    _sizesController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final int price = int.parse(_priceController.text.trim());
    final double discount = double.parse(_discountController.text.trim());
    final int stock = int.parse(_stockController.text.trim());
    final double rating = double.parse(_ratingController.text.trim());
    final List<String> parsedSizes = _sizesController.text
        .split(',')
        .map((size) => size.trim())
        .where((size) => size.isNotEmpty)
        .toList();
    final productData = ProductSummaryData(
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      category: _selectedCategory!,
      description: _descriptionController.text.trim(),
      price: price,
      discount: discount,
      stock: stock,
      rating: rating,
      sizes: parsedSizes,
      thumbnailUrl: _thumbnailController.text.trim(),
      isFeatured: _isFeatured,
    );

    showProductSummaryDialog(context, productData);

    _formKey.currentState!.reset();
    setState(() {
      _selectedCategory = null;
      _isFeatured = false;
    });
    _nameController.clear();
    _brandController.clear();
    _priceController.clear();
    _discountController.text = '0';
    _stockController.clear();
    _ratingController.clear();
    _descriptionController.clear();
    _sizesController.clear();
    _thumbnailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      drawer: AppNavigationDrawer(
        isOnHome: false,
        onHomeSelected: () => Navigator.pushReplacementNamed(context, '/'),
        onAddProductSelected: () {},
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail Produk',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    hintText: 'e.g., Predator Elite FG',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama produk wajib diisi';
                    }
                    if (value.trim().length < 3) {
                      return 'Nama produk minimal 3 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(
                    labelText: 'Brand',
                    hintText: 'e.g., Adidas, Nike, Puma',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Brand wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                  value: _selectedCategory,
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() {
                    _selectedCategory = value;
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kategori wajib dipilih';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText:
                        'Describe the product features, materials, technology, etc.',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi wajib diisi';
                    }
                    if (value.trim().length < 10) {
                      return 'Deskripsi minimal 10 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price (Rp)',
                    prefixText: 'Rp ',
                    hintText: '500000',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Harga wajib diisi';
                    }
                    final numeric = int.tryParse(value.trim());
                    if (numeric == null) {
                      return 'Harga harus berupa angka bulat';
                    }
                    if (numeric <= 0) {
                      return 'Harga harus lebih besar dari 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _discountController,
                  decoration: const InputDecoration(
                    labelText: 'Discount (%)',
                    hintText: '0',
                    helperText: 'Enter discount percentage (0-100)',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Diskon wajib diisi';
                    }
                    final discount = double.tryParse(value.trim());
                    if (discount == null) {
                      return 'Diskon harus berupa angka';
                    }
                    if (discount < 0 || discount > 100) {
                      return 'Diskon harus di antara 0 hingga 100';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    hintText: '10',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Stok wajib diisi';
                    }
                    final stock = int.tryParse(value.trim());
                    if (stock == null) {
                      return 'Stok harus berupa angka bulat';
                    }
                    if (stock < 0) {
                      return 'Stok tidak boleh negatif';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ratingController,
                  decoration: const InputDecoration(
                    labelText: 'Rating (0-5)',
                    hintText: '4.5',
                    helperText: 'Enter rating from 0 to 5',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Rating wajib diisi';
                    }
                    final rating = double.tryParse(value.trim());
                    if (rating == null) {
                      return 'Rating harus berupa angka';
                    }
                    if (rating < 0 || rating > 5) {
                      return 'Rating harus di antara 0 hingga 5';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _sizesController,
                  decoration: const InputDecoration(
                    labelText: 'Available Sizes',
                    hintText: 'e.g., 39, 40, 41, 42 or S, M, L, XL',
                    helperText: 'Separate multiple sizes with commas',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Daftar ukuran wajib diisi';
                    }
                    final hasSize = value
                        .split(',')
                        .any((size) => size.trim().isNotEmpty);
                    if (!hasSize) {
                      return 'Masukkan minimal satu ukuran';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _thumbnailController,
                  decoration: const InputDecoration(
                    labelText: 'Thumbnail Image URL',
                    hintText: 'https://example.com/image.jpg',
                    helperText: 'Enter a valid image URL',
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'URL thumbnail wajib diisi';
                    }
                    final parsed = Uri.tryParse(value.trim());
                    final isValidUrl = parsed != null &&
                        (parsed.scheme == 'http' || parsed.scheme == 'https') &&
                        parsed.host.isNotEmpty;
                    if (!isValidUrl) {
                      return 'Masukkan URL valid (http/https)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Mark as Featured Product'),
                  value: _isFeatured,
                  onChanged: (value) => setState(() {
                    _isFeatured = value ?? false;
                  }),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _handleSubmit,
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
