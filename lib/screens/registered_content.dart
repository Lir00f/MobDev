import 'package:flutter/material.dart';
import 'add_car_form.dart';
import 'rent_car_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisteredContent extends StatelessWidget {
  const RegisteredContent({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';
    final username = email.isNotEmpty ? email.split('@')[0] : '';

    Future<void> showUsernameSnackBar(BuildContext context, String username) async {
      final snackBar = SnackBar(
        content: Text('Привет, $username'),
        duration: Duration(seconds: 5),
        padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showUsernameSnackBar(context, username);
    });

    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
    Center(
    child: Column(
    children: [
      Image.asset(
      'assets/images/logo.png',
      height: 100.0,
      width: 150.0,
      fit: BoxFit.contain,
    ),
    SizedBox(height: 2),
    Text(
    'Drivly',
    style: TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w900,
    color: Colors.black,
    fontFamily: 'Roboto',
    ),
    ),
    SizedBox(height: 3),
    Container(
    height: 270.0,
    width: double.infinity,
    child: Image.asset(
    'assets/images/priora.png',
    fit: BoxFit.cover,
    ),
    ),
    SizedBox(height: 20),
    Text(
    'Ваш гид в аренде',
    style: TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    ),
    ),
    Text(
    'автомобиля в Крыму',
    style: TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(height: 10),
    Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Text(
    'Наш сервис для аренды автомобилей предлагает широкий выбор транспортных средств для любых целей и бюджетов.',
    style: TextStyle(
    fontSize: 16.0,
    fontStyle: FontStyle.italic,
    ),
    textAlign: TextAlign.center,
    ),
    ),
    ],
    ),
    ),
    SizedBox(height: 20),
    ElevatedButton(
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddCarForm()),
    );
    },
    style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
    ),
    child: Text(
    'Я хочу сдавать машину в аренду',
    style: TextStyle(color: Colors.white),
    ),
    ),
    SizedBox(height: 10),
    ElevatedButton(
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => RentCarPage()),
    );
    },
    style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
    ),
    child: Text(
    'Я хочу взять машину в аренду',
    style: TextStyle(color: Colors.white),
    ),

    ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RegisteredContent(),
  ));
}
