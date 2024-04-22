import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:drivly2/screens/account_screen.dart';
import 'package:drivly2/screens/login_screen.dart';
import 'registered_content.dart';
import 'unregistered_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Главная страница'),
        actions: [
          IconButton(
            onPressed: () {
              if ((user == null)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountScreen()),
                );
              }
            },
            icon: Icon(
              Icons.person,
              color: (user == null) ? Colors.white : Colors.yellow,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: (user == null) ? UnregisteredContent() : RegisteredContent(),
        ),
      ),
    );
  }
}