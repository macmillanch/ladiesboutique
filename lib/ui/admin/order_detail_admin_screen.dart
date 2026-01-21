import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/order_model.dart';
import '../../data/services/database_service.dart';
import '../../data/services/storage_service.dart';

class OrderDetailAdminScreen extends StatefulWidget {
  final OrderModel order;
  const OrderDetailAdminScreen({super.key, required this.order});

  @override
  State<OrderDetailAdminScreen> createState() => _OrderDetailAdminScreenState();
}

class _OrderDetailAdminScreenState extends State<OrderDetailAdminScreen> {
  bool _isLoading = false;

  Future<void> _markPacked() async {
    setState(() => _isLoading = true);
    await context.read<DatabaseService>().markOrderPacked(widget.order.id);
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
    }
  }

  Future<void> _markShipped() async {
    final courierCtrl = TextEditingController(
      text: 'India Post – Dak Seva Jan Seva',
    );
    final trackingCtrl = TextEditingController();
    String? slipUrl;

    // ignore: use_build_context_synchronously
    await showDialog(
      context: context,
      builder: (dialogContext) {
        bool localLoading = false;
        return StatefulBuilder(
          builder: (sbContext, setStateSB) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Mark Shipped',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: courierCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Courier Name',
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: trackingCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Tracking ID',
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        setStateSB(() => localLoading = true);
                        final picker = ImagePicker();
                        final image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (image != null) {
                          try {
                            // ignore: use_build_context_synchronously
                            final url = await StorageService().uploadImage(
                              image,
                              'tracking_slips',
                            );
                            setStateSB(() {
                              slipUrl = url;
                              localLoading = false;
                            });
                          } catch (e) {
                            setStateSB(() => localLoading = false);
                          }
                        } else {
                          setStateSB(() => localLoading = false);
                        }
                      },
                      icon: Icon(
                        slipUrl == null ? Icons.upload_file : Icons.check,
                      ),
                      label: Text(
                        slipUrl == null
                            ? 'Upload Tracking Slip'
                            : 'Slip Uploaded',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: slipUrl == null
                            ? AppColors.primaryUser
                            : Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    if (localLoading)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (trackingCtrl.text.isEmpty || slipUrl == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter Tracking ID and upload Slip',
                          ),
                        ),
                      );
                      return;
                    }
                    Navigator.pop(dialogContext); // Close dialog
                    setState(() => _isLoading = true);
                    await context.read<DatabaseService>().markOrderShipped(
                      widget.order.id,
                      courierCtrl.text,
                      trackingCtrl.text,
                      slipUrl!,
                    );
                    if (mounted) {
                      setState(() => _isLoading = false);
                      Navigator.pop(context); // Close screen
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryUser,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Confirm Shipped'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return Scaffold(
      backgroundColor: AppColors.backgroundUser,
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textUser,
          ),
        ),
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textUser),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Order Header Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: _cardDecoration(),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${order.id.substring(0, 8)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  order.orderStatus,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getStatusColor(
                                    order.orderStatus,
                                  ).withValues(alpha: 0.5),
                                ),
                              ),
                              child: Text(
                                order.orderStatus.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: _getStatusColor(order.orderStatus),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Placed on: ${order.createdAt.toString().split('.')[0]}',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Customer Info
                  const Text(
                    'CUSTOMER INFO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppColors.textMuted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 16,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              order.userPhone,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: AppColors.textMuted,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'User Address Placeholder',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Items
                  const Text(
                    'ITEMS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppColors.textMuted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: _cardDecoration(),
                    child: Column(
                      children: order.items
                          .map(
                            (e) => Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.withValues(alpha: 0.1),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                    ), // Placeholder or e.image
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${e.selectedSize} | ${e.selectedColor}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'x${e.quantity}  ₹${(e.price * e.quantity).toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Payment Info
                  const Text(
                    'PAYMENT DETAILS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppColors.textMuted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: _cardDecoration(),
                    child: Column(
                      children: [
                        _row('Payment Method', order.paymentMethod),
                        if (order.paymentMethod == 'UPI') ...[
                          const SizedBox(height: 8),
                          _row('Transaction ID', order.transactionId ?? 'N/A'),
                          const SizedBox(height: 8),
                          _row('Payment Status', order.paymentStatus),
                        ],
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '₹${order.totalAmount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.primaryUser,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Actions
                  if (order.orderStatus == 'Ordered')
                    ElevatedButton(
                      onPressed: _isLoading ? null : _markPacked,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryUser,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'MARK AS PACKED',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (order.orderStatus == 'Packed')
                    ElevatedButton(
                      onPressed: _isLoading ? null : _markShipped,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryUser,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'MARK AS SHIPPED',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Ordered':
        return Colors.blue;
      case 'Packed':
        return Colors.orange;
      case 'Shipped':
        return Colors.purple;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
