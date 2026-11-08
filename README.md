# Prikaz podataka u reciklirajućim pogledima – Flutter demo

Seminarski primjer za kolegij **Razvoj aplikacija za mobilne i pametne uređaje (RAMPU)**. Projekt prikazuje kako se **isti podaci** mogu prikazati na nekoliko načina: kao **lista**, **mreža kartica** i **tablica**. Primjer je napisan u **Dartu i Flutteru**, a svi proizvodi su unaprijed definirani u kodu.

> **Odakle početi?** Ako prvi put susrećeš pojam *reciklirajućih pogleda*, najprije pročitaj [kratki vodič kroz princip rada](docs/reciklirajuci-pogledi.md), a zatim pokreni aplikaciju i usporedi tri prikaza.

## Što su reciklirajući pogledi?

Zamisli popis s 10 000 proizvoda. Na zaslon mobitela istodobno stane samo nekoliko stavki. Nije učinkovito unaprijed napraviti 10 000 vizualnih redaka ako ih korisnik ne vidi.

U **Androidovu RecyclerViewu** prikazi koji izađu iz vidljivog područja mogu se **ponovno upotrijebiti** za druge podatke. Mehanizam se temelji na komponentama **RecyclerView**, **Adapter**, **ViewHolder** i **LayoutManager**. To se u užem smislu naziva *recikliranje prikaza*.

**Flutter to ne izvodi istim Androidovim mehanizmom.** Flutterovi `ListView.builder` i `GridView.builder` koriste *lijenu izgradnju* (*lazy building*): graditelji se pozivaju za elemente koji su potrebni tijekom prikaza i pomicanja. Flutter upravlja životnim ciklusom tih elemenata. Zajednički cilj obaju pristupa jest **izbjeći nepotreban posao kod dugih popisa**, ali implementacije nisu identične.

Više detalja, dijagram i razliku između *recyclinga* i *lazy buildinga* možeš pronaći u [vodiču](docs/reciklirajuci-pogledi.md).

## Što aplikacija prikazuje?

| Način prikaza | Flutter widget | Kada je koristan? |
| --- | --- | --- |
| **Lista** | `ListView.builder` + `ListTile` | Za pregledavanje niza stavki, jednu ispod druge |
| **Mreža** | `GridView.builder` + `Card` | Za usporedbu više kartica u redovima i stupcima |
| **Tablica** | `DataTable` | Kada podatke treba uspoređivati po stupcima |
| **Odabir prikaza** | `DropdownButton` | Za prebacivanje između liste, mreže i tablice |

**Važno:** `DataTable` u ovom primjeru **nije reciklirajući prikaz**. Njegovi se retci stvaraju pozivom `List.generate` za sve proizvode. Ovdje je uključen zbog usporedbe s listom i mrežom.

### Kako isprobati primjer

1. Pokreni aplikaciju **Katalog proizvoda**.
2. Na vrhu zaslona odaberi **Lista**. Promatraj proizvode raspoređene okomito.
3. Odaberi **Mreža**. Isti proizvodi prikazat će se u karticama, po dvije u redu.
4. Odaberi **Tablica**. Isti nazivi i cijene prikazuju se u dva stupca.
5. Pomakni listu ili mrežu i obrati pozornost na to da sadržaj može biti dulji od zaslona.

## Pokretanje projekta

Potrebni su instalirani **Flutter SDK**, **Dart** (dolazi s Flutterom), uređivač poput **VS Codea** ili **Android Studija** i emulator ili povezan fizički uređaj.

U terminalu:

```bash
git clone https://github.com/dperinic24/reciklirajuci_pogledi_demo.git
cd reciklirajuci_pogledi_demo
flutter pub get
flutter run
```

Ako nema dostupnog uređaja, provjeri postavke naredbama `flutter doctor` i `flutter devices`.

## Gdje se što nalazi u kodu?

Glavni dio demonstracije je u **[`lib/main.dart`](lib/main.dart)**. Projekt namjerno zadržava jednostavnu strukturu kako bi bilo lakše pratiti gradivo.

