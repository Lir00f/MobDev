import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> signOut() async {
    final navigator = Navigator.of(context);

    await FirebaseAuth.instance.signOut();

    navigator.pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  Future<List<Map<String, dynamic>>> getRentedCars() async {
    final user = FirebaseAuth.instance.currentUser;
    final rentalDocs = await FirebaseFirestore.instance.collection('rentals')
        .where('email', isEqualTo: user?.email)
        .get();

    List<Map<String, dynamic>> rentedCars = [];
    rentalDocs.docs.forEach((doc) {
      rentedCars.add({...doc.data(), 'id': doc.id});
    });

    return rentedCars;
  }

  Future<void> deleteRental(String rentalId) async {
    try {
      await FirebaseFirestore.instance.collection('rentals').doc(rentalId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Заявка на аренду удалена успешно'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Ошибка при удалении заявки на аренду: $e'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getRentedCars(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        } else {
          final rentedCars = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Аккаунт'),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Выйти из аккаунта',
                  onPressed: () => signOut(),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Ваш Email: ${user?.email}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  if (rentedCars.isEmpty)
                    Text(
                      'У вас нет взятых в аренду автомобилей',
                      style: TextStyle(fontSize: 16),
                    )
                  else
                    ...rentedCars.map((car) {
                      final startDate = (car['startDate'] as Timestamp).toDate();
                      final endDate = (car['endDate'] as Timestamp).toDate();
                      final carName = car['carName'];
                      final rentalId = car['id'];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Машина: $carName',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text('Дата начала аренды: ${DateFormat('dd.MM.yyyy').format(startDate)}'),
                              Text('Дата окончания аренды: ${DateFormat('dd.MM.yyyy').format(endDate)}'),
                              SizedBox(height: 8),
                              Text(
                                'Можно оплатить и забрать на нашем автопарке по адресу: ул. Джеппар Акима 36',
                                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => deleteRental(rentalId),
                                child: Text('Удалить заявку'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => signOut(),
                    child: const Text('Выйти из аккаунта'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
