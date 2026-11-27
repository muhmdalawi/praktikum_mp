import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:praktikum_mp2/pertemuan/pertemuan_6/tugas.dart';

void main() {
  testWidgets('Tugas Pertemuan 6 renders 3 tabs: Form Page, Latihan 1, Latihan 2',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: TugasPertemuan6(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Form Page'), findsOneWidget);
    expect(find.text('Latihan 1'), findsOneWidget);
    expect(find.text('Latihan 2'), findsOneWidget);
    expect(find.text('Form Mahasiswa'), findsOneWidget);

    final simpanFormBtn = find.text('Simpan Data');
    await tester.ensureVisible(simpanFormBtn);
    await tester.tap(simpanFormBtn);
    await tester.pumpAndSettle();

    expect(find.text('Nama lengkap wajib diisi'), findsOneWidget);

    await tester.tap(find.widgetWithText(Tab, 'Latihan 1'));
    await tester.pumpAndSettle();

    expect(find.text('Form Biodata Mahasiswa'), findsOneWidget);

    final simpanBiodataBtn = find.text('SIMPAN BIODATA');
    await tester.ensureVisible(simpanBiodataBtn);
    await tester.tap(simpanBiodataBtn);
    await tester.pumpAndSettle();

    expect(find.text('NIM wajib diisi'), findsOneWidget);

    await tester.tap(find.widgetWithText(Tab, 'Latihan 2'));
    await tester.pumpAndSettle();

    expect(find.text('Form Registrasi'), findsOneWidget);
    expect(find.text('DAFTAR'), findsOneWidget);
  });
}
