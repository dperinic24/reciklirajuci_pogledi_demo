import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool prikaziMrezu = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: const Text('Katalog proizvoda'),
             actions: [
              IconButton(
                icon: Icon(
                  prikaziMrezu ? Icons.list : Icons.grid_view,
                ),
                onPressed: (){
                  setState((){
                    prikaziMrezu = !prikaziMrezu;
                  });
                },
              ),
            ],
            ),
            
            body: prikaziMrezu
            ? GridView.builder(
              itemCount: proizvodi.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index){
                return Card(
                  child:Center(
                    child:Text(proizvodi[index])
                  ),
                );
              },
            )
            : ListView.builder(
              itemCount: proizvodi.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text(proizvodi[index]),
                  subtitle: Text('Cijena: ${cijene[index]} kn'),
                );
              },
          ),
       );
  }
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});

   @override
   Widget build(BuildContext context) {


     
     return MaterialApp(
       title: 'Katalog proizvoda',
       theme: ThemeData(
         primarySwatch: Colors.blue,
       ),
       home: const HomePage(),
       
     );
   }
 }

