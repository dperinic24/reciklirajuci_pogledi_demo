import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}
class Produkt{
  final String naziv;
  final int cijena;
 

  Produkt(this.naziv, this.cijena);
}

class HomePage extends StatefulWidget { //daje dinamičnost stranici 
  const HomePage({super.key});

  @override 
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String odabraniPrikaz = 'lista';
       final List<Produkt> proizvodi = [  
        Produkt('Laptop', 800),  
        Produkt('Mobitel', 500),
        Produkt('Tablet', 300),
        Produkt('Monitor', 200),
        Produkt('Tipkovnica', 80),
        Produkt('Miš', 40),
        Produkt('Slušalice', 120),
        Produkt('Televizor', 900),
        Produkt('Printer', 340),
        Produkt('Zvučnik', 250),
        Produkt('Gaming konzola', 1000),
        Produkt('Earbuds', 110),
        Produkt('Satelit', 600),
        Produkt('Novčanik', 90),
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
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                    Text(proizvodi[index].naziv),
                    Text('${proizvodi[index].cijena} kn'),
                  ],
                 ),
                );
              },
            ),
            'lista'=>  ListView.builder(
              itemCount: proizvodi.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text(proizvodi[index].naziv),
                  subtitle: Text('Cijena: ${proizvodi[index].cijena} kn'),
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
                DataCell(Text(proizvodi[index].naziv)),
                DataCell(Text('${proizvodi[index].cijena} kn')),
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

