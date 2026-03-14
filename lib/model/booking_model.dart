class BookingModel {
  int? id;
  String namaPemesan;
  String jenisDesain;
  String deadline;
  String note;
  int harga;

  BookingModel({
    this.id,
    required this.namaPemesan,
    required this.jenisDesain,
    required this.deadline,
    required this.note,
    required this.harga,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'],
      namaPemesan: map['nama_pemesan'] ?? '',
      jenisDesain: map['jenis_desain'] ?? '',
      deadline: map['deadline'] ?? '',
      note: map['note'] ?? '',
      harga: map['harga'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_pemesan': namaPemesan,
      'jenis_desain': jenisDesain,
      'deadline': deadline,
      'note': note,
      'harga': harga,
    };
  }
}
