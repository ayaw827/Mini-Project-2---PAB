import 'package:flutter/material.dart';

import '../database/supadata.dart';
import '../model/booking_model.dart';
import '../theme/app_collors.dart';

class BookingFormPage extends StatefulWidget {
  final BookingModel? booking;

  const BookingFormPage({super.key, this.booking});

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _jenisDesain;
  int _harga = 0;
  bool _isLoading = false;

  final List<String> _pilihanDesain = ['Logo', 'Poster', 'Feed Instagram'];

  @override
  void initState() {
    super.initState();

    if (widget.booking != null) {
      _namaController.text = widget.booking!.namaPemesan;
      _deadlineController.text = widget.booking!.deadline;
      _noteController.text = widget.booking!.note;
      _jenisDesain = widget.booking!.jenisDesain;
      _harga = widget.booking!.harga;
    }
  }

  void _updateHarga(String jenis) {
    setState(() {
      _jenisDesain = jenis;

      if (jenis == 'Logo') {
        _harga = 50000;
      } else if (jenis == 'Poster') {
        _harga = 75000;
      } else if (jenis == 'Feed Instagram') {
        _harga = 30000;
      } else {
        _harga = 0;
      }
    });
  }

  Future<void> _pilihTanggal() async {
    FocusScope.of(context).unfocus();

    DateTime initialDate = DateTime.now();

    if (_deadlineController.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(_deadlineController.text);
      } catch (_) {}
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              secondary: AppColors.accent,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final year = pickedDate.year.toString().padLeft(4, '0');
      final month = pickedDate.month.toString().padLeft(2, '0');
      final day = pickedDate.day.toString().padLeft(2, '0');

      setState(() {
        _deadlineController.text = '$year-$month-$day';
      });
    }
  }

  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate()) return;
    if (_jenisDesain == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jenis desain terlebih dahulu')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      final bookingBaru = BookingModel(
        id: widget.booking?.id,
        namaPemesan: _namaController.text.trim(),
        jenisDesain: _jenisDesain!,
        deadline: _deadlineController.text.trim(),
        note: _noteController.text.trim(),
        harga: _harga,
      );

      if (widget.booking == null) {
        await SupaData.addBooking(bookingBaru);
      } else {
        await SupaData.updateBooking(bookingBaru);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildHeader(bool isEdit) {
    return Container(
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isEdit ? Icons.edit_note : Icons.add_box_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isEdit ? 'Edit Data Booking ✏️' : 'Tambah Booking Baru 🎨',
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEdit
                ? 'Perbarui data booking desain dengan mudah'
                : 'Isi form di bawah untuk menambahkan booking desain',
            style: const TextStyle(
              color: AppColors.textMutedLight,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHargaBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.payments_outlined,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Harga: Rp $_harga',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpanButton(bool isEdit) {
    return SizedBox(
      width: double.infinity,
      height: 52,
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
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deadlineController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.booking != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        centerTitle: true,
        title: Text(
          isEdit ? 'Edit Booking' : 'Tambah Booking',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      body: SafeArea(
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
      ),
    );
  }
}
