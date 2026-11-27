import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/app_badge.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_empty_state.dart';
import '../models/tugas_kuliah.dart';
import '../viewmodels/tugas_viewmodel.dart';
import '../../../widgets/tugas_form_dialog.dart';
import '../latihan/search_option_page.dart';

enum _OpsiMenu { tambah, urutkan, resetCari, resetData, latihan, tentang }

enum _AksiItem { edit, status, hapus }

class TugasPertemuan12 extends StatefulWidget {
  const TugasPertemuan12({super.key});

  @override
  State<TugasPertemuan12> createState() => _TugasPertemuan12State();
}

class _TugasPertemuan12State extends State<TugasPertemuan12> {
  final TugasViewModel _vm = TugasViewModel();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _vm.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _snack(String pesan) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(pesan)));
  }

  void _bukaPencarian() => setState(() => _isSearching = true);

  void _tutupPencarian() {
    _searchController.clear();
    _vm.resetSearch();
    setState(() => _isSearching = false);
  }

  Future<void> _onOpsiDipilih(_OpsiMenu opsi) async {
    switch (opsi) {
      case _OpsiMenu.tambah:
        await _tambah();
      case _OpsiMenu.urutkan:
        _vm.toggleSort();
        _snack(_vm.sortAscending ? 'Diurutkan A–Z' : 'Diurutkan Z–A');
      case _OpsiMenu.resetCari:
        _tutupPencarian();
        _snack('Pencarian direset');
      case _OpsiMenu.resetData:
        _searchController.clear();
        setState(() => _isSearching = false);
        _vm.resetData();
        _snack('Data dikembalikan ke awal');
      case _OpsiMenu.latihan:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LatihanSearchOption()),
        );
      case _OpsiMenu.tentang:
        showAboutDialog(
          context: context,
          applicationName: 'Daftar Tugas Kuliah',
          applicationVersion: '1.0.0',
          applicationIcon: const Icon(LucideIcons.bookCheck, size: 36),
          children: const [
            Text(
              'Tugas Pertemuan 12 Mobile Programming.\n'
              'Arsitektur MVVM dengan SearchView, OptionMenu, dan ContextMenu.\n\n'
              'Muhamad Alawi - 241011750032',
            ),
          ],
        );
    }
  }

  Future<void> _tambah() async {
    final hasil = await showTugasFormDialog(context);
    if (hasil == null) return;
    _vm.add(
      judul: hasil.judul,
      mataKuliah: hasil.mataKuliah,
      deadline: hasil.deadline,
    );
    _snack('Tugas "${hasil.judul.trim()}" ditambahkan');
  }

  Future<void> _tampilkanContextMenu(TugasKuliah tugas, Offset posisi) async {
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final aksi = await showMenu<_AksiItem>(
      context: context,
      position: RelativeRect.fromRect(
        posisi & const Size(1, 1),
        Offset.zero & overlay.size,
      ),
      items: [
        const PopupMenuItem(
          value: _AksiItem.edit,
          child: ListTile(
            leading: Icon(LucideIcons.pencil),
            title: Text('Edit'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: _AksiItem.status,
          child: ListTile(
            leading: Icon(
              tugas.isSelesai ? LucideIcons.rotateCcw : LucideIcons.circleCheck,
            ),
            title: Text(
              tugas.isSelesai ? 'Tandai Belum Selesai' : 'Tandai Selesai',
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: _AksiItem.hapus,
          child: ListTile(
            leading: Icon(LucideIcons.trash2, color: AppColors.error),
            title: Text('Hapus', style: TextStyle(color: AppColors.error)),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
    if (!mounted || aksi == null) return;

    switch (aksi) {
      case _AksiItem.edit:
        final hasil = await showTugasFormDialog(context, awal: tugas);
        if (hasil == null) return;
        _vm.update(
          tugas.id,
          judul: hasil.judul,
          mataKuliah: hasil.mataKuliah,
          deadline: hasil.deadline,
        );
        _snack('Tugas diperbarui');
      case _AksiItem.status:
        _vm.toggleStatus(tugas.id);
        _snack(tugas.isSelesai
            ? '"${tugas.judul}" ditandai belum selesai'
            : '"${tugas.judul}" ditandai selesai');
      case _AksiItem.hapus:
        final yakin = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Hapus Tugas'),
            content: Text('Hapus "${tugas.judul}" dari daftar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Batal'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
        );
        if (yakin == true) {
          _vm.delete(tugas.id);
          _snack('Tugas dihapus');
        }
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: _isSearching
          ? IconButton(
              icon: const Icon(LucideIcons.arrowLeft),
              tooltip: 'Tutup pencarian',
              onPressed: _tutupPencarian,
            )
          : null,
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: _vm.search,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Cari judul atau mata kuliah...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
            )
          : const Text('Pertemuan 12'),
      actions: [
        if (!_isSearching)
          IconButton(
            icon: const Icon(LucideIcons.search),
            tooltip: 'Cari',
            onPressed: _bukaPencarian,
          )
        else
          IconButton(
            icon: const Icon(LucideIcons.x),
            tooltip: 'Hapus teks',
            onPressed: () {
              _searchController.clear();
              _vm.resetSearch();
            },
          ),
        PopupMenuButton<_OpsiMenu>(
          tooltip: 'Opsi',
          icon: const Icon(LucideIcons.ellipsisVertical),
          onSelected: _onOpsiDipilih,
          itemBuilder: (_) => [
            _opsi(_OpsiMenu.tambah, LucideIcons.plus, 'Tambah Data'),
            _opsi(
              _OpsiMenu.urutkan,
              _vm.sortAscending
                  ? LucideIcons.arrowDownZA
                  : LucideIcons.arrowDownAZ,
              _vm.sortAscending ? 'Urutkan Z–A' : 'Urutkan A–Z',
            ),
            _opsi(_OpsiMenu.resetCari, LucideIcons.searchX, 'Reset Pencarian'),
            _opsi(_OpsiMenu.resetData, LucideIcons.refreshCw, 'Reset Data'),
            _opsi(_OpsiMenu.latihan, LucideIcons.flaskConical, 'Latihan SearchAnchor'),
            const PopupMenuDivider(),
            _opsi(_OpsiMenu.tentang, LucideIcons.info, 'Tentang Aplikasi'),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<_OpsiMenu> _opsi(_OpsiMenu value, IconData icon, String label) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: AppSpacing.md),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambah,
        tooltip: 'Tambah Tugas',
        child: const Icon(LucideIcons.plus),
      ),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) {
          final daftar = _vm.items;
          final adaQuery = _vm.query.trim().isNotEmpty;
          return Column(
            children: [
              _Ringkasan(
                total: _vm.totalData,
                selesai: _vm.totalSelesai,
                tampil: daftar.length,
                query: _vm.query.trim(),
              ),
              Expanded(
                child: daftar.isEmpty
                    ? AppEmptyState(
                        icon: LucideIcons.searchX,
                        title: 'Tidak ada tugas',
                        description: adaQuery
                            ? 'Tidak ada hasil untuk "${_vm.query.trim()}".'
                            : 'Belum ada data. Tambahkan tugas baru.',
                        actionLabel: adaQuery ? 'Reset Pencarian' : 'Tambah Data',
                        onAction: adaQuery ? _tutupPencarian : _tambah,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          0,
                          AppSpacing.lg,
                          88,
                        ),
                        itemCount: daftar.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, i) {
                          final tugas = daftar[i];
                          return GestureDetector(
                            onLongPressStart: (d) =>
                                _tampilkanContextMenu(tugas, d.globalPosition),
                            child: _TugasTile(tugas: tugas),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Ringkasan extends StatelessWidget {
  final int total;
  final int selesai;
  final int tampil;
  final String query;

  const _Ringkasan({
    required this.total,
    required this.selesai,
    required this.tampil,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Text(
              query.isEmpty
                  ? '$selesai dari $total tugas selesai'
                  : '$tampil hasil untuk "$query"',
              style: TextStyle(color: muted, fontSize: 13),
            ),
          ),
          Text(
            'Tekan lama item untuk opsi',
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _TugasTile extends StatelessWidget {
  final TugasKuliah tugas;

  const _TugasTile({required this.tugas});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warna = tugas.isSelesai ? AppColors.success : AppColors.warning;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Icon(
            tugas.isSelesai ? LucideIcons.circleCheck : LucideIcons.clock,
            color: warna,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tugas.judul,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    decoration:
                        tugas.isSelesai ? TextDecoration.lineThrough : null,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${tugas.mataKuliah} • ${tugas.deadline}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppBadge(
            label: tugas.isSelesai ? 'Selesai' : 'Belum',
            backgroundColor: tugas.isSelesai
                ? AppColors.successSubtle
                : AppColors.warningSubtle,
            textColor: tugas.isSelesai
                ? AppColors.success
                : const Color(0xFFB45309),
          ),
        ],
      ),
    );
  }
}
