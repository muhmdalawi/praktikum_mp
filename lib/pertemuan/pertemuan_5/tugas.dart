import 'package:flutter/material.dart';

class TugasPertemuan5 extends StatefulWidget {
  const TugasPertemuan5({super.key});

  @override
  State<TugasPertemuan5> createState() => _TugasPertemuan5State();
}

class _TugasPertemuan5State extends State<TugasPertemuan5> {
  String _teks = "Sentuh Kotak Ini";
  Color _warna = Colors.grey;
  int _jumlah = 0;

  void _set(String teks, Color warna) => setState(() {
    _teks = teks;
    _warna = warna;
    _jumlah++;
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pertemuan 5')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _set('Tekan', Colors.blue),
              onDoubleTap: () => _set('Klik Double', Colors.redAccent),
              onLongPress: () => _set('Tekan Kebawah', Colors.cyanAccent),
              child: Container(
                width: 220,
                height: 220,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _warna,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(_teks, style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            Text('Jumlah gesture terdeteksi: $_jumlah'),
          ],
        ),
      ),
    );
  }
}
