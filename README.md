# Flutter – Ringkasan Konsep Proyek

## 1. Apa itu Widget Tree dan hubungan Parent–Child?
- **Widget tree** adalah struktur hierarki dari semua widget yang membentuk UI. Setiap widget berada di dalam widget lain (nested) membentuk pohon.
- **Parent (induk)** adalah widget yang membungkus widget lain; **child (anak)** adalah widget yang dibungkus.  
- **Properti & Constraints mengalir ke bawah**, sedangkan **event & data (lifted state) mengalir ke atas** lewat callback/state management.
- Pada saat render:
  - Parent memberikan **constraints** ke child.
  - Child memilih **ukuran** sesuai constraints lalu mengembalikan **size** ke parent.
  - Parent **meletakkan** child pada layout.

---

## 2. Daftar Widget yang Digunakan & Fungsinya


## Klasifikasi Widget & Fungsinya

| Widget | Jenis | Fungsi Singkat |
|---|---|---|
| `MyApp` | StatelessWidget | Entry point UI yang membungkus aplikasi dengan `MaterialApp` dan mengatur tema/halaman awal. |
| `MaterialApp` | StatefulWidget | Menyediakan kerangka Material (tema, navigator/routes, localization), root context untuk widget Material lain. |
| `ThemeData` | Kelas konfigurasi | Objek konfigurasi tema global: warna (`ColorScheme`), tipografi, shape, dsb. Dipasangkan ke `MaterialApp.theme`. |
| `Scaffold` | StatefulWidget | Kerangka tiap layar: menampung `AppBar`, `body`, `floatingActionButton`, `drawer`, `SnackBar` via `ScaffoldMessenger`. |
| `AppBar` | StatefulWidget | Bilah atas layar untuk judul, aksi, dan navigasi (leading/back). |
| `Menu` | StatelessWidget | Halaman/menu daftar aksi (mis. “See Football News”, “Add News”, “Logout”); konten statis tanpa state internal. |


---

## 3) Fungsi MaterialApp dan mengapa sering jadi root MaterialApp:
- Menyediakan **material design scaffolding** (tema, typografi, ikon).
- Memuat **navigator** & pengelolaan **route** (`routes`, `onGenerateRoute`, `initialRoute`).
- Menyediakan **localizations**, **text direction**, **theme**, **dark mode**.
- Mengatur **title**, **debug banner**, **home**.

**Mengapa jadi root?**  
Karena banyak widget Material (mis. `Scaffold`, `AppBar`, `SnackBar`) **membutuhkan konteks Material**. Menjadikan `MaterialApp` sebagai root menjamin seluruh subtree memiliki akses ke tema, navigator, dan resource Material.

---

## 4. Perbedaan StatelessWidget vs StatefulWidget, Kapan dipilih?

| Aspek | StatelessWidget | StatefulWidget |
|---|---|---|
| Sifat | **Immutabel** setelah dibuat | Memiliki **state** yang dapat berubah |
| Rebuild | Rebuild terjadi saat **input (props)** berubah atau parent rebuild | Rebuild terjadi saat **setState** dipanggil, input berubah, atau parent rebuild |
| Contoh | Icon statis, teks, tombol dengan aksi tanpa perubahan UI internal | Form dengan input, animasi, counter, request async yang update UI |
| Kapan pakai | UI murni dari parameter & tidak berubah sendiri | UI bergantung pada **perubahan data internal**/lifecycle |


---

## 5. Apa itu BuildContext dan penggunaannya di `build`?
- **BuildContext** adalah handler ke **posisi** widget di **widget tree**.  
- Dipakai untuk:
  - Mengakses **InheritedWidget** (mis. `Theme.of(context)`, `MediaQuery.of(context)`).
  - Melakukan **navigasi** (`Navigator.of(context)`).
  - Mendapatkan **Localization**, `ScaffoldMessenger`, dsb.

**Contoh penggunaan di `build`:**
```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final size = MediaQuery.of(context).size;

  return Scaffold(
    appBar: AppBar(title: const Text('Home'), backgroundColor: theme.colorScheme.primary),
    body: Center(child: Text('Lebar layar: ${size.width.toStringAsFixed(0)}')),
  );
}
```
---

## 6. Konsep Hot Reload vs Hot Restart
- **Hot Reload**
  - Menyuntikkan perubahan kode **ke VM** dan **membangun ulang** widget tree **tanpa** mengulang `main()`.
  - **State saat ini dipertahankan** (nilai counter tetap, halaman tetap).
  - Cocok untuk iterasi UI cepat.
