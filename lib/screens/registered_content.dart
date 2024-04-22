import 'package:flutter/material.dart';
import 'add_car_form.dart';

class RegisteredContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Контент для ЗАРЕГИСТРИРОВАННЫХ в системе'),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCarForm()),
            );
          },
          child: Text('Я хочу сдавать машину в аренду'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCarForm()),
            );
          },
          child: Text('Я хочу снять машину'),
        ),
      ],
    );
  }
}
