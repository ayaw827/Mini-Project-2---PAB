# Mini Project 2 PAB
**Nurhidayah | 2409116002 A'24**

## Deskripsi Aplikasi

Aplikasi ini merupakan pengembangan dari **Mini Project 1** dengan tema **Booking Desain**.  
Pada Mini Project 2, aplikasi dikembangkan menggunakan **Flutter** dengan integrasi **Supabase** sebagai database dan authentication.

Aplikasi ini memungkinkan pengguna untuk:
- Login dan Register akun
- Menambahkan data booking desain
- Melihat daftar booking
- Mengedit data booking
- Menghapus data booking

Semua data disimpan secara online menggunakan **Supabase**, sehingga tidak lagi menggunakan list lokal seperti pada Mini Project 1.

---

## Fitur Aplikasi

### 1. Login Page
Pada halaman ini, pengguna dapat masuk ke aplikasi menggunakan email dan password yang sudah terdaftar pada **Supabase Auth**.

### 2. Register Page
Pada halaman ini, pengguna dapat membuat akun baru menggunakan email dan password. Setelah registrasi berhasil, pengguna diarahkan untuk login terlebih dahulu.

### 3. Booking List Page
Halaman utama aplikasi setelah login. Halaman ini menampilkan seluruh data booking desain yang tersimpan di database **Supabase**.  
Pengguna juga dapat:
- Melihat daftar booking
- Refresh data
- Logout
- Menambah data baru
- Memilih menu edit atau hapus pada setiap data

### 4. Booking Form Page
Halaman form digunakan untuk menambahkan atau mengedit data booking.  
Field yang tersedia:
- Nama Pemesan
- Jenis Desain
- Deadline
- Note
- Harga

Harga akan otomatis menyesuaikan jenis desain yang dipilih.

### 5. Date Picker
Pada field deadline, pengguna dapat memilih tanggal menggunakan **Date Picker**, sehingga input menjadi lebih mudah dan rapi.

---

## Fitur CRUD

Aplikasi ini telah memenuhi operasi CRUD sebagai berikut:

### Create
Menambahkan data booking baru ke database Supabase.

### Read
Menampilkan seluruh data booking dari Supabase ke halaman list.

### Update
Mengedit data booking yang sudah ada.

### Delete
Menghapus data booking dari Supabase.

---

## Integrasi Supabase

Aplikasi ini menggunakan **Supabase** untuk:
- **Authentication** → login dan register pengguna
- **Database** → menyimpan data booking desain

Tabel yang digunakan adalah:

### `bookings`

Field pada tabel:
- `id`
- `nama_pemesan`
- `jenis_desain`
- `deadline`
- `note`
- `harga`

---

## Widget yang Digunakan

Beberapa widget Flutter yang digunakan dalam aplikasi ini antara lain:

- `MaterialApp`
- `Scaffold`
- `AppBar`
- `TextField`
- `TextFormField`
- `DropdownButtonFormField`
- `ElevatedButton`
- `TextButton`
- `ListView`
- `ListView.builder`
- `Card`
- `Container`
- `Column`
- `Row`
- `SnackBar`
- `FutureBuilder`
- `Navigator`
- `PopupMenuButton`
- `AlertDialog`
- `FloatingActionButton`
- `SingleChildScrollView`

---

## Struktur Halaman

Aplikasi ini memiliki minimal dua halaman utama sesuai ketentuan tugas:

1. **Halaman List Data** → `BookingListPage`
2. **Halaman Form Tambah/Edit Data** → `BookingFormPage`

Selain itu, terdapat halaman tambahan:
- `LoginPage`
- `RegisterPage`

---

## Struktur Folder Project

```bash
lib/
├── database/
│   └── supadata.dart
├── model/
│   └── booking_model.dart
├── pages/
│   ├── booking_form_page.dart
│   ├── booking_list_page.dart
│   ├── login_page.dart
│   └── register_page.dart
├── theme/
│   └── app_collors.dart
└── main.dart
