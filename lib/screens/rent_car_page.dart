import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'car_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RentCarPage extends StatelessWidget {
  const RentCarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Снять машину'),
      ),
      body: SingleChildScrollView( // Обернули Scaffold в SingleChildScrollView
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('cars').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Ошибка: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

            final myCars = <DocumentSnapshot>[];
            final otherCars = <DocumentSnapshot>[];

            snapshot.data!.docs.forEach((DocumentSnapshot document) {
              final data = document.data() as Map<String, dynamic>; // Explicit cast to Map<String, dynamic>
              if (data["userId"] == currentUserEmail) {
                myCars.add(document);
              } else {
                otherCars.add(document);
              }
            });

            Widget myCarsWidget = SizedBox.shrink();
            if (myCars.isNotEmpty) {
              myCarsWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Мои машины на аренду',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: myCars.map((DocumentSnapshot document) {
                      return CarCard(data: document.data() as Map<String, dynamic>);
                    }).toList(),
                  ),
                ],
              );
            }

            Widget otherCarsWidget = SizedBox.shrink();
            if (otherCars.isNotEmpty) {
              otherCarsWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Машины других пользователей',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: otherCars.map((DocumentSnapshot document) {
                      return CarCard(data: document.data() as Map<String, dynamic>);
                    }).toList(),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myCarsWidget,
                otherCarsWidget,
              ],
            );
          },
        ),
      ),
    );
  }
}

class CarCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const CarCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> base64Images = List<String>.from(data['base64Images'] ?? []);
    List<Widget> imageWidgets = base64Images.map((base64String) {
      Uint8List bytes = base64.decode(base64String);
      return Expanded(
        child: Image.memory(bytes, fit: BoxFit.cover),
      );
    }).toList();

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(data['brand'] + ' ' + data['model']),
            subtitle: Text('Пробег: ${data['mileage']} км'),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CarDetailsPage(data: data)),
                );
              },
              child: const Text('Больше информации'),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageWidgets.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: imageWidgets[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RentCarPage(),
  ));
}
