# Vodič: reciklirajući pogledi i Flutter

Ovaj vodič objašnjava **princip**, a zatim ga povezuje s [demonstracijskom aplikacijom](../lib/main.dart). Namijenjen je nekome tko još nije radio s reciklirajućim pogledima.

## 1. Koji problem pokušavamo riješiti?

Zamisli aplikaciju s popisom od **10 000 proizvoda**. Na mobitelu istovremeno vidiš možda pet ili šest redaka. Kad bismo za svaki proizvod unaprijed izrađivali skup vizualnih elemenata, trošili bismo vrijeme i memoriju na sadržaj koji nije vidljiv.

Zato sustavi za prikaz velikih popisa koriste pristupe koji **ne izrađuju sve vidljive komponente unaprijed**, nego rade samo ono što je potrebno za aktualni dio prikaza.

Važno je razlikovati dva mehanizma:

- **Recikliranje prikaza**: postojeći vizualni objekt ponovno se koristi za prikaz druge stavke.
- **Lijena izgradnja (*lazy building*)**: element se izgrađuje kada zatreba, umjesto da se cijeli popis izgradi unaprijed.

Cilj je sličan, ali to nisu isti postupci.

## 2. Kako radi Androidov RecyclerView?

Androidov `RecyclerView` služi za učinkovito prikazivanje dugih popisa i mreža. Njegove osnovne komponente su:

| Komponenta | Zadatak |
| --- | --- |
| `RecyclerView` | Prikazuje sadržaj koji se može pomicati |
| `LayoutManager` | Određuje raspored (npr. vertikalna lista ili mreža) |
| `Adapter` | Povezuje podatke s elementima prikaza |
| `ViewHolder` | Drži reference na vizualne elemente pojedine stavke |

### Primjer postupka

Pretpostavimo da su na zaslonu vidljivi proizvodi **A, B i C**.

```text
POČETNO STANJE             NAKON POMAKA PREMA DOLJE

┌──────────────────┐       ┌──────────────────┐
│ Prikaz 1 → A     │       │ Prikaz 2 → B     │
│ Prikaz 2 → B     │  →    │ Prikaz 3 → C     │
│ Prikaz 3 → C     │       │ Prikaz 1 → D     │
└──────────────────┘       └──────────────────┘

Pojednostavljen prikaz: prikaz koji više nije vidljiv
može se ponovno povezati s podacima proizvoda D.
```

Kad prikaz za A izađe iz vidljivog dijela, Android ga može staviti u skup za ponovno korištenje. Kada treba prikazati D, `Adapter` može povezati postojeći `ViewHolder` s novim podacima umjesto da uvijek stvara potpuno novi pogled.

Točan broj izrađenih prikaza i trenutak njihove ponovne uporabe ovise o implementaciji i pomicanju; dijagram prikazuje **ideju**, a ne doslovno interno stanje.

## 3. Što radi Flutter?

Flutter **ne koristi Androidov RecyclerView i ViewHolder** za svoje standardne widgete.

U ovom projektu koriste se:

- `ListView.builder`: lijeno izgrađuje retke liste.
- `GridView.builder`: lijeno izgrađuje ćelije mreže.

U oba slučaja graditelju prosljeđujemo funkciju `itemBuilder`. Flutter je poziva za pojedine indekse kada su mu elementi potrebni za raspored i prikaz.

Ne treba zaključiti da u svakom trenutku postoji točno onoliko elemenata koliko se vidi na zaslonu. Flutter može izraditi i elemente u području predmemorije, a dio stanja može se zadržati ovisno o postavkama i životnom ciklusu.

### Usporedba

| | Android RecyclerView | Flutter `ListView.builder` / `GridView.builder` |
| --- | --- | --- |
| Osnovni pristup | Ponovna uporaba postojećih prikaza | Lijena izgradnja stavki |
| Povezivanje s podacima | `Adapter` i `ViewHolder` | Funkcija `itemBuilder` |
| Raspored | `LayoutManager` | Parametri liste / `gridDelegate` |
| Cilj | Učinkovit dugi popis | Učinkovit dugi popis ili mreža |

**Zaključak:** nije točno reći da Flutterov `ListView.builder` interno radi kao Androidov `RecyclerView`. Ispravno je reći da rješavaju **sličan problem različitim mehanizmima**.

## 4. Prati podatke kroz aplikaciju

U datoteci [`lib/main.dart`](../lib/main.dart) nalaze se svi dijelovi demonstracije.

### Korak A: Podaci

```dart
class Produkt {
  final String naziv;
  final int cijena;

  Produkt(this.naziv, this.cijena);
}
```

Poziv `Produkt('Laptop', 800)` stvara objekt sa svojstvima `naziv` i `cijena`. U listi `proizvodi` pohranjeni su svi testni proizvodi.

**Zašto model?** Da se naziv i cijena jednoga proizvoda ne moraju usklađivati između dviju odvojenih lista.

### Korak B: Lista

```dart
ListView.builder(
  itemCount: proizvodi.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(proizvodi[index].naziv),
      subtitle: Text('Cijena: ${proizvodi[index].cijena} kn'),
    );
  },
)
```

