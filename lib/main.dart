import 'package:calley_app/language_selection_screen.dart';
import 'package:calley_app/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'signup_screen.dart'; 
import 'signin_screen.dart';
import 'calleyhome_screen.dart'; 
import 'dashboard_screen.dart';
import 'dashboard_analytics_screen.dart'; 
import 'app_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calley App UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/language', // Our app start with LanguageSelectionScreen
      routes: {
        '/': (context) => const MyHomePage(title: 'Calley App'),
        '/language': (context) => LanguageSelectionScreen(),
        '/register': (context) => SignUpScreen(), 
        '/otp': (context) => OTPVerificationScreen(email: '', name: '',),
        '/login': (context) => SignInScreen(), 
        '/home': (context) => CalleyHomeScreen(userName: '',), 
        '/dashboard': (context) => DashboardScreen(),
        '/analytics': (context) => DashboardAnalyticsScreen(userId: '', email: '', listId: ''), 
        '/drawer': (context) => Scaffold(
              drawer: AppDrawer(),
              appBar: AppBar(title: Text("Drawer Preview")),
              body: Center(child: Text("Drawer Content")),
            ),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        children: [
          ListTile(
            title: Text('OTP Verification'),
            onTap: () => Navigator.pushNamed(context, '/otp'),
          ),
          ListTile(
            title: Text('Login'),
            onTap: () => Navigator.pushNamed(context, '/login'),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),
          ListTile(
            title: Text('Dashboard'),
            onTap: () => Navigator.pushNamed(context, '/dashboard'),
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),  
          ListTile(
            title: Text('Analytics'),
            onTap: () => Navigator.pushNamed(context, '/analytics'),
          ),
          ListTile(
            title: Text('Drawer Menu'),
            onTap: () => Navigator.pushNamed(context, '/drawer'),
          ),
        ],
      ),
    );
  }
}

