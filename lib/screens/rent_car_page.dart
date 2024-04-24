import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RentCarPage extends StatelessWidget {
  const RentCarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Снять машину'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('cars').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Ошибка: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
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

  const CarCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> base64Images = List<String>.from(data['base64Images'] ?? []);
    List<Image> images = base64Images.map((base64String) {
      Uint8List bytes = base64.decode(base64String);
      return Image.memory(bytes);
    }).toList();

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(data['brand'] + ' ' + data['model']),
            subtitle: Text('Пробег: ${data['mileage']} км'),
            trailing: ElevatedButton(
              onPressed: () {
                // Implement functionality to rent the car
              },
              child: const Text('Больше информации'),
            ),
          ),
          SizedBox(
            height: 200, // Set height according to your needs
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: images[index],
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
