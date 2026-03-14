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

## Fitur Aplikasi

### 1. Login Page
Pada halaman ini, pengguna dapat masuk ke aplikasi menggunakan email dan password yang sudah terdaftar pada **Supabase Auth**.

### 2. Register Page
Pada halaman ini, pengguna dapat membuat akun baru menggunakan email dan password. Setelah registrasi berhasil, pengguna diarahkan untuk login terlebih dahulu.

### 3. Booking List Page
Halaman utama aplikasi setelah login. Halaman ini menampilkan seluruh data booking desain yang tersimpan di database Supabase.  
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
Pada field deadline, pengguna dapat memilih tanggal menggunakan Date Picker, sehingga input menjadi lebih mudah dan rapi.

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

Aplikasi ini menggunakan Supabase untuk:
- Authentication → login dan register pengguna
- Database → menyimpan data booking desain

Tabel yang digunakan adalah:

### bookings

Field pada tabel:
- id
- nama_pemesan
- jenis_desain
- deadline
- note
- harga

---

## Widget yang Digunakan

Beberapa widget Flutter yang digunakan dalam aplikasi ini antara lain:

- MaterialApp

```
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Booking Desain',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
      home: const AuthGate(),
    );
  }
}
```

- Scaffold

```
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
```

- AppBar

```
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        title: const Text(
          'Booking Desain',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: _isLoggingOut ? null : _konfirmasiLogout,
              tooltip: 'Logout',
              icon: _isLoggingOut
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : const Icon(Icons.logout_rounded),
            ),
          ),
        ],
      ),
```

- TextField

```
  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: obscurePassword,
      decoration: _inputDecoration(
        label: 'Password',
        icon: Icons.lock_outline,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
          icon: Icon(
            obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
      ),
    );
  }
```

- TextFormField

```
TextFormField(
                        controller: _deadlineController,
                        readOnly: true,
                        onTap: _pilihTanggal,
                        decoration: _inputDecoration(
                          label: 'Deadline',
                          icon: Icons.calendar_today_outlined,
                          hintText: 'Pilih tanggal deadline',
                        ).copyWith(
                          suffixIcon: IconButton(
                            onPressed: _pilihTanggal,
                            icon: const Icon(Icons.date_range_outlined),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Deadline tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _noteController,
                        maxLines: 3,
                        decoration: _inputDecoration(
                          label: 'Note',
                          icon: Icons.note_alt_outlined,
                          hintText: 'Tambahkan catatan jika ada',
                        ).copyWith(
                          alignLabelWithHint: true,
                        ),
                      ),
```

- DropdownButtonFormField

```
DropdownButtonFormField<String>(
                        value: _jenisDesain,
                        decoration: _inputDecoration(
                          label: 'Jenis Desain',
                          icon: Icons.palette_outlined,
                        ),
                        items: _pilihanDesain.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: _isLoading
                            ? null
                            : (value) {
                                if (value != null) {
                                  _updateHarga(value);
                                }
                              },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih jenis desain';
                          }
                          return null;
                        },
                      ),
```

- ElevatedButton

```
child: ElevatedButton(
        onPressed: _isLoading ? null : _simpanData,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                isEdit ? 'Update Booking' : 'Simpan Booking',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
```

- TextButton

```
TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
```

- ListView

```

```

- ListView.builder

```

```

- Card

```

```

- Container

```

```

- Column

```

```

- Row

```

```

- SnackBar

```

```

- FutureBuilder

```

```

- Navigator

```

```

- PopupMenuButton

```

```

- AlertDialog

```

```

- FloatingActionButton

```

```

- SingleChildScrollView

```

```


---

## Struktur Halaman

Aplikasi ini memiliki minimal dua halaman utama sesuai ketentuan tugas:

1. Halaman List Data → BookingListPage
2. Halaman Form Tambah/Edit Data → BookingFormPage

Selain itu, terdapat halaman tambahan:
- LoginPage
- RegisterPage

---

## Struktur Folder Project
