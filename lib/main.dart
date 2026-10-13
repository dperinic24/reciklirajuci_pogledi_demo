import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
   const MyApp({super.key});

   @override
   Widget build(BuildContext context) {
     final List<String> proizvodi = [
  'Laptop',
  'Mobitel',
  'Tablet',
  'Monitor',
];

final List<int> cijene = [
  800,
  500,
  300,
  200,
];
     
     return MaterialApp(
       title: 'Katalog proizvoda',
       theme: ThemeData(
         primarySwatch: Colors.blue,
       ),
       home: 
       Scaffold(
          appBar: AppBar(
            title: const Text('Katalog proizvoda'),
            ),
            body: ListView.builder(
              itemCount: proizvodi.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text(proizvodi[index]),
                  subtitle: Text('Cijena: ${cijene[index]} kn'),
                );
              },
          ),
       ),
     );
  }
}
