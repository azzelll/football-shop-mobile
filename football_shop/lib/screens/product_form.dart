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
  String _name = "";
  String _brand = "";
  String _category = "";
  String _description = "";
  int _price = 0;
  double _discount = 0;
  int _stock = 0;
  double _rating = 0;
  String _sizes = "";
  String _thumbnail = "";
  bool _isFeatured = false;

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
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

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
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Detail Produk',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 24),

                // Product Name
                _buildLabel('Product Name'),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'e.g., Predator Elite FG',
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _name = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Nama produk tidak boleh kosong!";
                    }
                    if (value.length < 3) {
                      return "Nama produk minimal 3 karakter!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Brand
                _buildLabel('Brand'),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'e.g., Adidas, Nike, Puma',
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _brand = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Brand tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Category
                _buildLabel('Category'),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    hintText: 'Select a category',
                  ),
                  initialValue: _category.isEmpty ? null : _category,
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(_categoryLabels[category] ?? category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Kategori tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Description
                _buildLabel('Description'),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Describe the product features, materials, technology, etc.',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Deskripsi tidak boleh kosong!";
                    }
                    if (value.length < 10) {
                      return "Deskripsi minimal 10 karakter!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Price and Discount Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Price (Rp)'),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: '500000',
                              prefixText: 'Rp ',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (String? value) {
                              setState(() {
                                _price = int.tryParse(value!) ?? 0;
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Harga tidak boleh kosong!";
                              }
                              if (int.tryParse(value) == null) {
                                return "Harga harus berupa angka!";
                              }
                              if (int.parse(value) <= 0) {
                                return "Harga harus lebih dari 0!";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Discount (%)'),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: '0',
                            ),
                            keyboardType: TextInputType.number,
                            initialValue: '0',
                            onChanged: (String? value) {
                              setState(() {
                                _discount = double.tryParse(value!) ?? 0;
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Diskon tidak boleh kosong!";
                              }
                              final discount = double.tryParse(value);
                              if (discount == null) {
                                return "Diskon harus berupa angka!";
                              }
                              if (discount < 0 || discount > 100) {
                                return "Diskon 0-100!";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Stock and Rating Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Stock'),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: '10',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (String? value) {
                              setState(() {
                                _stock = int.tryParse(value!) ?? 0;
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Stok tidak boleh kosong!";
                              }
                              if (int.tryParse(value) == null) {
                                return "Stok harus berupa angka!";
                              }
                              if (int.parse(value) < 0) {
                                return "Stok tidak boleh negatif!";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Rating (0-5)'),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: '4.5',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (String? value) {
                              setState(() {
                                _rating = double.tryParse(value!) ?? 0;
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Rating tidak boleh kosong!";
                              }
                              final rating = double.tryParse(value);
                              if (rating == null) {
                                return "Rating harus berupa angka!";
                              }
                              if (rating < 0 || rating > 5) {
                                return "Rating 0-5!";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Available Sizes
                _buildLabel('Available Sizes'),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'e.g., 39, 40, 41, 42 or S, M, L, XL',
                    helperText: 'Separate multiple sizes with commas',
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _sizes = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Ukuran tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Thumbnail URL
                _buildLabel('Thumbnail Image URL'),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'https://example.com/image.jpg',
                    helperText: 'Enter a valid image URL',
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _thumbnail = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "URL thumbnail tidak boleh kosong!";
                    }
                    if (!Uri.tryParse(value)!.hasScheme) {
                      return "URL tidak valid!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Is Featured Checkbox
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Mark as Featured Product',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                  value: _isFeatured,
                  onChanged: (bool? value) {
                    setState(() {
                      _isFeatured = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: const Color(0xFF16A34A),
                ),
                const SizedBox(height: 32),

                // Submit Button
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Save Product'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final response = await request.postJson(
                              "http://localhost:8000/create-flutter/",
                              jsonEncode(<String, String>{
                                'name': _name,
                                'brand': _brand,
                                'category': _category,
                                'description': _description,
                                'price': _price.toString(),
                                'discount': _discount.toString(),
                                'stock': _stock.toString(),
                                'rating': _rating.toString(),
                                'sizes': _sizes,
                                'thumbnail': _thumbnail,
                                'is_featured': _isFeatured.toString(),
                              }),
                            );
                            if (context.mounted) {
                              if (response['status'] == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Produk berhasil disimpan!"),
                                    backgroundColor: Color(0xFF16A34A),
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyHomePage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Terdapat kesalahan, silakan coba lagi."),
                                    backgroundColor: Color(0xFFDC2626),
                                  ),
                                );
                              }
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.cancel),
                        label: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(
                color: Color(0xFFDC2626),
              ),
            ),
          ],
        ),
      ),
    );
  }
}