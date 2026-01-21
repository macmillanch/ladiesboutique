import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class DebugSeedScreen extends StatefulWidget {
  const DebugSeedScreen({super.key});

  @override
  State<DebugSeedScreen> createState() => _DebugSeedScreenState();
}

class _DebugSeedScreenState extends State<DebugSeedScreen> {
  final _emailCtrl = TextEditingController(text: 'admin@rk.com');
  final _passwordCtrl = TextEditingController(text: 'password123');
  bool _isLoading = false;
  String _status = '';

  Future<void> _createAdmin() async {
    setState(() {
      _isLoading = true;
      _status = 'Creating admin...';
    });

    try {
      // Stub
      await Future.delayed(const Duration(seconds: 1));
      _status += '\nNot supported in Node.js backend migration yet.';
    } catch (e) {
      _status += '\nError: $e';
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _createCustomer() async {
    setState(() {
      _isLoading = true;
      _status = 'Creating customer...';
    });

    try {
      // Stub
      await Future.delayed(const Duration(seconds: 1));
      _status += '\nNot supported in Node.js backend migration yet.';
    } catch (e) {
      _status += '\nError: $e';
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug: Seed Accounts')),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Create Test Accounts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordCtrl,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: _createAdmin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryUser,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('CREATE & PROMOTE TO ADMIN'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _createCustomer,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('CREATE CUSTOMER (USER)'),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                color: Colors.grey[100],
                child: Text(
                  _status,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
