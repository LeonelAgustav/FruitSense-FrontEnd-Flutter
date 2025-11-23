import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabSelected;

  const BottomNavigationBarWidget({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24.0),
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.greenDark,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(index: 0, icon: Icons.camera_alt, label: "Scan"),
          _buildNavItem(index: 1, icon: Icons.inventory_2, label: "Inventory"),
          _buildNavItem(index: 2, icon: Icons.history, label: "History"),
          _buildNavItem(index: 3, icon: Icons.person, label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = selectedTab == index;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              // FIX: withValues pengganti withOpacity
              color: isSelected
                  ? AppColors.white.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20.0),
            ),
            // FIX: Menggunakan diagonal3Values untuk scale uniform
            transform: Matrix4.diagonal3Values(
              isSelected ? 1.1 : 1.0,
              isSelected ? 1.1 : 1.0,
              1.0,
            ),
            child: Icon(
              icon,
              size: 26,
              color: isSelected
                  ? AppColors.white
                  : AppColors.white.withValues(alpha: 0.6),
            ),
          ),

          const SizedBox(height: 4),
          AnimatedOpacity(
            opacity: isSelected ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: isSelected
                ? Text(
                    label,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
