import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundUser,
      appBar: AppBar(
        title: const Text(
          'Your Wallet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textUser,
          ),
        ),
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textUser),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.withValues(alpha: 0.1),
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Privileges',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textUser,
                  ),
                ),
                Text(
                  '2 AVAILABLE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildCouponCard(
              context,
              discount: '20% OFF',
              title: 'Welcome Gift',
              subtitle: 'Valid on your first purchase',
              code: 'WELCOME20',
              color: AppColors.primaryUser,
              icon: Icons.local_mall_outlined,
              terms:
                  'Offer valid for new customers only. Excludes clearance items.',
            ),
            const SizedBox(height: 20),
            _buildCouponCard(
              context,
              discount: '₹500 OFF',
              title: 'Festive Special',
              subtitle: 'Min. spend ₹2000',
              code: 'FESTIVE500',
              color: AppColors.secondaryUser,
              icon: Icons.diamond_outlined,
              terms: 'Valid on the Festive Collection only. Expires Dec 31st.',
            ),
            const SizedBox(height: 30),
            Divider(color: Colors.grey.withValues(alpha: 0.2)),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Curated Collections',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textUser,
                  ),
                ),
                Text(
                  'VIEW ALL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryUser,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Placeholder for Curated Collections Grid
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCollectionCard(
                    'The Silk Edit',
                    'Buy 2 Get 1 Free',
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCn5Zrf5S0glkO33BtejYYljkPBiojvFX18oEbBfKc70way6MUwhEOAYcmZ367GuDZCSXNFmDQZlBPo6GVcOmmpogqwd3YnE4TXP6AOBfsHRYW9LOk_SouEYqQXOh5mNf_Sj-rVrmS7p8VXB-qV4nBy1r0D9-Buuhu0YZRtLkyfHSHa5bOva_O3X0wij3RiK5MXvRw3KxciuHOsKVGXWMBlpTnB-3RYjS7tFjdmBMZHsiKKyWUNycKBnai0eRarLHQc4MOd-fz4kvY',
                  ),
                  const SizedBox(width: 16),
                  _buildCollectionCard(
                    'Winter Step',
                    'Up to 40% Off',
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCJvZKXVMqqSshG7nKNiN3L6T-YbZo0dSgNo_w6DAHmlEKBG1ZJWeDPvD0cKtW50xZwbxqZJl5gFUSSMJN4A9epInOXb6zm4Byh7_KUjOW9_PoyrY8u_TJiUubvKDmkv_xJLboDF4UiOJQPzo4WrjSBcQegO8QbAovWvDxbC6XlSffRs5lRfDnGdZdV9slCZv5aRY2WKiZ6drg9Ibd3xRU8_15dg6l8p9cuku3iQ1uCa9ABL6eqfhkP1MPcD3EtUFCpIjJawWKfPGk',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponCard(
    BuildContext context, {
    required String discount,
    required String title,
    required String subtitle,
    required String code,
    required Color color,
    required IconData icon,
    required String terms,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
          ),
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              icon,
              size: 120,
              color: Colors.grey.withValues(alpha: 0.05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          discount,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: color,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textUser,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomPaint(
                  painter: DashedLinePainter(),
                  child: const SizedBox(height: 1, width: double.infinity),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'COUPON CODE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMuted,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          code,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: AppColors.textUser,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Code copied!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text(
                        'COPY',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: const Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  children: [
                    Text(
                      terms,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionCard(String title, String subtitle, String imageUrl) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
          ),
        ),
        padding: const EdgeInsets.all(12),
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'SPECIAL DEAL',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 3, startX = 0;
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
