import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/booking_model.dart';

class SupaData {
  static final supabase = Supabase.instance.client;

  static Future<List<BookingModel>> getBookings() async {
    try {
      final data = await supabase.from('bookings').select();

      return (data as List)
          .map((item) => BookingModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data booking: $e');
    }
  }

  static Future<void> addBooking(BookingModel booking) async {
    try {
      await supabase.from('bookings').insert({
        'nama_pemesan': booking.namaPemesan,
        'jenis_desain': booking.jenisDesain,
        'deadline': booking.deadline,
        'note': booking.note,
        'harga': booking.harga,
      });
    } catch (e) {
      throw Exception('Gagal menambahkan booking: $e');
    }
  }

  static Future<void> updateBooking(BookingModel booking) async {
    try {
      await supabase
          .from('bookings')
          .update({
            'nama_pemesan': booking.namaPemesan,
            'jenis_desain': booking.jenisDesain,
            'deadline': booking.deadline,
            'note': booking.note,
            'harga': booking.harga,
          })
          .eq('id', booking.id!);
    } catch (e) {
      throw Exception('Gagal mengupdate booking: $e');
    }
  }

  static Future<void> deleteBooking(int id) async {
    try {
      await supabase.from('bookings').delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus booking: $e');
    }
  }
}