# Praktikum Mobile Programming - Pertemuan 6
## Topik: Form Flutter (TextFormField, Radio Button, & Checkbox)

Dokumentasi ini dibuat untuk mempermudah pemahaman alur kode dan penjelasan saat presentasi atau tanya-jawab di hadapan dosen pengampu.

---

## 📁 1. Struktur File & Arsitektur Kode

Modul Pertemuan 6 dirancang secara modular dan terpisah menjadi beberapa file agar kode rapi, mudah dibaca, dan tidak menumpuk dalam satu file:

| File | Komponen | Deskripsi & Peran |
| :--- | :--- | :--- |
| `lib/pertemuan/pertemuan_6/tugas.dart` | `TugasPertemuan6` | **Halaman Utama Navigasi:** Mengatur 3 Tab (`DefaultTabController`, `TabBar`, dan `TabBarView`) untuk beralih antara Form Page, Latihan 1, dan Latihan 2. |
| `lib/pertemuan/pertemuan_6/form_page.dart` | `FormPage` | **Materi Praktikum:** Form Mahasiswa berdesain seragam dengan dialog konfirmasi (`AlertDialog`). |
| `lib/pertemuan/pertemuan_6/tugas/latihan_1.dart` | `Latihan1Biodata` | **Latihan 1:** Form Biodata Mahasiswa lengkap dengan validasi wajib isi, format email, pilihan gender radio, checkbox hobi, dan kartu hasil. |
| `lib/pertemuan/pertemuan_6/tugas/latihan_2.dart` | `Latihan2Registrasi` | **Latihan 2:** Form Registrasi Mahasiswa sesuai mockup modul praktikum (TextFormField, Radio Gender & Semester, Checkbox Minat kotak, kartu hasil). |

---

## 📝 2. Penjelasan Latihan 1: Form Biodata Mahasiswa (`latihan_1.dart`)

### A. Persyaratan Sesuai Modul:
1. Form biodata mahasiswa.
2. Kolom input minimal: **Nama Lengkap**, **NIM**, **Email**, dan **Nomor HP**.
3. Pilihan Jenis Kelamin menggunakan **Radio Button**.
4. Pilihan Hobi menggunakan minimal 3 **Checkbox** (disediakan 4 pilihan: *Membaca, Olahraga, Coding, Musik*).
5. Input **Nama**, **NIM**, dan **Email** wajib divalidasi.
6. Tombol **SIMPAN BIODATA** untuk menampilkan seluruh hasil input.

### B. Alur Logika Kode:
1. **Validasi Form (`_formKey`):**
   - Menggunakan `GlobalKey<FormState>()`.
   - Pada `TextFormField`, properti `validator: (value) {...}` mengecek apakah kolom kosong atau apakah format email memiliki karakter `@` dan `.`.
2. **Radio Button (Jenis Kelamin):**
   - Variabel state: `String _gender = 'L';`
   - Menggunakan widget `RadioGroup<String>` dan `Radio<String>`. Karena radio bersifat *mutually exclusive* (hanya boleh memilih satu), pilihan diperbarui melalui `setState(() => _gender = value)`.
3. **Checkbox (Hobi):**
   - Variabel state: `Map<String, bool> _hobi = {...};`
   - Menggunakan kotak `Checkbox` yang dibungkus `InkWell` agar seluruh baris responsif saat diklik. Status centang disimpan sebagai boolean (`true`/`false`).
4. **Menampilkan Hasil (Inline Result Card):**
   - Ketika tombol **SIMPAN BIODATA** ditekan, fungsi `_simpan()` memanggil `_formKey.currentState!.validate()`.
   - Jika valid, data ditampung dalam Map `_hasilBiodata` dan langsung ditampilkan pada kontainer hasil hijau di bawah form.

---

## 📝 3. Penjelasan Latihan 2: Form Registrasi Mahasiswa (`latihan_2.dart`)

