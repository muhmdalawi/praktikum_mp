import 'package:flutter/material.dart';

class Mahasiswa {
  final String nama;
  final String nim;

  const Mahasiswa(this.nama, this.nim);
}

enum MenuOpsi { tambah, pengaturan, info, keluar }

class LatihanSearchOption extends StatefulWidget {
  const LatihanSearchOption({super.key});

  @override
  State<LatihanSearchOption> createState() => _LatihanSearchOptionState();
}

class _LatihanSearchOptionState extends State<LatihanSearchOption> {
  final SearchController _searchController = SearchController();
  bool _urutAZ = true;

  final List<Mahasiswa> _mahasiswa = [
    const Mahasiswa('Muhamad Alawi', '241011750032'),
    const Mahasiswa('Siti Aisyah', '241011750011'),
    const Mahasiswa('Budi Santoso', '241011750015'),
    const Mahasiswa('Dewi Lestari', '241011750021'),
    const Mahasiswa('Rizky Pratama', '241011750027'),
    const Mahasiswa('Nur Fadilah', '241011750030'),
    const Mahasiswa('Andi Saputra', '241011750036'),
    const Mahasiswa('Fitri Handayani', '241011750041'),
    const Mahasiswa('Agus Setiawan', '241011750044'),
    const Mahasiswa('Rina Marlina', '241011750049'),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Mahasiswa> _filter(String kataKunci) {
    final q = kataKunci.trim().toLowerCase();
    final hasil = _mahasiswa
        .where((m) =>
            m.nama.toLowerCase().contains(q) || m.nim.contains(q))
        .toList();
    hasil.sort((a, b) =>
        _urutAZ ? a.nama.compareTo(b.nama) : b.nama.compareTo(a.nama));
    return hasil;
  }

  void _onMenuDipilih(MenuOpsi opsi) {
    switch (opsi) {
      case MenuOpsi.tambah:
        _tambahData();
      case MenuOpsi.pengaturan:
        _pengaturan();
      case MenuOpsi.info:
        showAboutDialog(
          context: context,
          applicationName: 'Data Mahasiswa',
          applicationVersion: '1.0.0',
          applicationIcon: const Icon(Icons.school, size: 36),
          children: const [
            Text('Contoh Search View (SearchAnchor) dan Option Menu '
                '(PopupMenuButton) pada Flutter.'),
          ],
        );
      case MenuOpsi.keluar:
        _keluar();
    }
  }

  Future<void> _tambahData() async {
    final baru = await showDialog<Mahasiswa>(
      context: context,
      builder: (_) => const _TambahDialog(),
    );
    if (baru == null || !mounted) return;
    setState(() => _mahasiswa.add(baru));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${baru.nama} ditambahkan')),
    );
  }

  Future<void> _pengaturan() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          title: const Text('Pengaturan'),
          content: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Urutkan nama A-Z'),
            subtitle: Text(_urutAZ ? 'A ke Z' : 'Z ke A'),
            value: _urutAZ,
            onChanged: (v) {
              setDialog(() {});
              setState(() => _urutAZ = v);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _keluar() async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Yakin ingin keluar dari halaman ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (yakin == true && mounted) Navigator.pop(context);
  }

  PopupMenuItem<MenuOpsi> _item(MenuOpsi value, IconData icon, String label) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final daftar = _filter(_searchController.text);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa'),
        actions: [
          PopupMenuButton<MenuOpsi>(
            tooltip: 'Menu',
            onSelected: _onMenuDipilih,
            itemBuilder: (_) => [
              _item(MenuOpsi.tambah, Icons.person_add, 'Tambah Data'),
              _item(MenuOpsi.pengaturan, Icons.settings, 'Pengaturan'),
              _item(MenuOpsi.info, Icons.info_outline, 'Informasi Aplikasi'),
              const PopupMenuDivider(),
              _item(MenuOpsi.keluar, Icons.logout, 'Keluar'),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SearchAnchor.bar(
              searchController: _searchController,
              barHintText: 'Cari nama mahasiswa...',
              suggestionsBuilder: (context, controller) {
                return _filter(controller.text).map(
                  (m) => ListTile(
                    leading: const Icon(Icons.person_search),
                    title: Text(m.nama),
                    subtitle: Text(m.nim),
                    onTap: () => controller.closeView(m.nama),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('${daftar.length} dari ${_mahasiswa.length} mahasiswa'),
            ),
          ),
          Expanded(
            child: daftar.isEmpty
                ? const Center(child: Text('Data tidak ditemukan'))
                : ListView.builder(
                    itemCount: daftar.length,
                    itemBuilder: (context, i) {
                      final m = daftar[i];
                      return ListTile(
                        leading: CircleAvatar(child: Text(m.nama[0])),
                        title: Text(m.nama),
                        subtitle: Text('NIM: ${m.nim}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _TambahDialog extends StatefulWidget {
  const _TambahDialog();

  @override
  State<_TambahDialog> createState() => _TambahDialogState();
}

class _TambahDialogState extends State<_TambahDialog> {
  final _namaC = TextEditingController();
  final _nimC = TextEditingController();

  @override
  void dispose() {
    _namaC.dispose();
    _nimC.dispose();
    super.dispose();
  }

  void _simpan() {
    final nama = _namaC.text.trim();
    if (nama.isEmpty) return;
    final nim = _nimC.text.trim();
    Navigator.pop(context, Mahasiswa(nama, nim.isEmpty ? '-' : nim));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Mahasiswa'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _namaC,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Nama'),
          ),
          TextField(
            controller: _nimC,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'NIM'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _simpan,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
