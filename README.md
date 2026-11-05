# Im Relawan

Aplikasi mobile untuk melaporkan kejadian bencana alam di sekitar kita. Dibuat dengan Flutter dan Firebase.

## Fitur

- Melihat daftar laporan bencana
- Menambah laporan bencana baru
- Mengedit laporan bencana
- Login anonim otomatis menggunakan Firebase Authentication

## Teknologi

- Flutter dan Dart
- Riverpod (state management)
- GoRouter (navigasi)
- Firebase Firestore (penyimpanan data)
- Firebase Authentication (login anonim)

## Struktur Folder
lib/
├── data/services/ # Koneksi ke Firebase
├── domain/models/ # Model data
├── repositories/ # Abstraksi dan implementasi repository
├── routing/ # Konfigurasi navigasi
└── ui/ # Tampilan dan view model

## Cara Menjalankan
1. Clone repository ini:
 git clone https://github.com/juwitaevalinasitohang12/im-relawan-.git
2. Masuk ke folder project, lalu jalankan:
flutter pub get
3. Hubungkan project dengan Firebase menggunakan FlutterFire CLI:
flutterfire configure
4. Aktifkan **Anonymous** di Firebase Authentication dan atur aturan Firestore.
5. Jalankan aplikasi:
flutter run
