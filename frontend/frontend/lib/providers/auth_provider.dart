import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated, error }

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthStatus _status = AuthStatus.unauthenticated;
  String? _errorMessage;
  String? _token;
  String? _userName;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get userName => _userName;

  AuthProvider() {
    _tryAutoLogin();
  }

  Future<void> _tryAutoLogin() async {
    final token = await _storage.read(key: 'jwt_token');
    final name = await _storage.read(key: 'user_name');
    if (token != null) {
      _token = token;
      _userName = name;
      _status = AuthStatus.authenticated;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _userName = data['fullName'];

        await _storage.write(key: 'jwt_token', value: _token);
        await _storage.write(key: 'user_name', value: _userName);

        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid email or password';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Could not connect to server';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String fullName, String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.post('/auth/register', {
        'fullName': fullName,
        'email': email,
        'password': password,
        'defaultCurrency': 'USD',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _userName = data['fullName'];

        await _storage.write(key: 'jwt_token', value: _token);
        await _storage.write(key: 'user_name', value: _userName);

        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Registration failed. Email might be in use.';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Connection error';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    _token = null;
    _userName = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}