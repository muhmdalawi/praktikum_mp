import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_badge.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';

class TugasPertemuan8 extends StatelessWidget {
  const TugasPertemuan8({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pertemuan 8'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: AppCard(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE11D48).withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.lock,
                    color: Color(0xFFE11D48),
                    size: 34,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const AppBadge(
                  label: 'Belum Tersedia',
                  backgroundColor: Color(0xFFFFE4E6),
                  textColor: Color(0xFFE11D48),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Pertemuan 8: Belum Dimulai',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Modul praktikum Pertemuan 8 belum dimulai. Halaman tugas akan dibuka sesuai jadwal silabus perkuliahan mendatang.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: 'Kembali ke Daftar Materi',
                  icon: LucideIcons.arrowLeft,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
