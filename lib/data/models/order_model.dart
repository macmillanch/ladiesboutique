class CartItem {
  final String productId;
  final String name;
  final double price;
  final String selectedSize;
  final String selectedColor;
  final int quantity;
  final String image;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.selectedSize,
    required this.selectedColor,
    required this.quantity,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'quantity': quantity,
      'image': image,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      price: double.tryParse(map['price'].toString()) ?? 0.0,
      selectedSize: map['selectedSize'] ?? '',
      selectedColor: map['selectedColor'] ?? '',
      quantity: int.tryParse(map['quantity'].toString()) ?? 1,
      image: map['image'] ?? '',
    );
  }
}

class OrderModel {
  final String id;
  final String userId;
  final String userPhone;
  final double totalAmount;
  final List<CartItem> items;
  final String paymentMethod; // 'COD' or 'UPI'

  // Payment Details (UPI)
  final String? beneficiaryName; // User input
  final String? beneficiaryBank; // User input
  final String? upiId;
  final String? transactionId;
  final String? userBankName;
  final String paymentStatus; // 'Pending', 'Verified'

  // Shipping Details
  final String shippingAddress;
  final String courierName;
  final String trackingId;
  final String trackingSlipUrl;
  final String orderStatus; // 'Ordered', 'Packed', 'Shipped', 'Delivered'
  final bool deliveryConfirmed;

  final DateTime createdAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.userPhone,
    required this.totalAmount,
    required this.items,
    required this.paymentMethod,
    this.beneficiaryName,
    this.beneficiaryBank,
    this.upiId,
    this.transactionId,
    this.userBankName,
    this.paymentStatus = 'Pending',
    this.shippingAddress = '',
    this.courierName = '',
    this.trackingId = '',
    this.trackingSlipUrl = '',
    this.orderStatus = 'Ordered',
    this.deliveryConfirmed = false,
    required this.createdAt,
    this.shippedAt,
    this.deliveredAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userPhone': userPhone,
      'totalAmount': totalAmount,
      'items': items.map((e) => e.toMap()).toList(),
      'paymentMethod': paymentMethod,
      'beneficiaryName': beneficiaryName,
      'beneficiaryBank': beneficiaryBank,
      'upiId': upiId,
      'transactionId': transactionId,
      'userBankName': userBankName,
      'paymentStatus': paymentStatus,
      'shippingAddress': shippingAddress,
      'courierName': courierName,
      'trackingId': trackingId,
      'trackingSlipUrl': trackingSlipUrl,
      'orderStatus': orderStatus,
      'deliveryConfirmed': deliveryConfirmed,
      'createdAt': createdAt.toIso8601String(),
      'shippedAt': shippedAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'].toString(),
      userId: json['user_id']?.toString() ?? '',
      userPhone: json['phone'] ?? '',
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => CartItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      paymentMethod: json['payment_method'] ?? 'COD',
      beneficiaryName: json['beneficiary_name'],
      beneficiaryBank: json['beneficiary_bank'],
      upiId: json['upi_id'],
      transactionId: json['transaction_id'],
      userBankName: json['user_bank_name'],
      paymentStatus: json['payment_status'] ?? 'Pending',
      shippingAddress: json['shipping_address'] ?? '',
      courierName: json['courier_name'] ?? '',
      trackingId: json['tracking_id'] ?? '',
      trackingSlipUrl: json['tracking_slip_url'] ?? '',
      orderStatus: json['status'] ?? 'Ordered',
      deliveryConfirmed: json['delivery_confirmed'] ?? false,
      createdAt:
          DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now(),
      shippedAt: json['shipped_at'] != null
          ? DateTime.tryParse(json['shipped_at'])
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.tryParse(json['delivered_at'])
          : null,
    );
  }

  // Helper getters for compatibility if needed
  Map<String, dynamic> toMap() => toJson();
}
