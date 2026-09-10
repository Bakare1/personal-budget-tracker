import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/api_service.dart';

class TransactionProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/transactions');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _transactions = data
            .map((json) => TransactionModel.fromJson(json))
            .toList();
      } else {
        _errorMessage = 'Failed to load transactions';
      }
    } catch (e) {
      _errorMessage = 'Connection error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTransaction({
    required int accountId,
    required double amount,
    required String type,
    required String note,
  }) async {
    try {
      final response = await _apiService.post('/transactions', {
        'accountId': accountId,
        'amount': amount,
        'type': type,
        'note': note,
        'transactionDate': DateTime.now().toIso8601String(),
      });

      if (response.statusCode == 200) {
        await fetchTransactions();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
