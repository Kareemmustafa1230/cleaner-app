import 'package:diyar/core/theme/Color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../../home_page/ui/screen/home_screen.dart';
import '../../../setting/ui/screen/settings_screen.dart';
import '../../../reports/ui/screen/reports_screen.dart';
import '../../../inventory/ui/screen/inventory_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<Widget> _pages = [
    const HomePage(),
    const ApartmentsMediaScreen(),
    const InventoryScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavItem({
    required Widget icon,
    required int index,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: isSelected 
            ? LinearGradient(
                colors: [ColorApp.textInverse, ColorApp.textInverse.withOpacity(0.9)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
        color: isSelected ? ColorApp.textInverse : Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: isSelected ? [
          BoxShadow(
            color: ColorApp.shadowDark,
            blurRadius: 18,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
        ] : null,
        border: isSelected ? Border.all(
          color: ColorApp.textInverse.withOpacity(0.3),
          width: 1.5,
        ) : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            scale: isSelected ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: isSelected ? BoxDecoration(
                color: ColorApp.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ) : null,
              child: icon,
            ),
          ),
          if (isSelected) ...[
            SizedBox(height: 4.h),
            Container(
              width: 5.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: ColorApp.primaryBlue,
                borderRadius: BorderRadius.circular(2.5.r),
                boxShadow: [
                  BoxShadow(
                    color: ColorApp.shadowMedium,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorApp.gradientStart,
              ColorApp.gradientEnd,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: ColorApp.shadowDark,
              blurRadius: 25,
              offset: const Offset(0, -8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: SafeArea(
          child: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            color: Colors.transparent,
            buttonBackgroundColor: Colors.transparent,
            height: 75.0,
            animationDuration: const Duration(milliseconds: 500),
            animationCurve: Curves.easeInOutCubic,
            index: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              _buildNavItem(
                icon: Icon(
                  Icons.home_rounded,
                  size: 28.h,
                  color: _selectedIndex == 0 ? ColorApp.primaryBlue : ColorApp.textInverse,
                ),
                index: 0,
                label: 'الرئيسية',
              ),
              _buildNavItem(
                icon: Icon(
                  Icons.analytics_rounded,
                  size: 28.h,
                  color: _selectedIndex == 1 ? ColorApp.primaryBlue : ColorApp.textInverse,
                ),
                index: 1,
                label: 'التقارير',
              ),
              _buildNavItem(
                icon: Icon(
                  Icons.inventory_2_rounded,
                  size: 28.h,
                  color: _selectedIndex == 2 ? ColorApp.primaryBlue : ColorApp.textInverse,
                ),
                index: 2,
                label: 'المخزون',
              ),
              _buildNavItem(
                icon: Icon(
                  Icons.settings_rounded,
                  size: 28.h,
                  color: _selectedIndex == 3 ? ColorApp.primaryBlue : ColorApp.textInverse,
                ),
                index: 3,
                label: 'الإعدادات',
              ),
            ],
          ),
        ),
      ),
    );
  }
}