### A. Persyaratan Sesuai Modul:
1. **TextFormField:** Nama Lengkap, NIM, Program Studi.
2. **Radio Button:**
   - Jenis Kelamin: `L` / `P`
   - Pilihan Semester: `2` / `4` / `6` / `8`
3. **Checkbox Minat:** `Coding`, `Membaca`, `Gaming`, `Olahraga` dengan kotak centang persegi yang tegas.
4. **Tombol DAFTAR:** Setelah ditekan, menampilkan seluruh data yang dipilih ke layar.

### B. Alur Logika Kode:
1. **Input Teks:**
   - Tiga kontroler teks: `_namaController`, `_nimController`, dan `_prodiController`.
   - Dilengkapi validasi teks wajib diisi.
2. **Radio Button Berganda:**
   - Kelompok 1: `_gender` untuk memilih L atau P.
   - Kelompok 2: `_semester` untuk memilih Semester 2, 4, 6, atau 8.
3. **Checkbox Minat:**
   - Menggunakan widget `Checkbox` dengan `RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))` yang rapi dan konsisten dengan wireframe tugas.
4. **Eksekusi Tombol DAFTAR:**
   - Menjalankan fungsi `_daftar()`.
   - Mengumpulkan seluruh minat yang bernilai `true` dan menyajikan data terverifikasi di kartu hasil pendaftaran.

---

## 📝 4. Penjelasan Materi Form Mahasiswa (`form_page.dart`)

### A. Konsep & Komponen (Desain Seragam dengan Tugas):
1. **Desain Seragam & Rapi:**
   - Memakai kontainer kartu dengan radius sudut 16, bayangan halus, dan tombol **Reset Form** (`Icons.refresh`) di bagian kanan atas judul kartu.
   - Kolom input `TextFormField` untuk Nama Lengkap dan Email dengan border `OutlineInputBorder()`.
2. **Radio Button & Checkbox Seragam:**
   - **Radio Button Jenis Kelamin:** Menggunakan widget `RadioGroup<String>` dengan pilihan Laki-laki / Perempuan yang dibungkus kotak chip berborder warna teal saat aktif (`Color(0xFF0F766E)`).
   - **Checkbox Hobi:** Menggunakan kotak centang asli `Checkbox` persegi dengan sudut membulat kecil (radius 4) di dalam wadah chip yang responsif sentuhan.
3. **Validasi Sederhana:**
   - Nama: Cek `value.trim().isEmpty`.
   - Email: Cek apakah ada karakter `'@'` dan `'.'`. Sederhana dan mudah dijelaskan.
4. **Feedback Menggunakan Modal Dialog (`AlertDialog`):**
   - Menggunakan `showDialog(context: context, builder: ...)`.
   - Menampilkan pop-up dialog rapi berisi data Nama, Email, Jenis Kelamin, dan Hobi, serta tombol **Tutup** (`Navigator.pop(context)`).
5. **Dukungan Mode Semat (`isEmbedded`):**
   - Parameter `isEmbedded` bertipe `bool` (default `true`): Merender langsung widget form ke dalam tab `TabBarView` tanpa `Scaffold` dan `AppBar` ganda.

### B. Cara Menjelaskan `form_page.dart` ke Dosen (Versi Cepat & Jelas):
> *"Pak/Bu, di file `form_page.dart` ini kodenya dirancang seragam dengan halaman Latihan Tugas:*  
> 1. *Desain kontainer kartunya konsisten dengan tombol reset form di pojok kanan atas.*  
> 2. *Untuk input teks, kami gunakan dua `TextEditingController` untuk Nama dan Email lengkap dengan validasi.*  
> 3. *Untuk Jenis Kelamin, kami pakai `RadioGroup` dengan kotak pilihan beraksen warna teal.*  
> 4. *Untuk Hobi, kami simpan di `Map<String, bool>` dengan widget `Checkbox` persegi yang rapi.*  
> 5. *Terakhir saat tombol **Simpan Data** ditekan, jika valid maka datanya ditampilkan lewat modal pop-up `AlertDialog` menggunakan `showDialog()`."*

---