| Dio koda | Uloga |
| --- | --- |
| `class Produkt` | Model podataka s nazivom i cijenom |
| `List<Produkt> proizvodi` | Demo podaci zadani izravno u kodu |
| `MyApp extends StatelessWidget` | Postavlja `MaterialApp` i početnu stranicu |
| `HomePage extends StatefulWidget` | Omogućuje promjenjivi prikaz |
| `odabraniPrikaz` | Pamti koja je opcija odabrana |
| `DropdownButton.onChanged` | Prima novi izbor i poziva `setState` |
| `switch (odabraniPrikaz)` | Odabire odgovarajući prikaz |
| `ListView.builder` | Gradi stavke liste prema potrebi |
| `GridView.builder` | Gradi stavke mreže prema potrebi |
| `DataTable` | Prikazuje podatke u stupcima i recima |

### 1. Model podataka

```dart
class Produkt {
  final String naziv;
  final int cijena;

  Produkt(this.naziv, this.cijena);
}
```

Svaki `Produkt` sadrži povezane podatke o jednom proizvodu. Zahvaljujući tome, isti objekt možemo koristiti u svim prikazima bez izrade odvojenih lista naziva i cijena.

### 2. Lista i `itemBuilder`

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

- `itemCount` kaže koliko stavki postoji.
- `itemBuilder` je funkcija koju Flutter poziva kada treba izgraditi stavku.
- `index` je njezin indeks u listi (prva stavka ima indeks `0`).
- `ListTile` određuje izgled pojedinog retka.

### 3. Mreža i `gridDelegate`

```dart
GridView.builder(
  itemCount: proizvodi.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
  ),
  itemBuilder: (context, index) {
    return Card(
      child: Center(child: Text(proizvodi[index].naziv)),
    );
  },
)
```

`gridDelegate` određuje pravila rasporeda. `crossAxisCount: 2` ovdje znači **dva stupca**, a `itemBuilder` određuje sadržaj svake kartice. Ovo je **skraćeni isječak** radi objašnjenja; stvarni kod prikazuje i cijenu.

### 4. Promjena prikaza pomoću `setState`

```dart
onChanged: (vrijednost) {
  if (vrijednost != null) {
    setState(() {
      odabraniPrikaz = vrijednost;
    });
  }
},
```

Korisnik bira stavku iz `DropdownButton` izbornika. Flutter poziva predanu funkciju `onChanged` i prosljeđuje `value` odabrane opcije (`'lista'`, `'mreza'` ili `'tablica'`). `setState` obavještava Flutter da treba ponovno izgraditi prikaz. Izraz `switch` zatim odabire odgovarajući widget.

## Ograničenja demonstracije

- Podaci su **demo podaci** – nema baze podataka ni dohvaćanja preko interneta.
- Nema dodavanja, brisanja ni uređivanja proizvoda.
- Mreža ima **fiksna dva stupca**; u stvarnoj bi aplikaciji trebalo razmotriti prilagodbu širini zaslona.
- `DataTable` izgrađuje sve retke unaprijed i zato nije prikladan za vrlo velike skupove podataka bez dodatnih prilagodbi.
- Ovdje se koristi jednostavno lokalno stanje `StatefulWidget` + `setState`, a ne složenija arhitektura s odvojenim ViewModelom i repozitorijem podataka.

## Za daljnje učenje

- [Vodič: Što su reciklirajući pogledi i kako radi ovaj projekt?](docs/reciklirajuci-pogledi.md)
- [Službena dokumentacija: Flutter – Lists](https://docs.flutter.dev/cookbook/lists/long-lists)
- [Flutter API: ListView](https://api.flutter.dev/flutter/widgets/ListView-class.html)
- [Flutter API: GridView](https://api.flutter.dev/flutter/widgets/GridView-class.html)
- [Flutter API: DataTable](https://api.flutter.dev/flutter/material/DataTable-class.html)
- [Flutter – preporučena arhitektura aplikacija](https://docs.flutter.dev/app-architecture/guide)
- [Android Developers – RecyclerView](https://developer.android.com/develop/ui/views/layout/recyclerview)

**Autor:** Duje Perinić · Seminarski projekt RAMPU
