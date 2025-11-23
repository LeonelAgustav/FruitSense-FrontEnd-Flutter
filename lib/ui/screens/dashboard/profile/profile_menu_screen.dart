import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';
import 'profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch ProfileProvider agar UI update otomatis saat data user masuk
    final profileProvider = context.watch<ProfileProvider>();
    final user = profileProvider.user; // Data user asli dari backend
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Profile Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              child: Column(
                children: [
                  const Text(
                    "Profil Saya",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Kelola informasi akun dan pengaturan aplikasi",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: theme.dividerColor.withValues(alpha: 0.2),
            ),

            // 2. Account Info Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Foto Profil Avatar
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.surfaceContainerHighest,
                      // Jika ada URL Avatar, tampilkan gambar
                      image:
                          (user?.avatarUrl != null &&
                              user!.avatarUrl!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(user.avatarUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: (user?.avatarUrl == null || user!.avatarUrl!.isEmpty)
                        ? Center(
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: AppColors.greenOlive.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Nama User (Tampilkan Loading ... jika belum ada data)
                  Text(
                    user?.name ?? "Memuat...",
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Email User
                  Text(
                    user?.email ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. Settings Card (FIXED: Card structure & Shape)
                  Card(
                    elevation: 2,
                    color: theme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: theme.dividerColor.withValues(alpha: 0.2),
                      ),
                    ),
                    // PENTING: Bungkus konten dalam 'child'
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Pengaturan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.greenOlive,
                            ),
                          ),
                          const SizedBox(height: 12),

                          _buildMenuItem(
                            context,
                            icon: Icons.notifications,
                            title: "Notifikasi",
                            subtitle: "Atur preferensi notifikasi",
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.PROFILE_NOTIFICATIONS,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(
                              color: theme.dividerColor.withValues(alpha: 0.2),
                            ),
                          ),

                          _buildMenuItem(
                            context,
                            icon: Icons.settings,
                            title: "Pengaturan Aplikasi",
                            subtitle: "Bahasa, tema, dan lainnya",
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.PROFILE_SETTINGS,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 4. Logout Button (FIXED: ElevatedButton style)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Logout Logic: Clear prefs dan kembali ke Login
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.LOGIN,
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.exit_to_app, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Keluar",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // Bottom padding untuk Navbar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.greenDark.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.greenDark, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
