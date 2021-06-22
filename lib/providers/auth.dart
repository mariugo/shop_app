import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  final url = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA5xWENWewGYRiVp6Mkxw3zWd_7IaaXYsI');
  String _token;
  DateTime _expiryDate;
  String _userId;

  // Auth(
  //   this._token,
  //   this._expiryDate,
  //   this._userId,
  // );

  Future<void> signUp(String email, String password) async {
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
    } catch (error) {}
  }
}
