import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
// PERBAIKAN IMPORT: Karena dalam satu folder/level, langsung panggil nama file
import 'profile_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final currentMode = profileProvider.themeMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan Aplikasi"),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.grey[300]),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            "Tampilan Aplikasi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.greenDark,
            ),
          ),
          const SizedBox(height: 16),

          _buildThemeOption(
            context,
            title: "Mode Terang",
            subtitle: "Tampilan cerah klasik",
            icon: Icons.light_mode_outlined,
            isSelected: currentMode == ThemeMode.light,
            onTap: () => profileProvider.updateTheme('LIGHT'),
          ),
          const SizedBox(height: 12),

          _buildThemeOption(
            context,
            title: "Mode Gelap",
            subtitle: "Nyaman untuk mata",
            icon: Icons.dark_mode_outlined,
            isSelected: currentMode == ThemeMode.dark,
            onTap: () => profileProvider.updateTheme('DARK'),
          ),
          const SizedBox(height: 12),

          _buildThemeOption(
            context,
            title: "Ikuti Sistem",
            subtitle: "Menyesuaikan pengaturan HP",
            icon: Icons.settings_system_daydream_outlined,
            isSelected: currentMode == ThemeMode.system,
            onTap: () => profileProvider.updateTheme('SYSTEM'),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.greenDark.withValues(alpha: 0.1)
              : theme.cardColor,
          border: Border.all(
            color: isSelected
                ? AppColors.greenDark
                : theme.dividerColor.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.greenDark : Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? AppColors.greenDark
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.radio_button_checked, color: AppColors.greenDark)
            else
              const Icon(Icons.radio_button_unchecked, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