- **Hot Restart**
  - Melakukan **restart penuh** aplikasi, menjalankan kembali `main()`.
  - **Semua state hilang** (kembali ke kondisi awal).
  - Gunakan saat perubahan tidak ter-reflect oleh hot reload (mis. perubahan pada global state init, `main()`, plugin tertentu).

---

## 7. Navigasi antar layar di Flutter
### A. Navigasi dasar (push/pop)
```dart
// Pindah ke halaman baru
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => const DetailPage()),
);

// Kembali ke halaman sebelumnya
Navigator.of(context).pop();
```

### B. Named Routes (terstruktur)
```dart
// di MaterialApp
MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (_) => const HomePage(),
    '/detail': (_) => const DetailPage(),
  },
);

// pindah dengan nama route
Navigator.of(context).pushNamed('/detail');
```

### C. Mengirim & menerima argumen
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => DetailPage(itemId: 42),
  ),
);
```

### D. Mendapatkan hasil dari halaman lain
```dart
final result = await Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => const PickerPage()),
);
// gunakan `result` bila tidak null
```

### E. SnackBar/Dialogs yang butuh `ScaffoldMessenger` / `showDialog`
```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Tersimpan!')),
);

await showDialog(
  context: context,
  builder: (_) => const AlertDialog(title: Text('Konfirmasi')),
);
```

---

## Lampiran – Contoh `main.dart` Sederhana
```dart
import 'package:flutter/material.dart';
import 'menu.dart'; // misal berisi widget Menu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football News',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
      // routes: {'/menu': (_) => const Menu()}, // contoh named route
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const Menu()),
            );
          },
          child: const Text('Buka Menu'),
        ),
      ),
    );
  }
}
```


## Tugas 8 – Flutter Navigation, Layouts, Forms, and Input Elements

### Navigator.push() vs Navigator.pushReplacement()
- `Navigator.push()` menambahkan halaman baru ke atas stack sehingga pengguna dapat kembali ke halaman sebelumnya dengan tombol back. Pada aplikasi Football Shop, aksi tombol **Tambah Produk** memakai `push` (`football_shop/lib/menu.dart`) agar setelah form disimpan pengguna bisa kembali ke beranda untuk meninjau hasilnya atau menambah produk lain.
- `Navigator.pushReplacement()` mengganti halaman aktif dengan halaman tujuan. Pola ini saya gunakan pada menu Drawer ketika memilih **Halaman Utama** dari halaman form (`football_shop/lib/add_product_page.dart`) supaya tidak ada duplikasi halaman di stack dan tombol back tidak membawa pengguna kembali ke form yang sama.

### Hierarki Scaffold, AppBar, dan Drawer
- Setiap layar dibangun dengan `Scaffold` untuk menyediakan struktur konsisten berupa `AppBar`, `body`, dan `drawer`. Dengan kerangka ini, beranda (`menu.dart`) dan halaman form (`add_product_page.dart`) otomatis memiliki tata letak seragam dan akses `ScaffoldMessenger` untuk SnackBar.
- `AppBar` memberikan identitas layar serta aksi global. Warna dan tipografinya seragam karena `AppBarTheme` diatur di `football_shop/lib/main.dart`.
- `Drawer` menjadi pintu navigasi utama ke **Halaman Utama** dan **Tambah Produk**, membuat pengalaman berpindah layar lebih intuitif.

### Kelebihan Layout Widget (Padding, SingleChildScrollView, ListView)
- `Padding` memberi ruang napas antar elemen sehingga form mudah dipindai dan tidak terasa sempit (`add_product_page.dart`).
- `SingleChildScrollView` memastikan form tetap bisa discroll di layar kecil maupun saat keyboard muncul, mencegah overflow.
- `GridView.count` dan `Column` membantu mengatur menu beranda menjadi kisi yang rapi, sementara `ListView` pada Drawer menampung opsi navigasi yang bisa discroll.

### Penyesuaian Warna Tema untuk Identitas Toko
- `ThemeData` di `football_shop/lib/main.dart` menyiapkan `ColorScheme` kustom (biru tua sebagai warna primer, oranye sebagai aksen) sehingga identitas visual Football Shop konsisten di seluruh layar.
- `AppBar`, tombol, dan elemen input mewarisi skema warna ini lewat `AppBarTheme`, `ElevatedButtonThemeData`, dan `InputDecorationTheme`, menghasilkan pengalaman visual yang harmonis dengan brand toko.
