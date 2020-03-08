import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime expiryDate;
  String _userId;

  Future<void> signup(String email, String password) async {
    // final APIKEY = 'AIzaSyDcmyLc6AJGUpVdstlLxVWvKURjyVawXVM';
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDcmyLc6AJGUpVdstlLxVWvKURjyVawXVM';
    try {
      final res = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
      print(json.decode(res.body));
    } catch (error) {
      throw error;
    }
  }
}
