import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/services/auth_service.dart';
import '../../core/utils/constants.dart';
import '../../core/theme/app_colors.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  final bool _isSignUp = false; // Toggle between Login and Sign Up

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submitEmail() async {
    setState(() => _isLoading = true);
    final auth = context.read<AuthService>();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter email and password');
      setState(() => _isLoading = false);
      return;
    }

    try {
      if (_isSignUp) {
        await auth.signUpWithEmail(email, password);
      } else {
        // await auth.signInWithEmail(email, password);
        // Treat as phone login
        await auth.login(email, password);
      }
      debugPrint('LOGGED IN UID: ${auth.currentUser?.id}');
      if (mounted) {
        setState(() => _isLoading = false);
        // Force navigation to ensure we leave the login screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
        );
      }
    } catch (e) {
      debugPrint('Login Error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        _showError(e.toString());
      }
    }
  }

  Future<void> _googleLogin() async {
    setState(() => _isLoading = true);
    try {
      await context.read<AuthService>().signInWithGoogle();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundUser,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo / Title
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryUser.withValues(alpha: 0.1),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 48,
                    color: AppColors.primaryUser,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  AppConstants.appName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textUser,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  _isSignUp ? 'Create your account' : 'Welcome back',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 48),

                // Phone/Password Form
                TextField(
                  controller:
                      _emailController, // Retaining variable name to avoid refactoring whole file
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration(
                    'Phone Number',
                    Icons.phone_android,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _inputDecoration('Password', Icons.lock_outline),
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _isLoading ? null : _submitEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryUser,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: AppColors.primaryUser.withValues(alpha: 0.4),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          _isSignUp ? 'Sign Up' : 'Login',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // For now, simple toggle. Ideally separate screens.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Sign up not fully implemented in UI. Please contact admin to create account.',
                        ),
                      ),
                    );
                    // setState(() => _isSignUp = !_isSignUp);
                  },
                  child: Text(
                    'Login with Phone & Password',
                    // _isSignUp
                    //     ? 'Already have an account? Login'
                    //     : 'Don\'t have an account? Sign Up',
                    style: const TextStyle(color: AppColors.primaryUser),
                  ),
                ),

                const SizedBox(height: 40),

                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.black12)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.black12)),
                  ],
                ),

                const SizedBox(height: 40),

                // Google Sign In
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _googleLogin,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  icon: const Icon(
                    Icons.login,
                    color: AppColors.textUser,
                  ), // Replace with generic login icon since no assets
                  label: const Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textUser,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.textMuted),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryUser),
      ),
      labelStyle: const TextStyle(color: AppColors.textMuted),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    debugPrint('LoginScreen Disposed');
    super.dispose();
  }
}
