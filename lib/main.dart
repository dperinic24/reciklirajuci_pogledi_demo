import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class HomePage extends StatefulWidget { //daje dinamičnost stranici 
  const HomePage({super.key});

  @override 
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String odabraniPrikaz = 'lista';
       final List<String> proizvodi = [ //tu se dodaju stvari da se prikazu preko listview
  'Laptop',
  'Mobitel',
  'Tablet',
  'Monitor',
];

final List<int> cijene = [ //i tu
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
              DropdownButton<String>(
                onChanged: (vrijednost) {
                  if (vrijednost != null) {    
                    setState(() {
                      odabraniPrikaz = vrijednost;    
                      });  
                    }
                  },
                value:odabraniPrikaz,
                items: const[
                  DropdownMenuItem(
                    value:'lista',
                    child:Text('Lista'),
                  ),
                  DropdownMenuItem(
                    value:'mreza',
                    child:Text('Mreža'),
                  ),
                  DropdownMenuItem(
                    value:'tablica',
                    child:Text('Tablica'),
                  ),
                ],
              ),
            ],
            ),
            
            body: switch(odabraniPrikaz){
            'mreza'=> GridView.builder(
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
            ),
            'lista'=>  ListView.builder(
              itemCount: proizvodi.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text(proizvodi[index]),
                  subtitle: Text('Cijena: ${cijene[index]} kn'),
                );
              },
          ),
          'tablica'=>SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                  DataColumn(label: Text('Proizvod')),
                  DataColumn(label: Text('Cijena')),
              ],
              rows: List.generate(proizvodi.length, (index){
                return DataRow(cells: [
                DataCell(Text(proizvodi[index])),
                DataCell(Text('Cijena: ${cijene[index]} kn')),
                ],
               );
              }),
            ),
          ),
          _ => const Center(
            child: Text('Nepoznat prikaz'),
          ),
      }, 
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

