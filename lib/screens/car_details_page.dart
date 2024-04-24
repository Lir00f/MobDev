import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CarDetailsPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const CarDetailsPage({super.key, required this.data});

  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    List<String> base64Images = List<String>.from(widget.data['base64Images'] ?? []);
    List<Widget> imageWidgets = base64Images.map((base64String) {
      Uint8List bytes = base64.decode(base64String);
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: Image.memory(bytes),
                ),
              );
            },
          );
        },
        child: Image.memory(bytes, fit: BoxFit.cover),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['brand'] + ' ' + widget.data['model']),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: PageView(
                    children: imageWidgets,
                  ),
                ),
                ListTile(
                  title: Text('Пробег: ${widget.data['mileage']} км'),
                ),
                ListTile(
                  title: Text('Год выпуска: ${widget.data['year']}'),
                ),
                ListTile(
                  title: Text('Мотор: ${widget.data['engine']}'),
                ),
                ListTile(
                  title: Text('Описание: ${widget.data['description']}'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _selectDateRange(context);
              },
              child: Text('Взять в аренду'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedStartDate != null) {
      final DateTime? pickedEndDate = await showDatePicker(
        context: context,
        initialDate: pickedStartDate,
        firstDate: pickedStartDate,
        lastDate: DateTime(DateTime.now().year + 1),
      );

      if (pickedEndDate != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Подтвердите аренду'),
              content: Text('Вы действительно хотите взять в аренду ${widget.data['brand']} ${widget.data['model']} на срок с ${_formatDate(pickedStartDate)} по ${_formatDate(pickedEndDate)}?'),
              actions: [
                TextButton(
                  onPressed: () {
                    // Отмена аренды
                    Navigator.of(context).pop();
                  },
                  child: Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Подтверждение аренды
                    _confirmRent(pickedStartDate, pickedEndDate);
                    Navigator.of(context).pop();
                  },
                  child: Text('Подтвердить'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _confirmRent(DateTime startDate, DateTime endDate) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseFirestore.instance.collection('rentals').add({
        'email': user.email,
        'startDate': startDate,
        'endDate': endDate,
        'carName': '${widget.data['brand']} ${widget.data['model']}',
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
