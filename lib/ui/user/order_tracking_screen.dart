import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/constants.dart';
import '../../data/models/order_model.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;
  const OrderTrackingScreen({super.key, required this.order});

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $urlString';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not launch url')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Specific colors for India Post branding from the HTML mockup
    const Color indiaPostRed = Color(0xFFD8232A);
    const Color indiaPostYellow = Color(0xFFE8C646);

    return Scaffold(
      backgroundColor: Colors.black, // Dark background for the slip view
      body: Stack(
        children: [
          // 1. Main Background / Slip View
          Positioned.fill(
            bottom: 300, // Leave space for bottom sheet
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: Center(
                child: order.trackingSlipUrl.isNotEmpty
                    ? Image.network(
                        order.trackingSlipUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (ctx, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        },
                        errorBuilder: (ctx, error, stackTrace) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.broken_image,
                              color: Colors.white54,
                              size: 50,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Tracking Slip Image",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image_not_supported,
                            color: Colors.white54,
                            size: 60,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "No Slip Available",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          // 2. AppBar Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        "Tracking Slip",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Epilogue',
                        ),
                      ),
                    ),
                    const SizedBox(width: 40), // Balance the back button
                  ],
                ),
              ),
            ),
          ),

          // 3. Zoom Hint Button (Visual only as InteractiveViewer handles it, but good for UX)
          Positioned(
            right: 20,
            bottom: 340, // Above the bottom sheet
            child: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.8),
              radius: 24,
              child: const Icon(Icons.zoom_in, color: Colors.white),
            ),
          ),

          // 4. Bottom Sheet Details
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.backgroundUser,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 48,
                      height: 6,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),

                  // Header: India Post Title
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: indiaPostYellow.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              height: 4,
                              child: Container(color: indiaPostYellow),
                            ),
                            const Icon(
                              Icons.local_post_office,
                              color: indiaPostRed,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              AppConstants.indiaPostName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Epilogue',
                                color: AppColors.textUser,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                _buildTag(
                                  "Dak Seva",
                                  indiaPostRed,
                                  Colors.white,
                                ),
                                const SizedBox(width: 6),
                                _buildTag(
                                  "Jan Seva",
                                  Colors.transparent,
                                  indiaPostRed,
                                  border: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.verified, color: Colors.grey, size: 24),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Tracking ID Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "CONSIGNMENT NUMBER",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.trackingId.isEmpty
                              ? "NOT ASSIGNED"
                              : order.trackingId,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: indiaPostRed,
                            letterSpacing: 1.5,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.content_copy,
                          label: "Copy ID",
                          onTap: () {
                            if (order.trackingId.isNotEmpty) {
                              Clipboard.setData(
                                ClipboardData(text: order.trackingId),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Tracking ID copied!'),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.public,
                          label: "Track on\nWebsite",
                          color: indiaPostRed,
                          iconColor: Colors.white,
                          onTap: () => _launchUrl(
                            context,
                            AppConstants.indiaPostWebsite,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.open_in_new,
                          label: "Post Info\nApp",
                          onTap: () =>
                              _launchUrl(context, AppConstants.indiaPostAppUrl),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(
    String text,
    Color bg,
    Color textColor, {
    bool border = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
        border: border ? Border.all(color: textColor) : null,
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white,
    Color iconColor = Colors.black54,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: color == Colors.white
              ? Border.all(color: Colors.grey.shade200)
              : null,
          boxShadow: [
            if (color != Colors.white)
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 8),
            Text(
              label.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
