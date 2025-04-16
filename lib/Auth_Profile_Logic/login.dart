// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:competitivecodingarena/Auth_Profile_Logic/login_signup.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/containers/homescreen.dart';

typedef ValidatorFunction = String? Function(String?);

class LoginScreen extends StatefulWidget {
  final Size size;
  const LoginScreen({required this.size, super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isSignUp = false;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm = TextEditingController();
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  setClear() {
    name.clear();
    email.clear();
    password.clear();
    confirm.clear();
    setState(() => _isSignUp = false);
  }

  SizedBox nUll = const SizedBox(height: 0, width: 0);

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters long';
    }
    if (value.trim().length > 50) {
      return 'Name must not exceed 50 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    if (value.length > 254) {
      return 'Email must not exceed 254 characters';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (!_isSignUp) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 12) {
      return 'Password must be at least 12 characters long';
    }
    if (value.length > 128) {
      return 'Password must not exceed 128 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (confirm.text.isEmpty) {
      return 'Confirm Password is required';
    }
    if (confirm.text != password.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SingleChildScrollView(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1.1,
              child: Center(
                  child: Container(
                      width: widget.size.width * 0.3,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)]),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue.withOpacity(0.15),
                                blurRadius: 20,
                                spreadRadius: 5)
                          ]),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset("assets/images/logo.png", width: 80),
                              const SizedBox(height: 32),
                              _isSignUp
                                  ? _buildTextField('Name', name,
                                      validator: validateName)
                                  : nUll,
                              const SizedBox(height: 10),
                              _buildTextField('Email', email,
                                  validator: validateEmail),
                              const SizedBox(height: 10),
                              _buildTextField('Password', password,
                                  isPassword: true,
                                  validator: validatePassword),
                              _isSignUp ? const SizedBox(height: 10) : nUll,
                              _isSignUp
                                  ? _buildTextField('Confirm Password', confirm,
                                      isPassword: true,
                                      validator: validateConfirmPassword)
                                  : nUll,
                              const SizedBox(height: 24),
                              _buildActionButton(),
                              const SizedBox(height: 20),
                              _buildToggleAuthModeRow(),
                              const SizedBox(height: 32),
                              _buildDivider(),
                              const SizedBox(height: 32),
                              _buildSocialLoginButtons()
                            ],
                          )))))),
      bottomNavigationBar: _buildFooter());

  Widget _buildTextField(String hint, TextEditingController controller,
      {bool isPassword = false, ValidatorFunction? validator}) {
    return Container(
        decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2))
            ]),
        child: TextFormField(
            controller: controller,
            obscureText: isPassword ? _obscurePassword : false,
            style: const TextStyle(color: Colors.white),
            validator: validator,
            decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                prefixIcon: Icon(
                    isPassword ? Icons.lock_outline : Icons.person_outline,
                    color: Colors.blue),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          !_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword))
                    : null)));
  }

  Widget _buildActionButton() => ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          if (!_isSignUp) {
            loginLogic(context, email.text, password.text);
          } else {
            signUpLogic(context, email.text, password.text, name.text);
            setClear();
          }
        }
      },
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue[900],
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 120),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(_isSignUp ? "Sign Up" : "Sign In",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
      ]));

  Widget _buildToggleAuthModeRow() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        if (!_isSignUp)
          TextButton(
              onPressed: () {},
              child: const Text("Forgot Password?",
                  style: TextStyle(color: Colors.blue, fontSize: 14))),
        const Spacer(),
        TextButton(
            onPressed: () {
              setState(() {
                _isSignUp = !_isSignUp;
                email.clear();
                password.clear();
              });
            },
            child: Text(
                _isSignUp
                    ? "Already have an account? Sign In"
                    : "Don't have an account? Sign Up",
                style: const TextStyle(color: Colors.blue, fontSize: 12)))
      ]);

  Widget _buildDivider() => Row(children: [
        Expanded(child: Divider(color: Colors.grey[700])),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("Or",
                style: TextStyle(color: Colors.grey[500], fontSize: 14))),
        Expanded(child: Divider(color: Colors.grey[700]))
      ]);

  Widget _buildSocialLoginButtons() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_buildSocialButton(FontAwesomeIcons.google)]);

  Widget _buildSocialButton(IconData icon) {
    UserCredential? userCredential;
    return InkWell(
        onTap: () async {
          userCredential = await signInWithGoogle(context);
          if (userCredential != null) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => LeetCodeProblemsetHomescreen(
                        size: MediaQuery.sizeOf(context))),
                (Route<dynamic> route) => false);
          }
        },
        child: Image.network(
            'https://thisismybucketiambatman123456.s3.ap-south-1.amazonaws.com/DO_NOT_DELETE/android_light_rd_ctn%404x.png',
            width: 200));
  }

  Widget _buildFooter() => Container(
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          _buildFooterLink('Help'),
          const SizedBox(width: 24),
          _buildFooterLink('Privacy Policy'),
          const SizedBox(width: 24),
          _buildFooterLink('Terms of Service')
        ]),
        Text('© 2025 trademark',
            style: TextStyle(color: Colors.grey[500], fontSize: 14))
      ]));

  Widget _buildFooterLink(String text) => InkWell(
      onTap: () {},
      child:
          Text(text, style: TextStyle(color: Colors.grey[500], fontSize: 14)));
}
