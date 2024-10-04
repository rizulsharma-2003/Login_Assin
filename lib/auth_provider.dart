import 'dart:async';
import 'package:flutter/material.dart';
import 'apiServices.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _message = '';
  String get message => _message;

  // Signup function using Provider
  Future<void> signup(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.signup(email, password);
      if (response['status']) {
        _message = response['message'];
      } else {
        _message = response['error'] ?? 'Signup Failed';
      }
    } catch (e) {
      _message = 'An error occurred during signup';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Login function using Provider
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);
      if (response['status']) {
        _message = response['message'];
      } else {
        _message = response['message'] ?? 'Login Failed';
      }
    } catch (e) {
      _message = 'An error occurred during login';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch Users function using Provider
  Future<List<dynamic>> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    List<dynamic> users = [];

    try {
      users = await _apiService.fetchUsers();
    } catch (e) {
      _message = 'Failed to load users';
    }

    _isLoading = false;
    notifyListeners();
    return users;
  }

  // Reset message for cleaner UI
  void resetMessage() {
    _message = '';
    notifyListeners();
  }
}
