import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/order_model.dart';
import '../../data/providers/cart_provider.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/database_service.dart';
import 'my_addresses_screen.dart';
import 'order_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'COD'; // COD or UPI
  String? _shippingAddress; // Selected shipping address

  final TextEditingController _utrController = TextEditingController();
  final TextEditingController _userBankCtrl = TextEditingController();
  final TextEditingController _beneficiaryNameCtrl = TextEditingController(
    text: 'Chic Boutique',
  ); // Default from mockup
  final TextEditingController _beneficiaryBankCtrl = TextEditingController(
    text: 'HDFC Bank',
  );
  final TextEditingController _phoneCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userPhone = context.read<AuthService>().currentUser?.phone ?? '';
    _phoneCtrl.text = userPhone;
  }

  Future<void> _navigateToAddAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MyAddressesScreen(isSelectionMode: true),
      ),
    );
    if (result != null && result is String) {
      setState(() => _shippingAddress = result);
    }
  }

  Future<void> _submitOrder() async {
    if (_shippingAddress == null || _shippingAddress!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a shipping address')),
      );
      return;
    }
    if (_paymentMethod == 'UPI' && _utrController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Transaction ID')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final cart = context.read<CartProvider>();
    final user = context.read<AuthService>().currentUser;

    final order = OrderModel(
      id: const Uuid().v4(),
      userId: user?.id ?? 'guest',
      userPhone: _phoneCtrl.text,
      totalAmount: cart.totalAmount,
      items: List.from(cart.items),
      paymentMethod: _paymentMethod,
      shippingAddress: _shippingAddress!,
      beneficiaryName: _paymentMethod == 'UPI'
          ? _beneficiaryNameCtrl.text
          : null,
      beneficiaryBank: _paymentMethod == 'UPI'
          ? _beneficiaryBankCtrl.text
          : null,
      upiId: _paymentMethod == 'UPI' ? 'boutique@upi' : null,
      transactionId: _paymentMethod == 'UPI' ? _utrController.text : null,
      userBankName: _paymentMethod == 'UPI' ? _userBankCtrl.text : null,
      paymentStatus: _paymentMethod == 'UPI'
          ? 'Pending Verification'
          : 'Pending',
      createdAt: DateTime.now(),
    );

    try {
      await context.read<DatabaseService>().createOrder(order);
      cart.clear(); // Clear cart after successful order creation
      if (mounted) {
        // Navigate to Success Screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => OrderSuccessScreen(
              orderId: order.id,
              totalAmount: order.totalAmount,
            ),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = context.read<CartProvider>().totalAmount;
    return Scaffold(
      backgroundColor: AppColors.backgroundUser,
      appBar: AppBar(
        title: const Text(
          'Checkout',
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
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Order Total Header
            Center(
              child: Column(
                children: [
                  const Text(
                    'ORDER TOTAL',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppColors.primaryUser,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily:
                          'Epilogue', // Using Epilogue if available, else fallback
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textUser,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Shipping Details Section
            const Text(
              'SHIPPING DETAILS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.2,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.location_on, color: AppColors.primaryUser),
                          SizedBox(width: 10),
                          Text(
                            'Delivery Address',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textUser,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _navigateToAddAddress,
                        child: Text(
                          _shippingAddress == null ? 'ADD' : 'CHANGE',
                          style: const TextStyle(
                            color: AppColors.primaryUser,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  if (_shippingAddress != null)
                    Text(
                      _shippingAddress!,
                      style: const TextStyle(
                        color: AppColors.textUser,
                        height: 1.5,
                      ),
                    )
                  else
                    const Text(
                      'No address selected. Please add a delivery address.',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneCtrl,
                    decoration: _inputDecoration('Contact Number', Icons.phone),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Payment Method Selection
            const Text(
              'PAYMENT METHOD',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.2,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildRadioTile('Cash on Delivery (COD)', 'COD'),
                  Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
                  _buildRadioTile('UPI Payment (Manual)', 'UPI'),
                ],
              ),
            ),

            if (_paymentMethod == 'UPI') ...[
              const SizedBox(height: 32),
              // QR Code Section
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryUser.withValues(
                              alpha: 0.15,
                            ),
                            blurRadius: 40,
                            offset: const Offset(0, 15),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.primaryUser.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundUser,
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBkzJh5KWxVdfAmac99Zj0dwkPZSVHiuocKVQZSvFHBujJ1sFKu8cs8lpyZx9SBVafS6Fa21TFmPSnkSMo7aOC2GcexATvbGPmzSEUfpomE0NFP_SGPG-49m23tKL_7BDub_xVvW_KnpgPaFDWJWC4AqBpOefTkrWjfobGMQog218tDTPDjPRH__ECCMcO-I39IUuGTlgzNBJcFytzoH6hhJVHkBoQp_Ph-VpVIdQDq1qGqvDn0F67nqK0PFv5OqxCcsQFVXF65PIw',
                            ), // Placeholder/Mockup QR
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primaryUser.withValues(alpha: 0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: const Text(
                          'SCAN TO PAY',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryUser,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Beneficiary Details
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BENEFICIARY DETAILS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Pay to', 'Chic Boutique'),
                    _buildDetailRow('Bank', 'HDFC Bank'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'UPI ID',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'boutique@upi',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textUser,
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(
                                  const ClipboardData(text: 'boutique@upi'),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Copied')),
                                );
                              },
                              child: const Icon(
                                Icons.copy,
                                size: 16,
                                color: AppColors.primaryUser,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Phone',
                      '+91 98765 43210',
                      isCopyable: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Verify Payment
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryUser.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_user,
                      size: 16,
                      color: AppColors.primaryUser,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Verify Payment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Epilogue',
                      color: AppColors.textUser,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _utrController,
                decoration: _inputDecoration(
                  'Transaction ID (UTR)',
                  Icons.tag,
                  hint: 'Enter 12-digit UTR number',
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryUser.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryUser.withValues(alpha: 0.1),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: AppColors.primaryUser,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'After paying via UPI, enter the Transaction ID shown in your UPI app.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _userBankCtrl,
                decoration: _inputDecoration(
                  'Sender Name (Account Holder)',
                  Icons.person,
                  hint: 'Name as per bank record',
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryUser,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: AppColors.primaryUser.withValues(alpha: 0.4),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Submit Payment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioTile(String title, String value) {
    bool selected = _paymentMethod == value;
    return InkWell(
      onTap: () => setState(() => _paymentMethod = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? AppColors.primaryUser
                      : Colors.grey.shade300,
                  width: 2,
                ),
                color: selected ? AppColors.primaryUser : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textUser,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.textMuted),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primaryUser),
      ),
      labelStyle: const TextStyle(color: AppColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade100),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isCopyable = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textUser,
                ),
              ),
              if (isCopyable) ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Copied')));
                  },
                  child: const Icon(
                    Icons.copy,
                    size: 16,
                    color: AppColors.primaryUser,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
