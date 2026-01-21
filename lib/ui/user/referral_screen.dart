import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundUser,
      appBar: AppBar(
        title: const Text(
          'Refer & Earn',
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
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'History',
              style: TextStyle(
                color: AppColors.primaryUser,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            SizedBox(
              height: 250,
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 24, left: 24, right: 24),
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDDE0hu0Fd8IlHXHSjOt0OqKcivW2UDfD3s6lj1WiAEW8PKA7Jbec4vdNfEsi1VU0FV1Ht9XIcIQ5whEJF5PbDUgtNKd3WkNyRyo8uBjGj1kuzM7JVXw6FNEj3nKTd91xWNMGgU693_SzQLdHHcF6VCsGHx08iDh9oI1USlR8gN42hzMGwW74IK2VlOY35T0oaexhDCewROu-8Yfu4YPot9_R9c3N8GdB16CVc01hHvlJ6Fz_1e3kTX7zRbE6kYoYLLTzektczUy2E',
                        ),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondaryUser.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 26,
                    right: 24,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.redeem,
                            color: AppColors.secondaryUser,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'REWARDS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Invite Friends &\nGet 10% Off',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textUser,
                      height: 1.1,
                      fontFamily: 'Epilogue',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Share the love of style. Give your friends a discount and earn credits when they make their first purchase.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textMuted,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Steps
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StepItem(
                        icon: Icons.share,
                        title: 'Share Link',
                        subtitle: 'Send your link',
                      ),
                      _StepItem(
                        icon: Icons.shopping_bag,
                        title: 'Friend Buys',
                        subtitle: 'They shop new',
                      ),
                      _StepItem(
                        icon: Icons.celebration,
                        title: 'Get Reward',
                        subtitle: 'Earn 10% off',
                        isActive: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Code Card
                  Container(
                    padding: const EdgeInsets.all(24),
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
                      border: Border.all(
                        color: AppColors.secondaryUser.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text(
                              'YOUR UNIQUE CODE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMuted,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'BOUTIQUE23',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryUser,
                            letterSpacing: 2,
                          ),
                        ),
                        const Divider(height: 30),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              const ClipboardData(text: 'BOUTIQUE23'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Copied to clipboard'),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundUser,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.2),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tap to copy code',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textUser,
                                  ),
                                ),
                                Icon(
                                  Icons.copy,
                                  size: 18,
                                  color: AppColors.primaryUser,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC7DED9),
                      foregroundColor: AppColors.primaryUser,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.chat),
                    label: const Text(
                      'Share on WhatsApp',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Terms and conditions apply',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isActive;

  const _StepItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryUser : Colors.white,
            shape: BoxShape.circle,
            border: isActive
                ? null
                : Border.all(
                    color: AppColors.secondaryUser.withValues(alpha: 0.3),
                  ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primaryUser.withValues(alpha: 0.3),
                      blurRadius: 10,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : AppColors.primaryUser,
            size: 20,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: AppColors.textUser,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
