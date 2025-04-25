import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;
  final int quantity;

  const CartItem({
    required this.product,
    required this.onRemove,
    required this.onQuantityChanged,
    this.quantity = 1,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final subtotal = product.price * quantity;
    
    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      onDismissed: (_) => onRemove(),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image with fixed size
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
                  ),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.broken_image,
                      size: 40,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12), // Reduced spacing
              
              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14, // Reduced font size
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '₹${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14, // Reduced font size
                      ),
                    ),
                    SizedBox(height: 8),
                    
                    // Quantity selector and subtotal in a responsive layout
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // If screen width is limited, stack the elements vertically
                        if (constraints.maxWidth < 200) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildQuantitySelector(colorScheme),
                              SizedBox(height: 8),
                              Text(
                                'Total: ₹${subtotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Otherwise, use a row with flexible spacing
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildQuantitySelector(colorScheme),
                              Flexible(
                                child: Text(
                                  'Total: ₹${subtotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantitySelector(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Important to prevent stretching
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            onPressed: () {
              if (quantity > 1) {
                onQuantityChanged(quantity - 1);
              }
            },
            colorScheme: colorScheme,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8), // Reduced padding
            child: Text(
              quantity.toString(),
              style: TextStyle(
                fontSize: 13, // Reduced font size
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add,
            onPressed: () => onQuantityChanged(quantity + 1),
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
    required ColorScheme colorScheme,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(4), // Reduced padding
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 14, // Reduced icon size
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}