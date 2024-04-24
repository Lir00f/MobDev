import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final pricePerDayFormatted = NumberFormat('#,##0', 'ru_RU').format(widget.data['pricePerDay']);
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
        title: Text(
          '${widget.data['brand']} ${widget.data['model']}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      Text(
                        '$pricePerDayFormatted ₽ в сутки',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        '${widget.data['brand']} ${widget.data['model']}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFeatureTile('Расход', 'Расход по городу: ${widget.data['cityMileage']} л. на 100 км.\nРасход по трассе: ${widget.data['highwayMileage']} л. на 100 км.\nСмешанный расход: ${widget.data['mixedMileage']} л. на 100 км.'),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: _buildFeatureTile('Двигатель', '${widget.data['horsepower']} л.с. при ${widget.data['rpm']} об/мин\n${widget.data['torque']} Н∙м при ${widget.data['torqueRpm']} об/мин'),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: _buildFeatureTile('Коробка передач','${widget.data['transmissionType']}\n${widget.data['transmissionSpeed']}'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Описание:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      Text(
                        '${widget.data['description']}',
                      ),
                    ],
                  ),
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

  Widget _buildFeatureTile(String title, String subtitle) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8.0),
          Text(subtitle),
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
