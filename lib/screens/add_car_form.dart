import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCarForm extends StatefulWidget {
  @override
  _AddCarFormState createState() => _AddCarFormState();
}

class _AddCarFormState extends State<AddCarForm> {
  List<File> _images = [];
  String _brand = '';
  String _model = '';
  String _mileage = '';
  double _pricePerDay = 0.0;
  bool _insurance = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _images.add(File(pickedImage.path));
      });
    }
  }

  Future<void> _confirmDeleteImage(int index) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Подтвердите удаление'),
          content: Text('Вы уверены, что хотите удалить это фото?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Удалить'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Отмена'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _images.removeAt(index);
      });
    }
  }

  Future<void> _addCarToFirebase() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String userId = 'user123';
      await firestore.collection('cars').add({
        'brand': _brand,
        'model': _model,
        'mileage': _mileage,
        'pricePerDay': _pricePerDay,
        'insurance': _insurance,
        'userId': userId,
      });
      setState(() {
        _brand = '';
        _model = '';
        _mileage = '';
        _pricePerDay = 0.0;
        _insurance = false;
        _images.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Машина успешно добавлена в базу данных'),
      ));
    } catch (error) {
      print('Error adding car: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Ошибка при добавлении машины в базу данных'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Car Form'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Марка'),
              onChanged: (value) {
                setState(() {
                  _brand = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Модель'),
              onChanged: (value) {
                setState(() {
                  _model = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Пробег'),
              onChanged: (value) {
                setState(() {
                  _mileage = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  child: Text('Выбрать фото'),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_images.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              _confirmDeleteImage(index);
                            },
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundImage: FileImage(_images[index]),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Цена за день'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _pricePerDay = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: _insurance,
                  onChanged: (value) {
                    setState(() {
                      _insurance = value ?? false;
                    });
                  },
                ),
                Text('Есть страховка общая?'),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _insurance ? _addCarToFirebase : null,
              child: Text('Добавить машину'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: AddCarForm(),
  ));
}
