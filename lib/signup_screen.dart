import 'package:calley_app/otp_verification_screen.dart';
import 'package:calley_app/signin_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool agree = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  final _emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  final _mobileRegex = RegExp(r"^\d{10}$");

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    // Here we Check if Terms & Conditions are accepted
    if (!agree) {
      showSnack('Please accept Terms & Conditions'); 
      return; 
    }

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String mobile = mobileController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || mobile.isEmpty) {
      showSnack('All fields are required');
      return;
    }
    if (!_emailRegex.hasMatch(email)) {
      showSnack('Invalid email format');
      return;
    }
    if (!_mobileRegex.hasMatch(mobile)) {
      showSnack('Mobile must be 10 digits');
      return;
    }

    final regUrl = Uri.parse('https://mock-api.calleyacd.com/api/auth/register');
    final regRes = await http.post(
      regUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": name,
        "email": email,
        "password": password,
      }),
    );

    final regBody = jsonDecode(regRes.body);

    if (regRes.statusCode == 400 && regBody['message'] == 'User already registered') {
      showSnack('User already registered');
      return;
    }

    if (regRes.statusCode == 200 || regRes.statusCode == 201) {
      final otpSent = await sendOtp(email);
      if (otpSent && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(email: email, name: name),
          ),
        );
      } else {
        showSnack('Failed to send OTP');
      }
    } else {
      showSnack('Registration failed: ${regBody['message'] ?? 'Unknown error'}');
    }
  }

  Future<bool> sendOtp(String email) async {
    final url = Uri.parse('https://mock-api.calleyacd.com/api/auth/send-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email}),
    );

    final body = jsonDecode(response.body);
    if (body['message'] == 'User is already verified') {
      showSnack('User already verified. Please login.');
      return false;
    }

    return response.statusCode == 200 || response.statusCode == 201;
  }

  void showSnack(String message) {
    // I have Set snackbar duration to 3 seconds here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 3)), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpKegvn_mr4bBxYiKTIRcfk7QfVNuaLI6fjA&s',
                  height: 60,
                ),
                const SizedBox(height: 30),
                const Text('Welcome!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text('Please register to continue', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email address',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(children: [Text('🇮🇳'), SizedBox(width: 5), Text('+91')]),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: mobileController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Mobile number',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: agree,
                      onChanged: (val) => setState(() => agree = val!),
                    ),
                    const Text('I agree to the '),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Terms and Conditions',
                        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignInScreen()),
                        );
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
