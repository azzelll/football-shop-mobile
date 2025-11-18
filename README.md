# Flutter – Ringkasan Konsep Proyek
## Tugas 7
### 1. Apa itu Widget Tree dan hubungan Parent–Child?
- **Widget tree** adalah struktur hierarki dari semua widget yang membentuk UI. Setiap widget berada di dalam widget lain (nested) membentuk pohon.
- **Parent (induk)** adalah widget yang membungkus widget lain; **child (anak)** adalah widget yang dibungkus.  
- **Properti & Constraints mengalir ke bawah**, sedangkan **event & data (lifted state) mengalir ke atas** lewat callback/state management.
- Pada saat render:
  - Parent memberikan **constraints** ke child.
  - Child memilih **ukuran** sesuai constraints lalu mengembalikan **size** ke parent.
  - Parent **meletakkan** child pada layout.

---

### 2. Daftar Widget yang Digunakan & Fungsinya


### Klasifikasi Widget & Fungsinya

| Widget | Jenis | Fungsi Singkat |
|---|---|---|
| `MyApp` | StatelessWidget | Entry point UI yang membungkus aplikasi dengan `MaterialApp` dan mengatur tema/halaman awal. |
| `MaterialApp` | StatefulWidget | Menyediakan kerangka Material (tema, navigator/routes, localization), root context untuk widget Material lain. |
| `ThemeData` | Kelas konfigurasi | Objek konfigurasi tema global: warna (`ColorScheme`), tipografi, shape, dsb. Dipasangkan ke `MaterialApp.theme`. |
| `Scaffold` | StatefulWidget | Kerangka tiap layar: menampung `AppBar`, `body`, `floatingActionButton`, `drawer`, `SnackBar` via `ScaffoldMessenger`. |
| `AppBar` | StatefulWidget | Bilah atas layar untuk judul, aksi, dan navigasi (leading/back). |
| `Menu` | StatelessWidget | Halaman/menu daftar aksi (mis. “See Football News”, “Add News”, “Logout”); konten statis tanpa state internal. |


---

### 3. Fungsi MaterialApp dan mengapa sering jadi root MaterialApp:
- Menyediakan **material design scaffolding** (tema, typografi, ikon).
- Memuat **navigator** & pengelolaan **route** (`routes`, `onGenerateRoute`, `initialRoute`).
- Menyediakan **localizations**, **text direction**, **theme**, **dark mode**.
- Mengatur **title**, **debug banner**, **home**.

**Mengapa jadi root?**  
Karena banyak widget Material (mis. `Scaffold`, `AppBar`, `SnackBar`) **membutuhkan konteks Material**. Menjadikan `MaterialApp` sebagai root menjamin seluruh subtree memiliki akses ke tema, navigator, dan resource Material.

---

### 4. Perbedaan StatelessWidget vs StatefulWidget, Kapan dipilih?

| Aspek | StatelessWidget | StatefulWidget |
|---|---|---|
| Sifat | **Immutabel** setelah dibuat | Memiliki **state** yang dapat berubah |
| Rebuild | Rebuild terjadi saat **input (props)** berubah atau parent rebuild | Rebuild terjadi saat **setState** dipanggil, input berubah, atau parent rebuild |
| Contoh | Icon statis, teks, tombol dengan aksi tanpa perubahan UI internal | Form dengan input, animasi, counter, request async yang update UI |
| Kapan pakai | UI murni dari parameter & tidak berubah sendiri | UI bergantung pada **perubahan data internal**/lifecycle |


---

### 5. Apa itu BuildContext dan penggunaannya di `build`?
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

### 6. Konsep Hot Reload vs Hot Restart
- **Hot Reload**
  - Menyuntikkan perubahan kode **ke VM** dan **membangun ulang** widget tree **tanpa** mengulang `main()`.
  - **State saat ini dipertahankan** (nilai counter tetap, halaman tetap).
  - Cocok untuk iterasi UI cepat.
- **Hot Restart**
  - Melakukan **restart penuh** aplikasi, menjalankan kembali `main()`.
  - **Semua state hilang** (kembali ke kondisi awal).
  - Gunakan saat perubahan tidak ter-reflect oleh hot reload (mis. perubahan pada global state init, `main()`, plugin tertentu).

