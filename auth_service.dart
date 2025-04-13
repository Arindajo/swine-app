import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://127.0.0.1:8000/auth1app/api/'; // Correct endpoint

  // Register function
  // Register function with debugging
Future<bool> register(String username, String email, String password) async {
  var url = Uri.parse('${baseUrl}register/');

  var response = await http.post(
    url,
    body: json.encode({
      'username': username,
      'email': email,
      'password': password,
      'confirmpassword': password, // Ensure backend expects this
    }),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  print("Response Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}"); // Print response from backend

  if (response.statusCode == 201) {
    print('User registered successfully');
    return true;
  } else {
    print('Registration failed: ${response.body}');
    return false;
  }
}


  // Login function
  Future<bool> login(String usernameOrPhone, String password) async {
    var url = Uri.parse('${baseUrl}login/');

    var response = await http.post(
      url,
      body: json.encode({
        'username': usernameOrPhone, // Can be username or phone number
        'password': password,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['token']; // Get the authentication token

      // Store the token in SharedPreferences for persistent login
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      print('Login successful. Token: $token');
      return true;
    } else {
      print('Login failed: ${response.body}');
      return false;
    }
  }

  // Logout function
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove token to log out the user
    print('User logged out');
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }
}
