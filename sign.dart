import 'package:flutter/material.dart';
import 'auth_service.dart'; // Import AuthService
import 'log.dart';


class Sign extends StatefulWidget {
  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<Sign> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Sign Up',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                            hintText: 'Enter Username',
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter username';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _contactController,
                        decoration: InputDecoration(
                            hintText: 'Contact',
                            labelText: 'Contact',
                            prefixIcon: Icon(Icons.call),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty || value.length > 10) {
                            return 'Enter a valid contact';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            hintText: 'Enter Email',
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains("@")) {
                            return "Please enter a valid email";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            hintText: 'Enter password',
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder()),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 8) {
                            return 'Enter a strong password';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder()),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please confirm password";
                          } else if (value != _passwordController.text) {
                            return "Passwords don't match";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool success = await _authService.register(
                              _usernameController.text,
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("Registration successful!")),
                              );
                              Navigator.push(
                            context,
                            MaterialPageRoute(builder:(context)=>Log())
                          ); // Go back to login page
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Registration failed")),
                              );
                            }
                          }
                        },
                        child: Text('Sign Up',
                            style: TextStyle(
                                fontSize: 20, color: Colors.blue)),
                      ), SizedBox(height:15),
                      TextButton(
                        onPressed:(){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder:(context)=>Log())
                          );
                        },
                        child:Text("Already Have An Account, Log In",style:TextStyle(color:Colors.blue,fontWeight:FontWeight.bold))
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
