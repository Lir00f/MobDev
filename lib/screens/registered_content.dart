import 'package:flutter/material.dart';
import 'add_car_form.dart';
import 'rent_car_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisteredContent extends StatelessWidget {
  const RegisteredContent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';
    final username = email.isNotEmpty ? email.split('@')[0] : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
          child: Text(
            'Привет, $username',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCarForm()),
                    );
                  },
                  child: const Text('Я хочу сдавать машину в аренду'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RentCarPage()),
                    );
                  },
                  child: const Text('Я хочу снять машину'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: RegisteredContent(),
  ));
}
