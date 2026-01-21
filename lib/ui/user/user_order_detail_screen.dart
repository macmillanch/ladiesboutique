import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/constants.dart';
import '../../data/models/order_model.dart';
import '../../data/services/database_service.dart';
import 'order_tracking_screen.dart';

class UserOrderDetailScreen extends StatefulWidget {
  final OrderModel order;
  const UserOrderDetailScreen({super.key, required this.order});

  @override
  State<UserOrderDetailScreen> createState() => _UserOrderDetailScreenState();
}

class _UserOrderDetailScreenState extends State<UserOrderDetailScreen> {
  bool _isLoading = false;

  Future<void> _confirmDelivery() async {
    setState(() => _isLoading = true);
    try {
      await context
          .read<DatabaseService>()
          .confirmDelivery(widget.order.id)
          .timeout(const Duration(seconds: 10));
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    // Status Logic
    List<String> steps = ['Ordered', 'Packed', 'Shipped', 'Delivered'];
    int currentStep = steps.indexOf(order.orderStatus);
    if (order.deliveryConfirmed) {
      currentStep = 3;
    }
    // If status not found (e.g. Cancelled), handle gracefully
    if (currentStep == -1) currentStep = 0;

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textUser),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Stepper (Premium Look)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: steps.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String s = entry.value;
                  bool active = idx <= currentStep;
                  bool isLast = idx == steps.length - 1;

                  return Expanded(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: active
                                    ? AppColors.primaryUser
                                    : Colors.grey.shade200,
                              ),
                              child: Icon(
                                active ? Icons.check : Icons.circle,
                                size: 16,
                                color: active
                                    ? Colors.white
                                    : Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              s,
                              style: TextStyle(
                                color: active
                                    ? AppColors.textUser
                                    : Colors.grey,
                                fontSize: 10,
                                fontWeight: active
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              height: 2,
                              color: active
                                  ? AppColors.primaryUser.withValues(alpha: 0.5)
                                  : Colors.grey.shade200,
                              margin: const EdgeInsets.only(
                                bottom: 20,
                                left: 4,
                                right: 4,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Items List
            Text('Items', style: _headerStyle()),
            const SizedBox(height: 12),
            ...order.items.map(
              (e) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: _cardDecoration(),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        image: e.image.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(e.image),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: e.image.isEmpty
                          ? const Icon(Icons.image, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textUser,
                            ),
                          ),
                          Text(
                            '${e.selectedSize} | ${e.selectedColor}',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'x${e.quantity} • ₹${(e.price * e.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryUser,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Shipping Details
            if (currentStep >= 2) ...[
              Text('Shipping Details', style: _headerStyle()),
              const SizedBox(height: 12),
              Container(
                decoration: _cardDecoration(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.local_shipping,
                          color: AppColors.primaryUser,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            AppConstants.indiaPostName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textUser,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    if (order.trackingId.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tracking ID',
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                order.trackingId,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.textUser,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.copy,
                              color: AppColors.primaryUser,
                            ),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: order.trackingId),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Copied')),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: _buildActionButton(
                          'Track Order & View Slip',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    OrderTrackingScreen(order: order),
                              ),
                            );
                          },
                          isOutlined: true,
                        ),
                      ),
                    ],
                    if (order.trackingSlipUrl.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Tracking Slip',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textUser,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderTrackingScreen(order: order),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            order.trackingSlipUrl,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),

            if (order.orderStatus == 'Shipped' && !order.deliveryConfirmed)
              _buildActionButton(
                _isLoading ? 'Processing...' : 'I HAVE RECEIVED MY ORDER',
                _isLoading ? () {} : _confirmDelivery,
                color: Colors.green,
              ),

            if (order.deliveryConfirmed)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Delivered. Thank you!',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  TextStyle _headerStyle() {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: AppColors.textUser,
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
      border: Border.all(color: Colors.grey.shade100),
    );
  }

  Widget _buildActionButton(
    String text,
    VoidCallback onPressed, {
    Color? color,
    bool isOutlined = false,
  }) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: color ?? AppColors.primaryUser),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color ?? AppColors.primaryUser,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primaryUser,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}
