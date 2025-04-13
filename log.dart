import 'package:flutter/material.dart';
import 'sign.dart';
import 'auth_service.dart'; 
import 'navbarpage.dart';

class Log extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Log> {
  final _formKey = GlobalKey<FormState>();
  String? _usernameOrPhone, _password;
  final AuthService _authService = AuthService();
  bool _isLoading = false; // Loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Log In', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                
                // Username or Phone Number Field
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter Username or Phone Number',
                    labelText: 'Username / Phone',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your username or phone number';
                    }
                    return null;
                  },
                  onSaved: (value) => _usernameOrPhone = value,
                ),
                
                SizedBox(height: 20),

                // Password Field
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter password',
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value,
                ),
                
                SizedBox(height: 20),

                // Login Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Log In', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),

                SizedBox(height: 20),

                // Google and Facebook Login
               
                
                TextButton(
                  onPressed:(){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder:(context)=>Sign())
                    );
                  },
                  child:Text("Don't Have An Account? Sign Up", style:TextStyle(fontWeight:FontWeight.bold,color:Colors.blue))

                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      setState(() => _isLoading = true);

      bool success = await _authService.login(_usernameOrPhone!, _password!);

      setState(() => _isLoading = false);

      if (success) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed. Check your credentials and try again.",style:TextStyle(color:Colors.red))),
        );
      }
    }
  }
}
