import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:show_weather_application/services/auth_service.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    AuthService _authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: MediaQuery.of(context).size.width > 600
            ? null
            : Text('Register'), 
        leading: MediaQuery.of(context).size.width > 600
            ? null
            : IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return Center(
                child: SizedBox(
                  width: 400.0,
                  child: _buildForm(_authService),
                ),
              );
            } else {
              return _buildForm(_authService);
            }
          },
        ),
      ),
    );
  }

  Widget _buildForm(AuthService authService) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email';
              } else if (!EmailValidator.validate(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _password = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please confirm your password';
              } else if (value != _password) {
                return 'Passwords do not match';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _confirmPassword = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Process registration
                    bool success = await authService.register(_email, _password);
                    if (success) {
                      // Registration successful, navigate to login page
                      Navigator.pop(context);
                    } else {
                      // Registration failed, show error message
                      setState(() {
                        _errorMessage = 'Registration failed. Please try again.';
                      });
                    }
                  }
                },
                child: Text('Register'),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back to Login'),
              ),
            ],
          ),
          if (_errorMessage.isNotEmpty)
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
