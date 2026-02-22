import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_repo/screens/home_screen.dart';
import 'package:web_repo/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Start with a simple blank screen to avoid the black hang
  runApp(const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator()))));

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
  ));
}