import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundUser,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textUser,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Mark all as read',
              style: TextStyle(
                color: AppColors.primaryUser,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textUser),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('TODAY'),
            _buildNotificationCard(
              title: 'Order Shipped!',
              time: '2m ago',
              description: 'Your summer dress is on the way.\nTrack ID: #88349',
              icon: Icons.local_shipping,
              isUnread: true,
            ),
            _buildNotificationCard(
              title: 'Flash Sale Alert',
              time: '2h ago',
              description: '20% off all silk scarves until midnight.',
              icon: Icons.local_offer,
              isUnread: true,
              actionLabel: 'Shop Now',
              color: AppColors.secondaryUser,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('YESTERDAY'),
            _buildNotificationCard(
              title: 'Return Processed',
              time: '10:30 AM',
              description:
                  "We've received your return for Order #88112. Refund initiated.",
              icon: Icons.check_circle,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            _buildImageNotificationCard(
              title: 'New Arrivals',
              time: '4:15 PM',
              description: 'The Spring Floral collection is finally here.',
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBvpwf4hBmxk57SGVJCItD_GEZKpWXDY02o6nWjThVyC4s1yyV2TgUy4isOnnkriSzYR-Uc6jCh0YiTJIUQExFOGkZpoPk7saRCx3wAfi1Z0pH8ljQpxtMG977hohrUAWGCSPP1BSkLOxvmLsoY3QWFCiJhlJI7Xw5nLOxE6fw_k2C3osJ9PoTb5HNKiOTSkcVZVQEBkrlOBqPcQ0xyrFUhfmaTItTvO9ENC7JaKtnpFnw1P6NddraDfaVOTnBbgJeDlUPxffolLCY',
            ),
            const SizedBox(height: 40),
            const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.local_florist_outlined,
                    size: 48,
                    color: AppColors.textMuted,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "You're all caught up",
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String time,
    required String description,
    required IconData icon,
    Color color = AppColors.primaryUser,
    bool isUnread = false,
    String? actionLabel,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              if (isUnread)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.primaryUser,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textUser,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textUser,
                    height: 1.5,
                  ),
                ),
                if (actionLabel != null) ...[
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text(
                          actionLabel,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 14, color: color),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageNotificationCard({
    required String title,
    required String time,
    required String description,
    required String imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textUser,
                          ),
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        color: AppColors.textUser,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundUser,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Collection',
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
    );
  }
}
