import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ProductFilterDrawer extends StatefulWidget {
  const ProductFilterDrawer({super.key});

  @override
  State<ProductFilterDrawer> createState() => _ProductFilterDrawerState();
}

class _ProductFilterDrawerState extends State<ProductFilterDrawer> {
  RangeValues _currentPriceRange = const RangeValues(50, 250);
  String _selectedSize = 'M';
  String _selectedColor = 'Sage';

  final List<String> _sizes = ['S', 'M', 'L', 'XL', 'XXL'];
  final List<Map<String, dynamic>> _colors = [
    {'name': 'Rose', 'color': const Color(0xFFE8C4C4)},
    {'name': 'Sage', 'color': const Color(0xFFBCC5B5)},
    {'name': 'Cream', 'color': const Color(0xFFF5F0E6)},
    {'name': 'Sky', 'color': const Color(0xFFC8D9EB)},
    {'name': 'Noir', 'color': const Color(0xFF2A2A2A)},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 48,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40), // Spacer
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textUser,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Price Range',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textUser,
                        ),
                      ),
                      Text(
                        '₹${_currentPriceRange.start.round()} - ₹${_currentPriceRange.end.round()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryUser,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  RangeSlider(
                    values: _currentPriceRange,
                    min: 0,
                    max: 500,
                    activeColor: AppColors.primaryUser,
                    inactiveColor: Colors.grey[200],
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentPriceRange = values;
                      });
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹0',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '₹500+',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 32),

                  // Size Selection
                  const Text(
                    'Select Size',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textUser,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: _sizes.map((size) {
                      final isSelected = _selectedSize == size;
                      final isDisabled = size == 'XXL'; // Mock disabled state
                      return GestureDetector(
                        onTap: isDisabled
                            ? null
                            : () => setState(() => _selectedSize = size),
                        child: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryUser
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryUser
                                  : Colors.grey[300]!,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primaryUser.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            size,
                            style: TextStyle(
                              color: isDisabled
                                  ? Colors.grey[300]
                                  : (isSelected
                                        ? Colors.white
                                        : AppColors.textUser),
                              fontWeight: FontWeight.bold,
                              decoration: isDisabled
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 32),

                  // Color Selection
                  const Text(
                    'Colors',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textUser,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 20,
                    runSpacing: 16,
                    children: _colors.map((colorMap) {
                      final isSelected = _selectedColor == colorMap['name'];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () => setState(
                              () => _selectedColor = colorMap['name'],
                            ),
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: colorMap['color'],
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: isSelected
                                    ? Border.all(color: Colors.white, width: 2)
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            colorMap['name'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? AppColors.textUser
                                  : AppColors.textMuted,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[100]!)),
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    // Reset Logic
                    setState(() {
                      _currentPriceRange = const RangeValues(0, 500);
                      _selectedSize = 'M';
                      _selectedColor = 'Sage';
                    });
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryUser,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Apply Filters',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '3',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
