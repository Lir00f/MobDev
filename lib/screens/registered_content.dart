import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
              MaterialPageRoute(builder: (context) => RentCarPage()),
            );
          },
          child: Text('Я хочу снять машину'),
        ),
      ],
    );
  }
}



class RentCarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Снять машину'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('cars').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Ошибка: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return CarCard(data: data);
            }).toList(),
          );
        },
      ),
    );
  }
}

class CarCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const CarCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(data['brand'] + ' ' + data['model']),
        subtitle: Text('Пробег: ${data['mileage']} км'),
        trailing: ElevatedButton(
          onPressed: () {
            // Implement functionality to rent the car
          },
          child: Text('Собрать в аренду'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RegisteredContent(),
  ));
}
