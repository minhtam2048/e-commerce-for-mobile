import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/common/http-exception.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime expiryDate;
  String _userId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDcmyLc6AJGUpVdstlLxVWvKURjyVawXVM';
    try {
      final res = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(res.body);
      print (responseData);
      if(responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      } 
    } catch (error) {
      // throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    // final APIKEY = 'AIzaSyDcmyLc6AJGUpVdstlLxVWvKURjyVawXVM';
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
