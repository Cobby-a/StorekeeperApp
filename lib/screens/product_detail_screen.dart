// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:intl/intl.dart';
// import 'dart:io';
// import '../models/product.dart';
// import '../providers/product_provider.dart';
// import 'add_edit_product_screen.dart';

// class ProductDetailScreen extends StatelessWidget {
//   final Product product;

//   const ProductDetailScreen({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     final currencyFormatter = NumberFormat.currency(symbol: '₵', decimalDigits: 2);
//     final dateFormatter = DateFormat('MMM dd, yyyy');

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Product Details'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AddEditProductScreen(product: product),
//                 ),
//               );
//             },
//             tooltip: 'Edit product',
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () => _showDeleteDialog(context),
//             tooltip: 'Delete product',
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Product Image
//             _buildProductImage(context).animate().fadeIn(),
            
//             // Product Information
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Product Name
//                   Text(
//                     product.name,
//                     style: Theme.of(context).textTheme.displayMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2, end: 0),
//                   const SizedBox(height: 24),
                  
//                   // Info Cards
//                   _buildInfoCard(
//                     context,
//                     icon: Icons.inventory,
//                     label: 'Quantity in Stock',
//                     value: product.quantity.toString(),
//                     color: Colors.blue,
//                   ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2, end: 0),
//                   const SizedBox(height: 12),
                  
//                   _buildInfoCard(
//                     context,
//                     icon: Icons.attach_money,
//                     label: 'Price per Unit',
//                     value: currencyFormatter.format(product.price),
//                     color: Colors.green,
//                   ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.2, end: 0),
//                   const SizedBox(height: 12),
                  
//                   _buildInfoCard(
//                     context,
//                     icon: Icons.calculate,
//                     label: 'Total Value',
//                     value: currencyFormatter.format(product.price * product.quantity),
//                     color: Colors.orange,
//                   ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.2, end: 0),
//                   const SizedBox(height: 24),
                  
//                   Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Additional Information',
//                             style: Theme.of(context).textTheme.titleLarge,
//                           ),
//                           const SizedBox(height: 12),
//                           _buildTimestampRow(
//                             context,
//                             icon: Icons.add_circle_outline,
//                             label: 'Created',
//                             value: dateFormatter.format(product.createdAt),
//                           ),
//                           const SizedBox(height: 8),
//                           _buildTimestampRow(
//                             context,
//                             icon: Icons.update,
//                             label: 'Last Updated',
//                             value: dateFormatter.format(product.updatedAt),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ).animate().fadeIn(delay: 500.ms).scale(),
//                   const SizedBox(height: 24),
                  
//                   // Action Buttons
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => AddEditProductScreen(product: product),
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.edit),
//                           label: const Text('Edit'),
//                           style: OutlinedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () => _showDeleteDialog(context),
//                           icon: const Icon(Icons.delete),
//                           label: const Text('Delete'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProductImage(BuildContext context) {
//     return Hero(
//       tag: 'product_${product.id}',
//       child: Container(
//         height: 300,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.surfaceContainerHighest,
//         ),
//         child: product.imagePath != null
//             ? Image.file(
//                 File(product.imagePath!),
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return _buildPlaceholderImage(context);
//                 },
//               )
//             : _buildPlaceholderImage(context),
//       ),
//     );
//   }

//   Widget _buildPlaceholderImage(BuildContext context) {
//     return Center(
//       child: Icon(
//         Icons.inventory_2,
//         size: 100,
//         color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
//       ),
//     );
//   }

//   Widget _buildInfoCard(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: color.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: color, size: 28),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     value,
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: color,
//                         ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimestampRow(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 20,
//           color: Theme.of(context).colorScheme.primary,
//         ),
//         const SizedBox(width: 12),
//         Text(
//           label,
//           style: Theme.of(context).textTheme.bodyMedium,
//         ),
//         const Spacer(),
//         Text(
//           value,
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 fontWeight: FontWeight.w600,
//               ),
//         ),
//       ],
//     );
//   }

//   void _showDeleteDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Product'),
//         content: Text('Are you sure you want to delete "${product.name}"? This action cannot be undone.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final provider = context.read<ProductProvider>();
//               final success = await provider.deleteProduct(product.id!);
              
//               if (context.mounted) {
//                 Navigator.pop(context);
//                 Navigator.pop(context);
                
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(
//                       success ? 'Product deleted successfully!' : 'Failed to delete product',
//                     ),
//                     backgroundColor: success ? Colors.green : Colors.red,
//                   ),
//                 );
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/product.dart';
import '../providers/product_provider.dart';
import 'add_edit_product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Product currentProduct;

  @override
  void initState() {
    super.initState();
    currentProduct = widget.product;
  }

  void _refreshProduct() {
    final productProvider = context.read<ProductProvider>();
    final updatedProduct = productProvider.getProductById(currentProduct.id!);
    if (updatedProduct != null) {
      setState(() {
        currentProduct = updatedProduct;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '₵', decimalDigits: 2);
    final dateFormatter = DateFormat('MMM dd, yyyy');
    final timeFormatter = DateFormat('HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditProductScreen(product: currentProduct),
                ),
              );
              _refreshProduct();
            },
            tooltip: 'Edit product',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
            tooltip: 'Delete product',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProductImage(context).animate().fadeIn(),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentProduct.name,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2, end: 0),
                  const SizedBox(height: 24),
                  
                  _buildInfoCard(
                    context,
                    icon: Icons.inventory,
                    label: 'Quantity in Stock',
                    value: currentProduct.quantity.toString(),
                    color: Colors.blue,
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2, end: 0),
                  const SizedBox(height: 12),
                  
                  _buildInfoCard(
                    context,
                    icon: Icons.money,
                    label: 'Price per Unit',
                    value: currencyFormatter.format(currentProduct.price),
                    color: Colors.green,
                  ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.2, end: 0),
                  const SizedBox(height: 12),
                  
                  _buildInfoCard(
                    context,
                    icon: Icons.calculate,
                    label: 'Total Value',
                    value: currencyFormatter.format(currentProduct.price * currentProduct.quantity),
                    color: Colors.orange,
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.2, end: 0),
                  const SizedBox(height: 24),
                  
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Additional Information',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          _buildTimestampRow(
                            context,
                            icon: Icons.add_circle_outline,
                            label: 'Created',
                            date: dateFormatter.format(currentProduct.createdAt),
                            time: timeFormatter.format(currentProduct.createdAt),
                          ),
                          const SizedBox(height: 8),
                          _buildTimestampRow(
                            context,
                            icon: Icons.update,
                            label: 'Last Updated',
                            date: dateFormatter.format(currentProduct.updatedAt),
                            time: timeFormatter.format(currentProduct.updatedAt),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms).scale(),
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditProductScreen(product: currentProduct),
                              ),
                            );
                            _refreshProduct();
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showDeleteDialog(context),
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Hero(
      tag: 'product_${currentProduct.id}',
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: currentProduct.imagePath != null
            ? Image.file(
                File(currentProduct.imagePath!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage(context);
                },
              )
            : _buildPlaceholderImage(context),
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Center(
      child: Icon(
        Icons.inventory_2,
        size: 100,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimestampRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String date,
    required String time,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        Row(
          children: [
            Text(
              date,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(width: 6),
            Text(
              time,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${currentProduct.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final provider = context.read<ProductProvider>();
              final success = await provider.deleteProduct(currentProduct.id!);
              
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Product deleted successfully!' : 'Failed to delete product',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}