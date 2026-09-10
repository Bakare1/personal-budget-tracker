import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/account_model.dart';
import '../services/api_service.dart';

class AccountProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<AccountModel> _accounts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AccountModel> get accounts => _accounts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get totalBalance =>
      _accounts.fold(0.0, (sum, acc) => sum + acc.balance);

  Future<void> fetchAccounts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/accounts');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _accounts = data.map((json) => AccountModel.fromJson(json)).toList();
      } else {
        _errorMessage = 'Failed to load accounts';
      }
    } catch (e) {
      _errorMessage = 'Connection error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createAccount(String name, String type, double balance) async {
    try {
      final response = await _apiService.post('/accounts', {
        'name': name,
        'type': type,
        'balance': balance,
        'currency': 'USD',
      });

      if (response.statusCode == 200) {
        await fetchAccounts();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
