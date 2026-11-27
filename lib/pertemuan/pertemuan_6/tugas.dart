import 'package:flutter/material.dart';
import 'form_page.dart';
import 'tugas/latihan_1.dart';
import 'tugas/latihan_2.dart';

class TugasPertemuan6 extends StatelessWidget {
  const TugasPertemuan6({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pertemuan 6'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.assignment_outlined), text: 'Form Page'),
              Tab(icon: Icon(Icons.person_outline), text: 'Latihan 1'),
              Tab(icon: Icon(Icons.app_registration), text: 'Latihan 2'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [FormPage(), Latihan1Biodata(), Latihan2Registrasi()],
        ),
      ),
    );
  }
}
