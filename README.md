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
  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        _buildHeader(),
        const SizedBox(height: 70),
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 82,
                  color: AppColors.accent,
                ),
                SizedBox(height: 14),
                Text(
                  'Belum ada data booking',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tekan tombol + untuk menambahkan booking baru',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
```

- ListView.builder

```
  Widget _buildListData(List<BookingModel> data) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: data.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return _buildHeader();
          return _buildCard(data[index - 1]);
        },
      ),
    );
  }
```

- Card

```
  Widget _buildCard(BookingModel booking) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Colors.black12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha:0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.palette_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      booking.namaPemesan,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _keFormEdit(booking);
                      } else if (value == 'hapus') {
                        _konfirmasiHapus(booking);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'hapus',
                        child: Text('Hapus'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                Icons.design_services_outlined,
                'Jenis Desain: ${booking.jenisDesain}',
              ),
              const SizedBox(height: 10),
              _buildInfoRow(
                Icons.calendar_today_outlined,
                'Deadline: ${booking.deadline}',
              ),
              const SizedBox(height: 10),
              _buildInfoRow(
                Icons.sticky_note_2_outlined,
                'Note: ${booking.note.isEmpty ? '-' : booking.note}',
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha:0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Harga: Rp ${booking.harga}',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
```

- Container

```
Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha:0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.palette_outlined,
                      color: AppColors.primary,
                    ),
                  ),
```

- Column

```
child: Column(
                      children: [
                        _buildEmailField(),
                        const SizedBox(height: 16),
                        _buildPasswordField(),
                        const SizedBox(height: 24),
                        _buildLoginButton(),
                        const SizedBox(height: 10),
                        _buildRegisterButton(),
                      ],
                    ),
```

- Row

```
Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha:0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.palette_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      booking.namaPemesan,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _keFormEdit(booking);
                      } else if (value == 'hapus') {
                        _konfirmasiHapus(booking);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'hapus',
                        child: Text('Hapus'),
                      ),
                    ],
                  ),
                ],
              ),
```

- SnackBar

```
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
```

- FutureBuilder

```
      child: FutureBuilder<List<BookingModel>>(
        future: totalData,
        builder: (context, snapshot) {
          final total = snapshot.data?.length ?? 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha:0.18),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.design_services,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha:0.16),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '$total Booking',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Selamat Datang 👋',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Kelola booking desainmu\ndengan mudah',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                email,
                style: const TextStyle(
                  color: AppColors.textMutedLight,
                  fontSize: 13,
                ),
              ),
            ],
          );
        },
      ),
```

- Navigator

```
  Future<void> _keFormTambah() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const BookingFormPage()),
    );
```

- PopupMenuButton

```
                  PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _keFormEdit(booking);
                      } else if (value == 'hapus') {
                        _konfirmasiHapus(booking);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'hapus',
                        child: Text('Hapus'),
                      ),
                    ],
                  ),
```

- AlertDialog

```
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Logout'),
          content: const Text('Yakin ingin keluar dari akun ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout'),
            ),
          ],
        );
```

- FloatingActionButton

```
      floatingActionButton: FloatingActionButton(
        onPressed: _keFormTambah,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
```

- SingleChildScrollView

```
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildHeader(isEdit),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 24,
                        color: Colors.black12,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Isi Data Booking',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _namaController,
                        decoration: _inputDecoration(
                          label: 'Nama Pemesan',
                          icon: Icons.person_outline,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama pemesan tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 18),
                      _buildHargaBox(),
                      const SizedBox(height: 24),
                      _buildSimpanButton(isEdit),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
