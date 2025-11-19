import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:football_shop/config.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:football_shop/screens/menu.dart';
import 'package:football_shop/widgets/left_drawer.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController(text: '0');
  final _stockController = TextEditingController();
  final _ratingController = TextEditingController(text: '0');
  final _sizesController = TextEditingController();
  final _thumbnailController = TextEditingController();
  
  String _category = "shoes";
  bool _isFeatured = false;
  bool _isLoading = false;

  final List<String> _categories = const [
    'shoes',
    'clothing',
    'gear',
    'accessories',
    'lifestyle',
  ];

  final Map<String, String> _categoryLabels = const {
    'shoes': 'Sepatu',
    'clothing': 'Pakaian',
    'gear': 'Gear',
    'accessories': 'Aksesoris',
    'lifestyle': 'Lifestyle',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _stockController.dispose();
    _ratingController.dispose();
    _sizesController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text('Please fill all fields correctly', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(12),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final request = context.read<CookieRequest>();

    try {
      final productData = {
        'name': _nameController.text.trim(),
        'brand': _brandController.text.trim(),
        'category': _category,
        'description': _descriptionController.text.trim(),
        'price': _priceController.text.trim(),
        'discount': _discountController.text.trim(),
        'stock': _stockController.text.trim(),
        'rating': _ratingController.text.trim(),
        'sizes': _sizesController.text.trim(),
        'thumbnail': _thumbnailController.text.trim(),
        'is_featured': _isFeatured,
      };
      
      final response = await request.postJson(
        "$baseUrl/flutter/create/",
        jsonEncode(productData),
      );

      if (mounted) {
        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      response['message'] ?? 'Product saved!',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF16A34A),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              margin: const EdgeInsets.all(12),
              duration: const Duration(seconds: 2),
            ),
          );
          
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          }
        } else {
          throw Exception(response['message'] ?? 'Failed to save product');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text('Error: ${e.toString()}', style: const TextStyle(fontSize: 13))),
              ],
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(12),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product', style: TextStyle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: const LeftDrawer(),
      backgroundColor: const Color(0xFFF9FAFB),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card - Compact
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white, size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Fill in all product details carefully',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Basic Information
              _buildSectionHeader('Basic Information'),
              _buildTextField(
                controller: _nameController,
                label: 'Product Name',
                hint: 'e.g., Predator Elite FG',
                icon: Icons.sports_soccer,
                validator: (v) => v == null || v.trim().isEmpty ? "Required" : v.trim().length < 3 ? "Min 3 chars" : null,
              ),
              _buildTextField(
                controller: _brandController,
                label: 'Brand',
                hint: 'e.g., Adidas, Nike',
                icon: Icons.branding_watermark,
                validator: (v) => v == null || v.trim().isEmpty ? "Required" : null,
              ),
              _buildDropdown(),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe the product...',
                icon: Icons.description,
                maxLines: 3,
                validator: (v) => v == null || v.trim().isEmpty ? "Required" : v.trim().length < 10 ? "Min 10 chars" : null,
              ),

              const SizedBox(height: 16),
              _buildSectionHeader('Pricing & Stock'),
              
              // Price & Discount Row
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildTextField(
                      controller: _priceController,
                      label: 'Price',
                      hint: '500000',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Required";
                        final p = int.tryParse(v);
                        return p == null || p <= 0 ? "Invalid" : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                      controller: _discountController,
                      label: 'Discount',
                      hint: '0',
                      icon: Icons.percent,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Required";
                        final d = double.tryParse(v);
                        return d == null || d < 0 || d > 100 ? "0-100" : null;
                      },
                    ),
                  ),
                ],
              ),

              // Stock & Rating Row
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _stockController,
                      label: 'Stock',
                      hint: '10',
                      icon: Icons.inventory,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Required";
                        final s = int.tryParse(v);
                        return s == null || s < 0 ? "Invalid" : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      controller: _ratingController,
                      label: 'Rating',
                      hint: '0',
                      icon: Icons.star,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Required";
                        final r = double.tryParse(v);
                        return r == null || r < 0 || r > 5 ? "0-5" : null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _buildSectionHeader('Product Details'),
              
              _buildTextField(
                controller: _sizesController,
                label: 'Sizes',
                hint: '39, 40, 41 or S, M, L',
                icon: Icons.straighten,
                helperText: 'Separate with commas',
                validator: (v) => v == null || v.trim().isEmpty ? "Required" : null,
              ),
              _buildTextField(
                controller: _thumbnailController,
                label: 'Image URL',
                hint: 'https://example.com/image.jpg',
                icon: Icons.image,
                keyboardType: TextInputType.url,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Required";
                  return !Uri.tryParse(v)!.hasScheme ? "Invalid URL" : null;
                },
              ),

              // Featured Checkbox - Compact
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: CheckboxListTile(
                  title: const Text(
                    'Mark as Featured Product',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Featured products appear first',
                    style: TextStyle(fontSize: 11),
                  ),
                  value: _isFeatured,
                  onChanged: (value) {
                    setState(() => _isFeatured = value ?? false);
                  },
                  activeColor: const Color(0xFF16A34A),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  secondary: Icon(
                    Icons.star,
                    color: _isFeatured ? const Color(0xFF16A34A) : const Color(0xFF9CA3AF),
                    size: 22,
                  ),
                  dense: true,
                ),
              ),

              const SizedBox(height: 6),

              // Save Button - Compact
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _saveProduct,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.save, size: 20),
                  label: Text(
                    _isLoading ? 'Saving...' : 'Save Product',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF111827),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? helperText,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
              children: const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFFDC2626)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              helperText: helperText,
              helperStyle: const TextStyle(fontSize: 11),
              prefixIcon: Icon(icon, size: 18),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            style: const TextStyle(fontSize: 13),
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              text: 'Category',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
              children: [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFFDC2626)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: 'Select category',
              hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              prefixIcon: const Icon(Icons.category, size: 18),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            value: _category,
            style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
            items: _categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(_categoryLabels[category] ?? category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() => _category = newValue);
              }
            },
            validator: (value) => value == null || value.isEmpty ? "Required" : null,
          ),
        ],
      ),
    );
  }
}