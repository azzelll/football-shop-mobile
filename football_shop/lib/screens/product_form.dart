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
  
  String _category = "shoes"; // Default value
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
    'gear': 'Gear (Bola, Pelindung, Alat Latihan)',
    'accessories': 'Aksesoris',
    'lifestyle': 'Lifestyle / Merchandise',
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
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text('Please fill all required fields correctly'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final request = context.read<CookieRequest>();

    try {
      // Prepare data
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

      // PENTING: Sesuaikan URL ini dengan environment Anda
      // - Android Emulator: http://10.0.2.2:8000
      // - iOS Simulator: http://127.0.0.1:8000  
      // - Real Device: http://YOUR_COMPUTER_IP:8000
      // - Production: https://your-domain.com
      
      final response = await request.postJson(
        "$baseUrl/flutter/create/",  // ← GANTI SESUAI ENVIRONMENT
        jsonEncode(productData),
      );

      if (mounted) {
        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(response['message'] ?? 'Product saved!'),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF16A34A),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
          
          // Navigate back to home with a slight delay
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
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Error: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 4),
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
        title: const Text('Add Product'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Quick save button in AppBar
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.save, color: Colors.white),
              onPressed: _saveProduct,
              tooltip: 'Save Product',
            ),
        ],
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
              // Header Info Card
              _buildInfoCard(),
              const SizedBox(height: 16),

              // Basic Information Section
              _buildSectionHeader('Basic Information'),
              _buildTextField(
                controller: _nameController,
                label: 'Product Name',
                hint: 'e.g., Predator Elite FG',
                icon: Icons.sports_soccer,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Product name is required";
                  }
                  if (value.trim().length < 3) {
                    return "Minimum 3 characters";
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _brandController,
                label: 'Brand',
                hint: 'e.g., Adidas, Nike, Puma',
                icon: Icons.branding_watermark,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Brand is required";
                  }
                  return null;
                },
              ),
              _buildDropdown(),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe the product features...',
                icon: Icons.description,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Description is required";
                  }
                  if (value.trim().length < 10) {
                    return "Minimum 10 characters";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        }
                        final price = int.tryParse(value);
                        if (price == null || price <= 0) {
                          return "Invalid";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                      controller: _discountController,
                      label: 'Discount',
                      hint: '0',
                      icon: Icons.percent,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        }
                        final discount = double.tryParse(value);
                        if (discount == null || discount < 0 || discount > 100) {
                          return "0-100";
                        }
                        return null;
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        }
                        final stock = int.tryParse(value);
                        if (stock == null || stock < 0) {
                          return "Invalid";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _ratingController,
                      label: 'Rating',
                      hint: '0',
                      icon: Icons.star,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        }
                        final rating = double.tryParse(value);
                        if (rating == null || rating < 0 || rating > 5) {
                          return "0-5";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _buildSectionHeader('Product Details'),
              
              _buildTextField(
                controller: _sizesController,
                label: 'Sizes',
                hint: '39, 40, 41 or S, M, L',
                icon: Icons.straighten,
                helperText: 'Separate with commas',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Sizes are required";
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _thumbnailController,
                label: 'Image URL',
                hint: 'https://example.com/image.jpg',
                icon: Icons.image,
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Image URL is required";
                  }
                  if (!Uri.tryParse(value)!.hasScheme) {
                    return "Invalid URL format";
                  }
                  return null;
                },
              ),

              // Featured Checkbox
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: CheckboxListTile(
                  title: const Text(
                    'Mark as Featured Product',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Featured products appear first',
                    style: TextStyle(fontSize: 12),
                  ),
                  value: _isFeatured,
                  onChanged: (value) {
                    setState(() => _isFeatured = value ?? false);
                  },
                  activeColor: const Color(0xFF16A34A),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isFeatured
                          ? const Color(0xFFD1FAE5)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.star,
                      color: _isFeatured
                          ? const Color(0xFF16A34A)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _saveProduct,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.save, size: 24),
                  label: Text(
                    _isLoading ? 'Saving Product...' : 'Save Product',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.white, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Fill in all product details carefully',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
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
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 14,
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
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              helperText: helperText,
              helperStyle: const TextStyle(fontSize: 12),
              prefixIcon: Icon(icon, size: 20),
              filled: true,
              fillColor: Colors.white,
            ),
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
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              text: 'Category',
              style: TextStyle(
                fontSize: 14,
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
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: 'Select category',
              prefixIcon: const Icon(Icons.category, size: 20),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF16A34A),
                  width: 2,
                ),
              ),
            ),
            value: _category,
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Category is required";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