## 💡 5. Perbandingan 3 Pendekatan Komponen Form

| Aspek | Form Page (`form_page.dart`) | Latihan 1 (`latihan_1.dart`) | Latihan 2 (`latihan_2.dart`) |
| :--- | :--- | :--- | :--- |
| **Gaya Kartu & Tombol** | Card Container + Tombol Reset | Card Container + Tombol Reset | Card Container + Tombol Reset |
| **Penyajian Radio** | Custom Chip Row + `Radio` | Custom Chip Row + `Radio` | Custom Chip Row + `Radio` |
| **Penyajian Checkbox** | Custom Chip Wrap + `Checkbox` | Custom Chip Wrap + `Checkbox` | Custom Chip Wrap + `Checkbox` |
| **Media Umpan Balik** | Modal Pop-up (`AlertDialog`) | Inline Card (di bawah form) | Inline Card (di bawah form) |
| **Kelebihan** | Desain seragam & dialog modal | Desain seragam & kartu hasil | Desain seragam & register kampus |

---

## 🎯 6. "Cheat Sheet" Pertanyaan Dosen (Panduan Presentasi)

Berikut adalah ringkasan pertanyaan yang sering diajukan dosen saat sesi review tugas beserta jawaban yang tepat:

### Q1: *"Bagaimana cara kerja navigasi 3 Tab di halaman tugas.dart?"*
> **Jawaban:**  
> "Kami membungkus Scaffold dengan widget `DefaultTabController(length: 3, ...)`. Di bagian `appBar.bottom`, kami memasang widget `TabBar` berisi 3 tab (`Latihan 1`, `Latihan 2`, dan `Form Page`). Kemudian di bagian `body`, `TabBarView` memanggil masing-masing class widget secara modular (`Latihan1Biodata()`, `Latihan2Registrasi()`, dan `FormPage(isEmbedded: true)`)."

### Q2: *"Bagaimana mekanisme validasi form di Flutter?"*
> **Jawaban:**  
> "Kami membuat `GlobalKey<FormState>()` lalu menghubungkannya ke widget `Form(key: _formKey)`. Pada setiap `TextFormField`, kami menyematkan fungsi `validator: (value) {...}`. Saat tombol aksi ditekan, kami mengeksekusi `_formKey.currentState!.validate()`. Jika ada nilai yang tidak lolos validasi, Flutter otomatis menampilkan pesan kesalahan di bawah kolom input."

### Q3: *"Apa perbedaan mendasar antara Radio Button dan Checkbox dalam pengelolaan State?"*
> **Jawaban:**  
> - **Radio Button:** Bersifat *single selection* (eksklusif). Hanya satu opsi yang boleh aktif, sehingga cukup disimpan dalam variabel tunggal (misalnya `String _gender = 'L'`).  
> - **Checkbox:** Bersifat *multiple selection* (bisa memilih banyak opsi sekaligus). Statusnya disimpan dalam koleksi seperti `Map<String, bool>` atau `List<String>` agar tiap item memiliki status centang masing-masing (`true`/`false`).

### Q4: *"Kapan kita menggunakan AlertDialog vs Inline Card untuk menampilkan data hasil form?"*
> **Jawaban:**  
> - **`AlertDialog` (seperti pada FormPage):** Cocok untuk konfirmasi ringkas atau pop-up yang membutuhkan perhatian langsung pengguna sebelum melanjutkan.  
> - **Inline Card (seperti pada Latihan 1 & 2):** Cocok ketika data hasil input ingin tetap dapat dilihat sambil pengguna mengedit kembali formulir di layar yang sama tanpa terhalang pop-up dialog.

### Q5: *"Mengapa kita wajib memanggil method dispose() pada TextEditingController?"*
> **Jawaban:**  
> "Karena controller berinteraksi dengan resource sistem operasi untuk mendengarkan perubahan teks. Jika widget dihancurkan (*unmounted*) tanpa memanggil `dispose()`, resource tersebut tetap tertinggal di memori sehingga menyebabkan kebocoran memori (*memory leak*)."
