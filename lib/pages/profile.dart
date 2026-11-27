import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:praktikum_mp2/auth/login.dart';
import '../theme/app_theme.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_card.dart';
import '../widgets/animated_pressable.dart';
import '../widgets/staggered_entrance.dart';

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool>? onToggleTheme;

  const ProfilePage({super.key, this.isDarkMode = false, this.onToggleTheme});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;

  late AnimationController _floatController;
  late Animation<double> _floatAnimation1;
  late Animation<double> _floatAnimation2;

  Map<String, dynamic> _userData = {};
  String _dataSource = 'default';
  VoidCallback? _storageListener;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Dengarkan perubahan GetStorage secara real-time
    _storageListener = GetStorage().listen(() {
      if (mounted) {
        _loadUserData();
      }
    });

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _floatAnimation1 = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );

    _floatAnimation2 = Tween<double>(begin: 5.0, end: -5.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _storageListener?.call();
    _floatController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final box = GetStorage();
    final currentUser = box.read('current_user');
    final dataUser = box.read('data_user');

    if (currentUser != null && currentUser is Map) {
      setState(() {
        _userData = Map<String, dynamic>.from(currentUser);
        _dataSource = 'current_user';
      });
    } else if (dataUser != null && dataUser is Map) {
      setState(() {
        _userData = Map<String, dynamic>.from(dataUser);
        _dataSource = 'data_user';
      });
    } else {
      setState(() {
        _userData = {
          'nama': 'Muhamad Alawi',
          'nim': '241011750032',
          'email': 'alawi@gmail.com',
          'jenisKelamin': 'Laki-laki',
          'semester': '4',
          'minat': <String>['Mobile Development', 'UI/UX Design'],
        };
        _dataSource = 'default';
      });
    }
  }

  String get _nama {
    final val = _userData['nama']?.toString().trim();
    return (val != null && val.isNotEmpty) ? val : 'Muhamad Alawi';
  }

  String get _nim {
    final val = _userData['nim']?.toString().trim();
    return (val != null && val.isNotEmpty) ? val : '241011750032';
  }

  String get _email {
    final val = _userData['email']?.toString().trim();
    return (val != null && val.isNotEmpty) ? val : 'alawi@gmail.com';
  }

  String get _jenisKelamin {
    final val = _userData['jenisKelamin']?.toString().trim();
    return (val != null && val.isNotEmpty) ? val : 'Laki-laki';
  }

  String get _semester {
    final val = _userData['semester']?.toString().trim();
    return (val != null && val.isNotEmpty) ? val : '4';
  }

  List<String> get _minat {
    final raw = _userData['minat'];
    if (raw is List && raw.isNotEmpty) {
      return raw.map((e) => e.toString()).toList();
    }
    if (_dataSource == 'default') {
      return const ['Mobile Development', 'UI/UX Design'];
    }
    return const [];
  }

  String get _dataSourceLabel {
    switch (_dataSource) {
      case 'current_user':
        return 'Sesi Aktif (current_user)';
      case 'data_user':
        return 'Data Registrasi (data_user)';
      default:
        return 'Data Default';
    }
  }

  void _showPhotoDetailDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(200),
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: AnimatedPressable(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.x,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 30,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      "assets/images/profile.png",
                      width: 280,
                      height: 280,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceDark.withAlpha(235)
                        : Colors.white.withAlpha(235),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _nama,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'NIM $_nim • Semester $_semester • Sistem Informasi',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.sm,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    'Foto profil berhasil disimpan ke galeri.',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(LucideIcons.download, size: 16),
                            label: const Text('Simpan'),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.sm,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              _showShareSheet();
                            },
                            icon: const Icon(LucideIcons.share2, size: 16),
                            label: const Text('Bagikan'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showShareSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.borderDark : AppColors.border,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Bagikan Profil Mahasiswa',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                '$_nama • $_nim\n$_email\nSemester $_semester - Program Studi Sistem Informasi - Universitas Pamulang',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text('Tautan profil $_nama disalin ke clipboard!'),
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.copy, size: 16),
                  label: const Text('Salin Informasi'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xxl),
          ),
          icon: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.errorSubtle,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.logOut,
              color: AppColors.error,
              size: 28,
            ),
          ),
          title: const Text('Konfirmasi Keluar', textAlign: TextAlign.center),
          content: Text(
            'Apakah Anda yakin ingin keluar dari sesi aplikasi? Data akun Anda tetap tersimpan di perangkat sehingga dapat login kembali.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final box = GetStorage();
                await box.remove('is_logged_in');
                await box.remove('current_user');

                if (!context.mounted) return;

                Navigator.pop(context);

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xxl),
          ),
          icon: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.error.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.trash2,
              color: AppColors.error,
              size: 28,
            ),
          ),
          title: const Text('Hapus Akun & Storage?', textAlign: TextAlign.center),
          content: Text(
            'Apakah Anda yakin ingin menghapus akun? Seluruh data akun Anda di penyimpanan lokal (data_user, current_user, dan sesi login) akan dihapus secara permanen dari perangkat.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final box = GetStorage();
                await box.remove('data_user');
                await box.remove('current_user');
                await box.remove('is_logged_in');
                await box.erase();

                if (!context.mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      'Akun dan seluruh data di storage berhasil dihapus.',
                    ),
                  ),
                );

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
              child: const Text('Ya, Hapus Akun'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingIconBadge({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs + 3),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : bgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withAlpha(isDark ? 90 : 60),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(isDark ? 40 : 35),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, size: 14, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final badges = [
      {
        'label': _minat.isNotEmpty ? _minat.first : 'Flutter Dev',
        'icon': LucideIcons.code,
        'color': AppColors.info,
      },
      {
        'label': 'Sem. $_semester',
        'icon': LucideIcons.graduationCap,
        'color': AppColors.success,
      },
      {
        'label': _minat.length > 1 ? _minat[1] : 'UI Wizard',
        'icon': LucideIcons.palette,
        'color': AppColors.secondary,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        actions: [
          IconButton(
            tooltip: 'Segarkan Data Storage',
            icon: const Icon(LucideIcons.refreshCw, size: 19),
            onPressed: () {
              _loadUserData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                  content: Text('Data profil diperbarui dari: $_dataSourceLabel'),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Bagikan Profil',
            icon: const Icon(LucideIcons.share2, size: 20),
            onPressed: _showShareSheet,
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          100,
        ),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            StaggeredEntrance(
              index: 0,
              child: AppCard(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    SizedBox(
                      width: 170,
                      height: 140,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          AnimatedPressable(
                            onTap: () => _showPhotoDetailDialog(context),
                            scaleDown: 0.96,
                            child: Container(
                              padding: const EdgeInsets.all(3.5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondary,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withAlpha(50),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  const CircleAvatar(
                                    radius: 48,
                                    backgroundColor: AppColors.primarySubtle,
                                    backgroundImage: AssetImage(
                                      "assets/images/profile.png",
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 2,
                                    right: 2,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isDark
                                              ? AppColors.surfaceDark
                                              : Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        LucideIcons.zoomIn,
                                        size: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Positioned(
                            left: 2,
                            top: 8,
                            child: AnimatedBuilder(
                              animation: _floatAnimation1,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _floatAnimation1.value),
                                  child: child,
                                );
                              },
                              child: _buildFloatingIconBadge(
                                icon: LucideIcons.star,
                                color: Colors.amber,
                                bgColor: const Color(0xFFFEF3C7),
                                isDark: isDark,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 2,
                            top: 12,
                            child: AnimatedBuilder(
                              animation: _floatAnimation2,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _floatAnimation2.value),
                                  child: child,
                                );
                              },
                              child: _buildFloatingIconBadge(
                                icon: LucideIcons.sparkles,
                                color: AppColors.primary,
                                bgColor: AppColors.primarySubtle,
                                isDark: isDark,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 6,
                            bottom: 6,
                            child: AnimatedBuilder(
                              animation: _floatAnimation2,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _floatAnimation2.value),
                                  child: child,
                                );
                              },
                              child: _buildFloatingIconBadge(
                                icon: LucideIcons.flame,
                                color: Colors.deepOrange,
                                bgColor: const Color(0xFFFFEDD5),
                                isDark: isDark,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 6,
                            child: AnimatedBuilder(
                              animation: _floatAnimation1,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _floatAnimation1.value),
                                  child: child,
                                );
                              },
                              child: _buildFloatingIconBadge(
                                icon: LucideIcons.shieldCheck,
                                color: AppColors.success,
                                bgColor: AppColors.successSubtle,
                                isDark: isDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _nama,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppBadge(
                      label: 'Mahasiswa Aktif • Semester $_semester',
                      icon: LucideIcons.shieldCheck,
                      backgroundColor: AppColors.primarySubtle,
                      textColor: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.xs + 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm + 2,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _dataSource == 'current_user'
                            ? AppColors.successSubtle
                            : (_dataSource == 'data_user'
                                ? AppColors.infoSubtle
                                : (isDark
                                    ? Colors.white12
                                    : const Color(0xFFF1F5F9))),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                          color: _dataSource == 'current_user'
                              ? AppColors.success.withAlpha(80)
                              : (_dataSource == 'data_user'
                                  ? AppColors.info.withAlpha(80)
                                  : (isDark ? Colors.white24 : AppColors.border)),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.database,
                            size: 11,
                            color: _dataSource == 'current_user'
                                ? AppColors.success
                                : (_dataSource == 'data_user'
                                    ? AppColors.info
                                    : (isDark
                                        ? Colors.white70
                                        : AppColors.textSecondary)),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Sumber: $_dataSourceLabel',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _dataSource == 'current_user'
                                  ? AppColors.success
                                  : (_dataSource == 'data_user'
                                      ? AppColors.info
                                      : (isDark
                                          ? Colors.white70
                                          : AppColors.textSecondary)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: badges.map((badge) {
                        final Color color = badge['color'] as Color;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm + 2,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: color.withAlpha(25),
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
                              border: Border.all(color: color.withAlpha(60)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  badge['icon'] as IconData,
                                  size: 12,
                                  color: color,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  badge['label'] as String,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceDark
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn('4 Modul', 'Tugas Selesai', isDark),
                          Container(
                            height: 32,
                            width: 1,
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.border,
                          ),
                          _buildStatColumn('3.92', 'Indeks Prestasi', isDark),
                          Container(
                            height: 32,
                            width: 1,
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.border,
                          ),
                          _buildStatColumn('50%', 'Progres Modul', isDark),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            StaggeredEntrance(
              index: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Informasi Akademik & Akun',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            StaggeredEntrance(
              index: 2,
              child: AppCard(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Column(
                  children: [
                    _buildInfoTile(
                      LucideIcons.badgeCheck,
                      'Nama Lengkap',
                      _nama,
                      isDark,
                    ),
                    const Divider(indent: 56, endIndent: 16),
                    _buildInfoTile(
                      LucideIcons.hash,
                      'Nomor Induk Mahasiswa (NIM)',
                      _nim,
                      isDark,
                    ),
                    const Divider(indent: 56, endIndent: 16),
                    _buildInfoTile(
                      LucideIcons.mail,
                      'Email Akun',
                      _email,
                      isDark,
                    ),
                    const Divider(indent: 56, endIndent: 16),
                    _buildInfoTile(
                      LucideIcons.user,
                      'Jenis Kelamin',
                      _jenisKelamin,
                      isDark,
                    ),
                    const Divider(indent: 56, endIndent: 16),
                    _buildInfoTile(
                      LucideIcons.bookOpen,
                      'Tingkat Semester',
                      'Semester $_semester',
                      isDark,
                    ),
                    const Divider(indent: 56, endIndent: 16),
                    _buildInfoTile(
                      LucideIcons.graduationCap,
                      'Program Studi',
                      'Sistem Informasi',
                      isDark,
                    ),
                    const Divider(indent: 56, endIndent: 16),
                    _buildInfoTile(
                      LucideIcons.building,
                      'Perguruan Tinggi',
                      'Universitas Pamulang',
                      isDark,
                    ),
                    const Divider(indent: 56, endIndent: 16),
                    _buildInfoTile(
                      LucideIcons.building2,
                      'Fakultas',
                      'Ilmu Komputer',
                      isDark,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            StaggeredEntrance(
              index: 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bidang Minat & Keahlian',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            StaggeredEntrance(
              index: 4,
              child: AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xs + 2),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withAlpha(25),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: const Icon(
                            LucideIcons.sparkles,
                            size: 16,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Pilihan Minat Registrasi',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_minat.length} Bidang',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (_minat.isEmpty)
                      Text(
                        'Belum ada minat yang dipilih saat registrasi.',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    else
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: _minat.map((minat) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs + 2,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.surfaceDark
                                  : const Color(0xFFF1F5F9),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.full),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.borderDark
                                    : const Color(0xFFCBD5E1),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  LucideIcons.checkCircle2,
                                  size: 13,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  minat,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            StaggeredEntrance(
              index: 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Preferensi & Tema',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            StaggeredEntrance(
              index: 4,
              child: AppCard(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Column(
                  children: [
                    // SwitchListTile(
                    //   secondary: Container(
                    //     padding: const EdgeInsets.all(AppSpacing.sm),
                    //     decoration: BoxDecoration(
                    //       color: AppColors.secondary.withAlpha(25),
                    //       borderRadius: BorderRadius.circular(AppRadius.md),
                    //     ),
                    //     child: AnimatedRotation(
                    //       turns: widget.isDarkMode ? 0.5 : 0.0,
                    //       duration: const Duration(milliseconds: 300),
                    //       child: Icon(
                    //         widget.isDarkMode
                    //             ? LucideIcons.moon
                    //             : LucideIcons.sun,
                    //         size: 18,
                    //         color: AppColors.secondary,
                    //       ),
                    //     ),
                    //   ),
                    //   title: const Text(
                    //     'Mode Gelap',
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 14,
                    //     ),
                    //   ),
                    //   subtitle: const Text(
                    //     'Beralih antara tema gelap dan terang',
                    //     style: TextStyle(fontSize: 12),
                    //   ),
                    //   value: widget.isDarkMode,
                    //   onChanged: (val) {
                    //     if (widget.onToggleTheme != null) {
                    //       widget.onToggleTheme!(val);
                    //     }
                    //   },
                    // ),
                    const Divider(indent: 56, endIndent: 16),
                    SwitchListTile(
                      secondary: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.infoSubtle,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: const Icon(
                          LucideIcons.bell,
                          size: 18,
                          color: AppColors.info,
                        ),
                      ),
                      title: const Text(
                        'Notifikasi Praktikum',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: const Text(
                        'Pengingat jadwal tugas mingguan',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: _notificationsEnabled,
                      onChanged: (val) =>
                          setState(() => _notificationsEnabled = val),
                    ),
                    const Divider(indent: 56, endIndent: 16),
                    SwitchListTile(
                      secondary: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.warningSubtle,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: const Icon(
                          LucideIcons.volume2,
                          size: 18,
                          color: AppColors.warning,
                        ),
                      ),
                      title: const Text(
                        'Efek Haptik & Suara',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: const Text(
                        'Umpan balik saat menyentuh komponen',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: _soundEnabled,
                      onChanged: (val) => setState(() => _soundEnabled = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            StaggeredEntrance(
              index: 5,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Aksi & Keamanan Akun',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            StaggeredEntrance(
              index: 6,
              child: AnimatedPressable(
                onTap: _showLogoutDialog,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.errorSubtle,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.error.withAlpha(80)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.logOut,
                        size: 18,
                        color: AppColors.error,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        'Keluar dari Akun (Logout)',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            StaggeredEntrance(
              index: 7,
              child: AnimatedPressable(
                onTap: _showDeleteAccountDialog,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.error.withAlpha(70),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.trash2,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        'Hapus Akun (Delete Account)',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Praktikum Mobile Programming 2 • v1.0.0+1',
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.primarySubtle,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      ),
    );
  }
}
