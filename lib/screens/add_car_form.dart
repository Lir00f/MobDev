import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Add Car Form'),
      ),
      body: AddCarForm(), // Помещаем ваш виджет AddCarForm внутрь Scaffold
    ),
  ));
}

class AddCarForm extends StatefulWidget {
  @override
  _AddCarFormState createState() => _AddCarFormState();
}

class _AddCarFormState extends State<AddCarForm> {
  List<XFile> _images = []; // Список для хранения выбранных фотографий

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source); // Используем pickImage вместо getImage
    if (pickedImage != null) {
      setState(() {
        _images.add(pickedImage); // Добавляем выбранную фотографию в список
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Марка модель'),
          ),
          // Виджет для отображения выбранных фотографий
          Column(
            children: _images.map((image) {
              return Image.file(File(image.path)); // Для отображения используем Image.file
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () {
              // Вызываем метод для выбора фотографии из галереи
              _pickImage(ImageSource.gallery);
            },
            child: Text('Выбрать фотографию'),
          ),
          ElevatedButton(
            onPressed: () {
              // Добавление машины
            },
            child: Text('Добавить машину'),
          ),
        ],
      ),
    );
  }
}
