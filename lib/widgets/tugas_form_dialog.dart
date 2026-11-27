import 'package:flutter/material.dart';
import '../pertemuan/pertemuan_12/models/tugas_kuliah.dart';

class TugasFormResult {
  final String judul;
  final String mataKuliah;
  final String deadline;

  const TugasFormResult(this.judul, this.mataKuliah, this.deadline);
}

Future<TugasFormResult?> showTugasFormDialog(
  BuildContext context, {
  TugasKuliah? awal,
}) {
  return showDialog<TugasFormResult>(
    context: context,
    builder: (_) => _TugasFormDialog(awal: awal),
  );
}

class _TugasFormDialog extends StatefulWidget {
  final TugasKuliah? awal;

  const _TugasFormDialog({this.awal});

  @override
  State<_TugasFormDialog> createState() => _TugasFormDialogState();
}

class _TugasFormDialogState extends State<_TugasFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judul;
  late final TextEditingController _mataKuliah;
  late final TextEditingController _deadline;

  bool get _isEdit => widget.awal != null;

  @override
  void initState() {
    super.initState();
    _judul = TextEditingController(text: widget.awal?.judul);
    _mataKuliah = TextEditingController(text: widget.awal?.mataKuliah);
    _deadline = TextEditingController(text: widget.awal?.deadline);
  }

  @override
  void dispose() {
    _judul.dispose();
    _mataKuliah.dispose();
    _deadline.dispose();
    super.dispose();
  }

  String? _wajib(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Tidak boleh kosong' : null;

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      TugasFormResult(_judul.text, _mataKuliah.text, _deadline.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Ubah Tugas' : 'Tambah Tugas'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _judul,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Judul Tugas'),
                validator: _wajib,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mataKuliah,
                decoration: const InputDecoration(labelText: 'Mata Kuliah'),
                validator: _wajib,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _deadline,
                decoration: const InputDecoration(
                  labelText: 'Deadline',
                  hintText: 'contoh: 12 Des 2026',
                ),
                validator: _wajib,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _simpan,
          child: Text(_isEdit ? 'Simpan' : 'Tambah'),
        ),
      ],
    );
  }
}
