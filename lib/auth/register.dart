import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _storage = GetStorage();

  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureKonfirmasiPassword = true;

  String? _jenisKelamin;
  String? _semester;

  final List<String> _daftarMinat = [
    'Mobile Development',
    'Web Development',
    'UI/UX Design',
    'Data Science',
    'Cyber Security',
    'Artificial Intelligence',
  ];

  final List<String> _minatTerpilih = [];

  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  Future<void> _daftar() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (_jenisKelamin == null) {
      _showMessage('Silakan pilih jenis kelamin.');
      return;
    }

    if (_minatTerpilih.isEmpty) {
      _showMessage('Pilih minimal satu minat atau keahlian.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dataUser = {
        'nama': _namaController.text.trim(),
        'nim': _nimController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'jenisKelamin': _jenisKelamin,
        'semester': _semester,
        'minat': List<String>.from(_minatTerpilih),
      };

      await _storage.write('data_user', dataUser);

      if (!mounted) return;

      _showSuccessDialog(
        nama: _namaController.text.trim(),
        email: _emailController.text.trim(),
      );
    } catch (e) {
      if (!mounted) return;
      _showMessage('Gagal menyimpan data. Silakan coba lagi.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  void _showSuccessDialog({required String nama, required String email}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFD1FAE5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF10B981),
              size: 42,
            ),
          ),
          title: const Text(
            'Registrasi Berhasil!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF0F172A),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Akun mahasiswa kamu telah berhasil disimpan di storage lokal perangkat.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blueGrey,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 16,
                          color: Color(0xFF2563EB),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            nama,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          size: 16,
                          color: Color(0xFF2563EB),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            email,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Silakan login menggunakan email & password yang telah didaftarkan.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.login_rounded, size: 18),
                label: const Text(
                  'Lanjut ke Halaman Login',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2563EB), size: 22),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          'Registrasi Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDBEAFE),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.person_add_alt_1,
                              color: Color(0xFF2563EB),
                              size: 34,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'Buat Akun Mahasiswa',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'Lengkapi informasi diri kamu.',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        _sectionTitle('Data Pribadi', Icons.person_outline),

                        _fieldLabel('Nama Lengkap'),
                        TextFormField(
                          controller: _namaController,
                          textCapitalization: TextCapitalization.words,
                          decoration: _inputDecoration(
                            hint: 'Masukkan nama lengkap',
                            icon: Icons.badge_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama wajib diisi.';
                            }
                            if (value.trim().length < 3) {
                              return 'Nama minimal 3 karakter.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _fieldLabel('NIM'),
                        TextFormField(
                          controller: _nimController,
                          keyboardType: TextInputType.text,
                          decoration: _inputDecoration(
                            hint: 'Masukkan NIM',
                            icon: Icons.numbers,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'NIM wajib diisi.';
                            }
                            if (value.trim().length < 5) {
                              return 'NIM minimal 5 karakter.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _fieldLabel('Email'),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration(
                            hint: 'contoh@email.com',
                            icon: Icons.email_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email wajib diisi.';
                            }

                            final emailPattern = RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            );

                            if (!emailPattern.hasMatch(value.trim())) {
                              return 'Format email tidak valid.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        _fieldLabel('Password'),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration:
                              _inputDecoration(
                                hint: 'Minimal 6 karakter',
                                icon: Icons.lock_outline,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password wajib diisi.';
                            }
                            if (value.length < 6) {
                              return 'Password minimal 6 karakter.';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        _fieldLabel('Konfirmasi Password'),
                        TextFormField(
                          controller: _konfirmasiPasswordController,
                          obscureText: _obscureKonfirmasiPassword,
                          decoration:
                              _inputDecoration(
                                hint: 'Masukkan ulang password',
                                icon: Icons.lock_reset_outlined,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureKonfirmasiPassword =
                                          !_obscureKonfirmasiPassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureKonfirmasiPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Konfirmasi password wajib diisi.';
                            }
                            if (value != _passwordController.text) {
                              return 'Konfirmasi password tidak cocok.';
                            }
                            return null;
                          },
                        ),

                        _sectionTitle(
                          'Informasi Akademik',
                          Icons.school_outlined,
                        ),
                        _fieldLabel('Jenis Kelamin'),
                        RadioGroup<String>(
                          groupValue: _jenisKelamin,
                          onChanged: (value) {
                            setState(() => _jenisKelamin = value);
                          },
                          child: const Column(
                            children: [
                              RadioListTile<String>(
                                value: 'Laki-laki',
                                title: Text('Laki-laki'),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              ),
                              RadioListTile<String>(
                                value: 'Perempuan',
                                title: Text('Perempuan'),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
                        _fieldLabel('Semester'),
                        DropdownButtonFormField<String>(
                          initialValue: _semester,
                          isExpanded: true,
                          decoration: _inputDecoration(
                            hint: 'Pilih semester',
                            icon: Icons.menu_book_outlined,
                          ),
                          items: List.generate(
                            8,
                            (index) => DropdownMenuItem<String>(
                              value: '${index + 1}',
                              child: Text('Semester ${index + 1}'),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() => _semester = value);
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Semester wajib dipilih.';
                            }
                            return null;
                          },
                        ),

                        _sectionTitle(
                          'Minat atau Keahlian',
                          Icons.interests_outlined,
                        ),
                        const Text(
                          'Pilih satu atau lebih bidang yang kamu minati.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 10),

                        ..._daftarMinat.map((minat) {
                          return CheckboxListTile(
                            value: _minatTerpilih.contains(minat),
                            title: Text(
                              minat,
                              style: const TextStyle(fontSize: 14),
                            ),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: const Color(0xFF2563EB),
                            onChanged: (checked) {
                              setState(() {
                                if (checked == true) {
                                  _minatTerpilih.add(minat);
                                } else {
                                  _minatTerpilih.remove(minat);
                                }
                              });
                            },
                          );
                        }),

                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton(
                            onPressed: _isLoading ? null : _daftar,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Daftar Sekarang',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Center(
                          child: Text(
                            'Data kamu disimpan secara lokal di perangkat.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