- `itemCount`: broj proizvoda u listi.
- `itemBuilder`: opisuje kako napraviti redak za određeni indeks.
- `index`: broj stavke, od `0` do `proizvodi.length - 1`.
- `proizvodi[index]`: konkretan proizvod koji se prikazuje.

`context` predstavlja kontekst izgradnje u Flutterovu stablu elemenata; u ovom primjeru nije izravno korišten.

### Korak C: Mreža

```dart
gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
),
```

Mreža koristi isti izvor podataka, ali ih raspoređuje u **dva stupca**. `Card` daje izgled kartice, a `Column` slaže naziv i cijenu jedan ispod drugoga.

Promjena s `crossAxisCount: 2` na `3` promijenila bi broj stupaca, ali ne i sadržaj liste `proizvodi`.

### Korak D: Tablica

`DataTable` ima stupce definirane preko `DataColumn`, a retke preko `DataRow` i `DataCell`.

U projektu se retci izrađuju izrazom:

```dart
rows: List.generate(proizvodi.length, (index) {
  return DataRow(cells: [
    DataCell(Text(proizvodi[index].naziv)),
    DataCell(Text('${proizvodi[index].cijena} kn')),
  ]);
}),
```

Ovdje je bitno uočiti razliku: `List.generate` stvara popis svih `DataRow` objekata. **To nije lijena izgradnja redaka poput `ListView.builder`.**

`SingleChildScrollView` s vodoravnim smjerom omogućuje pomicanje tablice ako je šira od dostupnog prostora. `ListView` i `GridView` već imaju ugrađen mehanizam pomicanja.

### Korak E: Korisnik mijenja prikaz

```dart
onChanged: (vrijednost) {
  if (vrijednost != null) {
    setState(() {
      odabraniPrikaz = vrijednost;
    });
  }
},
```

Svaka stavka padajućeg izbornika ima vlastiti `value` (`lista`, `mreza` ili `tablica`). Kada korisnik odabere stavku, Flutter poziva `onChanged` i prosljeđuje odabrani `value`.

`setState` označava promjenu stanja. Nakon toga izraz `switch (odabraniPrikaz)` određuje hoće li se prikazati lista, mreža ili tablica.

## 5. Zašto StatefulWidget?

`MyApp` je `StatelessWidget` jer u ovom primjeru samo postavlja `MaterialApp`.

`HomePage` je `StatefulWidget` jer treba **pamtiti odabrani način prikaza**. Podatak `odabraniPrikaz` nalazi se u klasi `_HomePageState`, a `setState` služi za obavještavanje Fluttera o njegovoj promjeni.

Za veće aplikacije preporučuje se snažnije razdvajanje UI i podatkovne logike. U ovom primjeru nema baze ni mrežnih poziva, pa je lokalno stanje dovoljno za demonstraciju.

## 6. Dizajn: kada koji prikaz koristiti?

- **Lista**: kada korisnik pregledava veći broj stavki i želi brzo pročitati naziv i dodatni podatak.
- **Mreža**: kada su pojedine stavke samostalne kartice i važna je usporedba više njih na zaslonu.
- **Tablica**: kada su bitni stupci i usporedba atributa; na uskom zaslonu može zahtijevati vodoravno pomicanje.
- **Padajući izbornik**: kada korisnik bira jednu od nekoliko opcija, a ne treba ih sve stalno prikazivati.

Pri oblikovanju treba paziti na čitljiv tekst, dovoljne razmake, dodirne površine, kontrast i prilagodbu različitim širinama ekrana.

## 7. Pitanja za provjeru razumijevanja

**1. Je li `DataTable` u projektu reciklirajući pogled?**  
Nije. Svi retci nastaju pozivom `List.generate`.

**2. Što je glavna prednost `ListView.builder`?**  
Ne mora unaprijed izgraditi sve stavke dugog popisa; elemente izgrađuje prema potrebi.

**3. Što radi `gridDelegate`?**  
Upravlja rasporedom ćelija mreže, uključujući broj stupaca u ovom primjeru.

**4. Zašto se poziva `setState`?**  
Zato što se promijenio `odabraniPrikaz` i Flutter treba ponovno izgraditi odgovarajući dio sučelja.

**5. Jesu li `RecyclerView` i `ListView.builder` ista tehnologija?**  
Nisu. Androidov `RecyclerView` ima sustav recikliranja prikaza s `ViewHolder` objektima, dok Flutter koristi vlastiti sustav widgeta i lijenu izgradnju.

## Literatura

- [Android Developers – RecyclerView](https://developer.android.com/develop/ui/views/layout/recyclerview)
- [Flutter: Work with long lists](https://docs.flutter.dev/cookbook/lists/long-lists)
- [Flutter API – ListView.builder](https://api.flutter.dev/flutter/widgets/ListView/ListView.builder.html)
- [Flutter API – GridView.builder](https://api.flutter.dev/flutter/widgets/GridView/GridView.builder.html)
- [Flutter API – DataTable](https://api.flutter.dev/flutter/material/DataTable-class.html)
- [Flutter – arhitekturne smjernice](https://docs.flutter.dev/app-architecture/guide)
- FOI, RAMPU – nastavni materijal **III. RecyclerView i napredniji prikaz podataka** (Mislav Matijević, 2022.)

[Natrag na početnu stranicu repozitorija](../README.md).
