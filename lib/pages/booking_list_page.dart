import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/supadata.dart';
import '../model/booking_model.dart';
import '../theme/app_collors.dart';
import 'booking_form_page.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({super.key});

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  late Future<List<BookingModel>> _futureBookings;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _futureBookings = SupaData.getBookings();
  }

  Future<void> _refreshData() async {
    setState(_loadData);
    await _futureBookings;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _logout() async {
    if (_isLoggingOut) return;

    setState(() => _isLoggingOut = true);

    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      if (!mounted) return;
      _showMessage('Logout gagal: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  Future<void> _konfirmasiLogout() async {
    final hasil = await showDialog<bool>(
      context: context,
      builder: (context) {
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
      },
    );

    if (hasil == true) {
      await _logout();
    }
  }

  Future<void> _hapusData(int id) async {
    await SupaData.deleteBooking(id);
    await _refreshData();

    if (!mounted) return;
    _showMessage('Booking berhasil dihapus');
  }

  Future<void> _keFormTambah() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const BookingFormPage()),
    );

    if (result == true) {
      await _refreshData();

      if (!mounted) return;
      _showMessage('Booking berhasil ditambahkan');
    }
  }

  Future<void> _keFormEdit(BookingModel booking) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BookingFormPage(booking: booking),
      ),
    );

    if (result == true) {
      await _refreshData();

      if (!mounted) return;
      _showMessage('Booking berhasil diperbarui');
    }
  }

  Future<void> _konfirmasiHapus(BookingModel booking) async {
    final hasil = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Hapus Booking'),
          content: Text(
            'Yakin ingin menghapus booking ${booking.namaPemesan}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (hasil == true && booking.id != null) {
      await _hapusData(booking.id!);
    }
  }

  Widget _buildHeader() {
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? 'User';
    final totalData = _futureBookings;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black12,
            offset: Offset(0, 8),
          ),
        ],
      ),
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
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.accent,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14.5),
          ),
        ),
      ],
    );
  }

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
      body: FutureBuilder<List<BookingModel>>(
        future: _futureBookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.accent,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Terjadi kesalahan:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            );
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: _buildEmptyState(),
            );
          }

          return _buildListData(data);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _keFormTambah,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
