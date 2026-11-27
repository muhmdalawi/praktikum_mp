import 'package:flutter/foundation.dart';
import '../models/tugas_kuliah.dart';

class TugasViewModel extends ChangeNotifier {
  TugasViewModel() {
    _items = _dataAwal();
  }

  late List<TugasKuliah> _items;
  String _query = '';
  bool _sortAscending = true;
  int _nextId = 9;

  String get query => _query;
  bool get sortAscending => _sortAscending;
  int get totalData => _items.length;
  int get totalSelesai => _items.where((t) => t.isSelesai).length;

  List<TugasKuliah> get items {
    final q = _query.trim().toLowerCase();
    final hasil = _items.where((t) {
      if (q.isEmpty) return true;
      return t.judul.toLowerCase().contains(q) ||
          t.mataKuliah.toLowerCase().contains(q);
    }).toList();
    hasil.sort((a, b) {
      final cmp = a.judul.toLowerCase().compareTo(b.judul.toLowerCase());
      return _sortAscending ? cmp : -cmp;
    });
    return hasil;
  }

  void search(String value) {
    _query = value;
    notifyListeners();
  }

  void resetSearch() {
    _query = '';
    notifyListeners();
  }

  void toggleSort() {
    _sortAscending = !_sortAscending;
    notifyListeners();
  }

  void add({
    required String judul,
    required String mataKuliah,
    required String deadline,
  }) {
    _items.add(TugasKuliah(
      id: _nextId++,
      judul: judul.trim(),
      mataKuliah: mataKuliah.trim(),
      deadline: deadline.trim(),
    ));
    notifyListeners();
  }

  void update(
    int id, {
    required String judul,
    required String mataKuliah,
    required String deadline,
  }) {
    final i = _items.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _items[i] = _items[i].copyWith(
      judul: judul.trim(),
      mataKuliah: mataKuliah.trim(),
      deadline: deadline.trim(),
    );
    notifyListeners();
  }

  void toggleStatus(int id) {
    final i = _items.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _items[i] = _items[i].copyWith(isSelesai: !_items[i].isSelesai);
    notifyListeners();
  }

  void delete(int id) {
    _items.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void resetData() {
    _items = _dataAwal();
    _nextId = 9;
    _query = '';
    _sortAscending = true;
    notifyListeners();
  }

  static List<TugasKuliah> _dataAwal() => [
        const TugasKuliah(id: 1, judul: 'Laporan Praktikum SQLite', mataKuliah: 'Mobile Programming', deadline: '2 Des 2026', isSelesai: true),
        const TugasKuliah(id: 2, judul: 'Normalisasi Tabel 3NF', mataKuliah: 'Basis Data', deadline: '3 Des 2026'),
        const TugasKuliah(id: 3, judul: 'Diagram Use Case Sistem Kasir', mataKuliah: 'Rekayasa Perangkat Lunak', deadline: '4 Des 2026'),
        const TugasKuliah(id: 4, judul: 'Implementasi Linked List', mataKuliah: 'Struktur Data', deadline: '5 Des 2026', isSelesai: true),
        const TugasKuliah(id: 5, judul: 'Subnetting Jaringan Kantor', mataKuliah: 'Jaringan Komputer', deadline: '6 Des 2026'),
        const TugasKuliah(id: 6, judul: 'Wireframe Aplikasi Kampus', mataKuliah: 'Interaksi Manusia dan Komputer', deadline: '8 Des 2026'),
        const TugasKuliah(id: 7, judul: 'Query JOIN dan Subquery', mataKuliah: 'Basis Data', deadline: '9 Des 2026'),
        const TugasKuliah(id: 8, judul: 'Analisis SWOT Startup', mataKuliah: 'Kewirausahaan', deadline: '10 Des 2026'),
      ];
}