---

### 7. Navigasi antar layar di Flutter
#### A. Navigasi dasar (push/pop)
```dart
// Pindah ke halaman baru
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => const DetailPage()),
);

// Kembali ke halaman sebelumnya
Navigator.of(context).pop();
```

#### B. Named Routes (terstruktur)
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

#### C. Mengirim & menerima argumen
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => DetailPage(itemId: 42),
  ),
);
```

#### D. Mendapatkan hasil dari halaman lain
```dart
final result = await Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => const PickerPage()),
);
// gunakan `result` bila tidak null
```

#### E. SnackBar/Dialogs yang butuh `ScaffoldMessenger` / `showDialog`
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

### Lampiran – Contoh `main.dart` Sederhana
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

### 1. Navigator.push() vs Navigator.pushReplacement()
- `Navigator.push()` menambahkan halaman baru ke atas stack sehingga pengguna dapat kembali ke halaman sebelumnya dengan tombol back. Pada aplikasi Football Shop, aksi tombol **Tambah Produk** memakai `push` (`football_shop/lib/menu.dart`) agar setelah form disimpan pengguna bisa kembali ke beranda untuk meninjau hasilnya atau menambah produk lain.
- `Navigator.pushReplacement()` mengganti halaman aktif dengan halaman tujuan. Pola ini saya gunakan pada menu Drawer ketika memilih **Halaman Utama** dari halaman form (`football_shop/lib/add_product_page.dart`) supaya tidak ada duplikasi halaman di stack dan tombol back tidak membawa pengguna kembali ke form yang sama.

### 2. Hierarki Scaffold, AppBar, dan Drawer
- Setiap layar dibangun dengan `Scaffold` untuk menyediakan struktur konsisten berupa `AppBar`, `body`, dan `drawer`. Dengan kerangka ini, beranda (`menu.dart`) dan halaman form (`add_product_page.dart`) otomatis memiliki tata letak seragam dan akses `ScaffoldMessenger` untuk SnackBar.
- `AppBar` memberikan identitas layar serta aksi global. Warna dan tipografinya seragam karena `AppBarTheme` diatur di `football_shop/lib/main.dart`.
- `Drawer` menjadi pintu navigasi utama ke **Halaman Utama** dan **Tambah Produk**, membuat pengalaman berpindah layar lebih intuitif.

### 3. Kelebihan Layout Widget (Padding, SingleChildScrollView, ListView)
- `Padding` memberi ruang napas antar elemen sehingga form mudah dipindai dan tidak terasa sempit (`add_product_page.dart`).
- `SingleChildScrollView` memastikan form tetap bisa discroll di layar kecil maupun saat keyboard muncul, mencegah overflow.
- `GridView.count` dan `Column` membantu mengatur menu beranda menjadi kisi yang rapi, sementara `ListView` pada Drawer menampung opsi navigasi yang bisa discroll.

### 4. Penyesuaian Warna Tema untuk Identitas Toko
- `ThemeData` di `football_shop/lib/main.dart` menyiapkan `ColorScheme` kustom (biru tua sebagai warna primer, oranye sebagai aksen) sehingga identitas visual Football Shop konsisten di seluruh layar.
- `AppBar`, tombol, dan elemen input mewarisi skema warna ini lewat `AppBarTheme`, `ElevatedButtonThemeData`, dan `InputDecorationTheme`, menghasilkan pengalaman visual yang harmonis dengan brand toko.

## Tugas 9 – Flutter x Django: Models, HTTP, Cookie, dan Autentikasi

### 1. Mengapa perlu membuat model Dart saat mengambil/mengirim data JSON?

Saya membuat **model Dart** (mis. `Product`, `User`) dengan `fromJson()` dan `toJson()` karena:

- **Validasi tipe & null-safety**
  - Field di‐typing jelas (`int id`, `String name`, `double price`, dll).
  - Kompiler bisa memberi warning kalau saya salah mengisi tipe data atau lupa menangani nilai `null`.
  - Tanpa model dan hanya pakai `Map<String, dynamic>`, semua field bertipe `dynamic` → kesalahan baru muncul **saat runtime** (mis. `as String` gagal, key typo, dll).

- **Maintainability & konsistensi**
  - Struktur data hanya didefinisikan **satu kali** di model. Kalau backend menambah field baru, saya cukup update model, tidak perlu mengedit parsing di banyak tempat.
  - Otomatis memberi dokumentasi kecil: cukup lihat kelas `Product` untuk tahu field apa saja yang dikirim/diterima.

- **Kemudahan refactor & IDE support**
  - IDE bisa memberi **auto-complete**, refactor rename, dan pencarian referensi (`product.name`, `product.price`).
  - Dengan `Map<String, dynamic>`, saya harus mengingat string key (`data['name']`, `data['price']`) dan lebih mudah salah ketik.

**Konsekuensi jika langsung memakai `Map<String, dynamic>` tanpa model:**

- Tidak ada jaminan tipe → rawan runtime error.
- Sulit menelusuri perubahan struktur JSON saat proyek membesar.
- Parsing dan mapping berulang di banyak tempat, sehingga kode lebih panjang dan mudah tidak konsisten.
- Null-safety jadi sulit diterapkan karena hampir semua akses butuh casting dan cek `null` manual.


### 2. Fungsi package `http` dan `CookieRequest`, serta perbedaannya

- **Package `http`**
  - Digunakan untuk melakukan **HTTP request biasa** (GET, POST, PUT, DELETE).
  - Cocok untuk endpoint yang **tidak bergantung pada session/cookie**, misalnya mengambil daftar produk publik (`/json/products/`).
  - Setiap request berdiri sendiri, saya perlu mengatur header, body, dan decoding JSON manual.

- **`CookieRequest` (dari `pbp_django_auth`)**
  - Merupakan **wrapper** di atas HTTP client yang **menyimpan cookie dan mengelola session Django**.
  - Dipakai untuk endpoint yang **butuh autentikasi** dan perlu mengirim cookie, seperti login, register, tambah produk tertaut user, logout.
  - Menyediakan fungsi praktis seperti `login`, `post`, dan otomatis menyisipkan cookie (`sessionid`, `csrftoken`) pada setiap request berikutnya.

**Perbedaan utama:**

- `http` → request **stateless**, tidak menyimpan cookie atau session.
- `CookieRequest` → request **stateful**, menyimpan cookie session Django dan mengirimkannya lagi di setiap request, sehingga backend bisa mengenali user yang sedang login.


### 3. Mengapa instance `CookieRequest` dibagikan ke semua komponen Flutter?

Saya menggunakan satu instance `CookieRequest` yang dibagikan melalui **Provider** (`context.watch<CookieRequest>()`) karena:

- **Session login harus tunggal & konsisten**
  - Cookie session (`sessionid`) disimpan di dalam `CookieRequest`.
  - Jika setiap halaman membuat instance berbeda, cookie dan status login tidak ikut terbawa → user tampak “belum login” di halaman lain.

- **Memudahkan akses status & data user**
  - Semua widget dapat mengecek `request.loggedIn`, melihat `request.jsonData`, atau memanggil `logout()` tanpa harus meneruskan objek lewat parameter berlapis.
  - Pola ini mirip dengan “global session” tetapi tetap rapi karena memakai state management.

- **Menghindari bug autentikasi**
  - Dengan instance yang sama, login di halaman A akan langsung mempengaruhi halaman lain (menu berubah, tombol tertentu aktif, dsb).
  - Jika tidak dibagikan, kita bisa mengalami kasus login berhasil di satu widget, tapi request lain masih dianggap anonymous oleh Django.


### 4. Konfigurasi konektivitas Flutter ↔ Django dan akibat jika salah konfigurasi

Agar aplikasi Flutter (Android/emulator) dapat berkomunikasi dengan Django di lokal, saya melakukan beberapa konfigurasi:

1. **Menambah `10.0.2.2` pada `ALLOWED_HOSTS` (Django `settings.py`)**
   - Android emulator melihat komputer host sebagai `10.0.2.2`.
   - Jika tidak ditambahkan, Django akan menolak request dengan error **“Bad Request (400) – Invalid HTTP_HOST header”**.

2. **Mengaktifkan CORS**
   - Menambahkan konfigurasi `CORS_ALLOW_ALL_ORIGINS` atau `CORS_ALLOWED_ORIGINS` dan `CORS_ALLOW_CREDENTIALS = True` (jika memakai cookie).
   - Tanpa CORS yang benar, permintaan dari aplikasi (terutama Flutter Web) bisa ditolak atau cookie tidak ikut terkirim.

3. **Pengaturan cookie & SameSite**
   - Mengatur `SESSION_COOKIE_SAMESITE` dan `CSRF_COOKIE_SAMESITE`, serta flag `SECURE` / `HttpOnly` sesuai kebutuhan.
   - Jika `SameSite` terlalu ketat, cookie session bisa **tidak terkirim** ke server sehingga user selalu dianggap belum login.

4. **Izin akses internet di Android**
   - Menambahkan di `AndroidManifest.xml`:
     ```xml
     <uses-permission android:name="android.permission.INTERNET" />
     ```
   - Tanpa izin ini, semua request jaringan akan gagal dan melempar exception di Flutter.

**Apa yang terjadi jika konfigurasi tidak benar?**

- Request dari Flutter tidak pernah mencapai Django atau selalu ditolak.
- Autentikasi gagal (login selalu gagal / status tidak tersimpan).
- Data tidak bisa diambil/ditampilkan meskipun backend sebenarnya sudah berjalan.
- Debugging menjadi sulit karena error bisa muncul sebagai “Network error”, “Bad Request”, atau tidak ada cookie sama sekali.


### 5. Mekanisme pengiriman data dari input sampai tampil di Flutter

Alur umum pengiriman data (misalnya input produk baru) yang saya implementasikan:

1. **User mengisi form di Flutter**
   - Pada halaman form, user mengisi nama produk, harga, deskripsi, dll.
   - Data disimpan di state (`TextEditingController`, variabel lokal).

2. **Data dibungkus menjadi model Dart dan/atau Map**
   - Saya membangun objek `Product` lalu mengonversinya ke JSON (Map) via `toJson()`.

3. **Mengirim request ke Django**
   - Menggunakan `CookieRequest.post` atau `http.post`:
     ```dart
     await request.post(
       "http://10.0.2.2:8000/produk/create-flutter/",
       data,
     );
     ```
   - Body dikirim sebagai JSON atau form data.

4. **Django menerima dan memproses**
   - View Django membaca body request, memvalidasi input, lalu menyimpan objek `Product` ke database (via `Product.objects.create(...)`).
   - Setelah sukses, Django merespons JSON yang berisi status dan/atau data produk yang baru dibuat.

5. **Flutter menerima respons**
   - Flutter mendecode JSON menjadi Map lalu, jika perlu, mengubahnya menjadi objek `Product` (`Product.fromJson`).
   - Saya update list produk lokal (misal menambah produk baru ke dalam list) dan memanggil `setState()` atau update `Provider`.

6. **UI diperbarui**
   - Halaman list produk rebuild dan menampilkan data terbaru, sehingga user langsung melihat produk yang baru saja ditambahkan.


### 6. Mekanisme autentikasi: login, register, dan logout

Alur yang saya pakai:

#### a. Register

1. User membuka halaman **Register** di Flutter dan mengisi username + password.
2. Flutter mengirim request (biasanya dengan `http.post` atau `CookieRequest.post`) ke endpoint Django `/auth/register/` dengan body JSON.
3. Django:
   - Memvalidasi input (cek unik username, kekuatan password, dll).
   - Membuat objek `User` baru (`User.objects.create_user(...)`).
   - Mengembalikan JSON berisi `status` dan pesan (`success` atau error).
4. Flutter menampilkan SnackBar / dialog berdasarkan hasil (gagal atau berhasil), lalu mengarahkan user ke halaman login jika sukses.

#### b. Login

1. User mengisi username dan password di halaman **Login** Flutter.
2. Flutter memanggil:
   ```dart
   final response = await request.login(
     "http://10.0.2.2:8000/auth/login/",
     {
       'username': username,
       'password': password,
     },
   );
