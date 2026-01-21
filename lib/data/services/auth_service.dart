import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  // Replace with your local IP if testing on real device
  // Localhost for Web: http://localhost:3000
  // Localhost for Emulator: http://10.0.2.2:3000
  static const String _baseUrl = kIsWeb
      ? 'http://localhost:3000/api'
      : 'http://10.0.2.2:3000/api';

  // Use SharedPreferences for Web compatibility, SecureStorage for Mobile
  final _storage = const FlutterSecureStorage();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isAdmin => _currentUser?.role == 'admin';
  bool get isInitialized => !_isLoading;

  // Migration Helpers
  String? get uid => _currentUser?.id;

  Future<void> tryAutoLogin() async {
    try {
      String? token;
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        token = prefs.getString('auth_token');
        final userData = prefs.getString('user_data');
        if (userData != null) {
          _currentUser = User.fromJson(jsonDecode(userData));
        }
      } else {
        token = await _storage.read(key: 'auth_token');
        String? userData = await _storage.read(key: 'user_data');
        if (userData != null) {
          _currentUser = User.fromJson(jsonDecode(userData));
        }
      }

      if (token != null && _currentUser != null) {
        // success
      }
    } catch (e) {
      debugPrint('Auto login failed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String phone, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = User.fromJson(data['user']);

        _currentUser = user;

        if (kIsWeb) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setString('user_data', jsonEncode(user.toJson()));
        } else {
          await _storage.write(key: 'auth_token', value: token);
          await _storage.write(
            key: 'user_data',
            value: jsonEncode(user.toJson()),
          );
        }
      } else {
        throw Exception(jsonDecode(response.body)['error'] ?? 'Login failed');
      }
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({String? name, String? profileImageUrl}) async {
    if (_currentUser == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/users/${_currentUser!.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'profile_image_url': profileImageUrl}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // data is just the user object
        _currentUser = User.fromJson(data);

        // Update storage
        if (kIsWeb) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            'user_data',
            jsonEncode(_currentUser!.toJson()),
          );
        } else {
          await _storage.write(
            key: 'user_data',
            value: jsonEncode(_currentUser!.toJson()),
          );
        }
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Update profile error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
    } else {
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'user_data');
    }
    notifyListeners();
  }

  // Method stubs to prevent compilation errors in existing code
  Future<void> signInWithGoogle() async {
    throw UnimplementedError('Google Sign In removed');
  }

  Future<void> signUpWithEmail(String email, String password) async {
    throw UnimplementedError('Use login with phone');
  }

  Future<void> signInWithEmail(String email, String password) async {
    // Map to login
    // This is a hack to support existing UI calling this method
    // But really we should change the UI to use phone/password
    // or just map this to login if email is treated as phone?
    // For now, let's just interpret email as phone if it looks like one
    await login(email, password);
  }

  Future<void> makeMeAdmin() async {
    if (_currentUser == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/admin/promote'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': _currentUser!.id}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUser = User.fromJson(data['user']);

        // Update storage
        if (kIsWeb) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            'user_data',
            jsonEncode(_currentUser!.toJson()),
          );
        } else {
          await _storage.write(
            key: 'user_data',
            value: jsonEncode(_currentUser!.toJson()),
          );
        }
      } else {
        throw Exception('Promotion failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Admin promote error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkAdmin() async {
    // Stub
  }
}
