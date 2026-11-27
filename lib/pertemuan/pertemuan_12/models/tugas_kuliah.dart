class TugasKuliah {
  final int id;
  final String judul;
  final String mataKuliah;
  final String deadline;
  final bool isSelesai;

  const TugasKuliah({
    required this.id,
    required this.judul,
    required this.mataKuliah,
    required this.deadline,
    this.isSelesai = false,
  });

  TugasKuliah copyWith({
    String? judul,
    String? mataKuliah,
    String? deadline,
    bool? isSelesai,
  }) {
    return TugasKuliah(
      id: id,
      judul: judul ?? this.judul,
      mataKuliah: mataKuliah ?? this.mataKuliah,
      deadline: deadline ?? this.deadline,
      isSelesai: isSelesai ?? this.isSelesai,
    );
  }
}
