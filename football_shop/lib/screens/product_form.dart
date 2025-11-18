import 'dart:convert';
import 'package:flutter/material.dart';
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
  
  String _category = "";
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
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final request = context.read<CookieRequest>();

    try {
      final response = await request.postJson(
        "http://127.0.0.1:8000/create-flutter/",
        jsonEncode({
          'name': _nameController.text,
          'brand': _brandController.text,
          'category': _category,
          'description': _descriptionController.text,
          'price': _priceController.text,
          'discount': _discountController.text,
          'stock': _stockController.text,
          'rating': _ratingController.text,
          'sizes': _sizesController.text,
          'thumbnail': _thumbnailController.text,
          'is_featured': _isFeatured.toString(),
        }),
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
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
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
                Expanded(child: Text('Error: ${e.toString()}')),
              ],
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
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
      ),
      drawer: const LeftDrawer(),
      backgroundColor: const Color(0xFFF9FAFB),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Product Name
              _buildTextField(
                controller: _nameController,
                label: 'Product Name',
                hint: 'e.g., Predator Elite FG',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Product name is required";
                  }
                  if (value.length < 3) {
                    return "Minimum 3 characters";
                  }
                  return null;
                },
              ),

              // Brand
              _buildTextField(
                controller: _brandController,
                label: 'Brand',
                hint: 'e.g., Adidas, Nike, Puma',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Brand is required";
                  }
                  return null;
                },
              ),

              // Category
              _buildDropdown(),

              // Description
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe the product...',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Description is required";
                  }
                  if (value.length < 10) {
                    return "Minimum 10 characters";
                  }
                  return null;
                },
              ),

              // Price & Discount Row
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _priceController,
                      label: 'Price (Rp)',
                      hint: '500000',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return "Invalid price";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _discountController,
                      label: 'Discount (%)',
                      hint: '0',
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
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        }
                        if (int.tryParse(value) == null || int.parse(value) < 0) {
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
                      label: 'Rating (0-5)',
                      hint: '0',
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

              // Sizes
              _buildTextField(
                controller: _sizesController,
                label: 'Sizes',
                hint: '39, 40, 41 or S, M, L',
                helperText: 'Separate with commas',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Sizes are required";
                  }
                  return null;
                },
              ),

              // Thumbnail URL
              _buildTextField(
                controller: _thumbnailController,
                label: 'Image URL',
                hint: 'https://example.com/image.jpg',
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Image URL is required";
                  }
                  if (!Uri.tryParse(value)!.hasScheme) {
                    return "Invalid URL";
                  }
                  return null;
                },
              ),

              // Featured Checkbox
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: CheckboxListTile(
                  title: const Text(
                    'Mark as Featured',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  value: _isFeatured,
                  onChanged: (value) {
                    setState(() => _isFeatured = value ?? false);
                  },
                  activeColor: const Color(0xFF16A34A),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
              ),

              const SizedBox(height: 8),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _saveProduct,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isLoading ? 'Saving...' : 'Save Product'),
                  style: FilledButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
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
            decoration: const InputDecoration(
              hintText: 'Select category',
            ),
            value: _category.isEmpty ? null : _category,
            items: _categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(_categoryLabels[category] ?? category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() => _category = newValue!);
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