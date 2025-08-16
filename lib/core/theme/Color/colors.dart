import 'package:flutter/material.dart';

class ColorApp {
  // الألوان الأساسية - درجات الأزرق الدافئ
  static const primaryBlue = Color(0xFF4A6FA5);      // الأزرق الأساسي
  static const secondaryBlue = Color(0xFF6B8BB8);    // الأزرق الثانوي
  static const lightBlue = Color(0xFF8BA3C7);        // الأزرق الفاتح
  static const darkBlue = Color(0xFF2E4A6B);         // الأزرق الداكن
  
  // الألوان المحايدة
  static const white = Color(0xFFFFFFFF);
  static const offWhite = Color(0xFFF8F9FA);
  static const lightGrey = Color(0xFFE9ECEF);
  static const grey = Color(0xFF6C757D);
  static const darkGrey = Color(0xFF495057);
  static const black = Color(0xFF212529);
  
  // ألوان الحالة
  static const success = Color(0xFF28A745);          // أخضر للنجاح
  static const warning = Color(0xFFFFC107);          // أصفر للتحذير
  static const error = Color(0xFFDC3545);            // أحمر للخطأ
  static const info = Color(0xFF17A2B8);             // أزرق للمعلومات
  
  // ألوان التدرجات
  static const gradientStart = Color(0xFF4A6FA5);
  static const gradientEnd = Color(0xFF6B8BB8);
  
  // ألوان الظلال
  static const shadowLight = Color(0x1A000000);
  static const shadowMedium = Color(0x33000000);
  static const shadowDark = Color(0x4D000000);
  
  // ألوان الخلفيات
  static const backgroundPrimary = Color(0xFFFFFFFF);
  static const backgroundSecondary = Color(0xFFF8F9FA);
  static const backgroundTertiary = Color(0xFFE9ECEF);
  
  // ألوان النصوص
  static const textPrimary = Color(0xFF212529);
  static const textSecondary = Color(0xFF6C757D);
  static const textLight = Color(0xFFADB5BD);
  static const textInverse = Color(0xFFFFFFFF);
  
  // ألوان الحدود
  static const borderLight = Color(0xFFE9ECEF);
  static const borderMedium = Color(0xFFCED4DA);
  static const borderDark = Color(0xFFADB5BD);
  
  // ألوان التفاعل
  static const hover = Color(0xFFF8F9FA);
  static const active = Color(0xFFE9ECEF);
  static const disabled = Color(0xFFADB5BD);
  
  // ألوان الحالة للشقق
  static const available = Color(0xFF28A745);        // متاح
  static const rented = Color(0xFFFFC107);           // مؤجر
  static const maintenance = Color(0xFFDC3545);      // صيانة
  
  // ألوان حالة التنظيف
  static const cleaned = Color(0xFF28A745);          // تم التنظيف
  static const cleaning = Color(0xFFFFC107);         // قيد التنظيف
  static const notCleaned = Color(0xFFDC3545);       // لم يتم التنظيف
  
  // ألوان الأولوية
  static const priorityHigh = Color(0xFFDC3545);     // أولوية عالية
  static const priorityMedium = Color(0xFFFFC107);   // أولوية متوسطة
  static const priorityLow = Color(0xFF28A745);      // أولوية منخفضة
  
  // ألوان الحالة للإصلاحات
  static const fixed = Color(0xFF28A745);            // تم الإصلاح
  static const inProgress = Color(0xFFFFC107);       // قيد الإصلاح
  static const pending = Color(0xFFDC3545);          // معلق
  
  // ألوان متوافقة مع النظام القديم (للحفاظ على التوافق)
  static const whiteFF = white;
  static const whiteF3 = offWhite;
  static const black00 = black;
  static const blue8D = primaryBlue;
  static const blueBD = secondaryBlue;
  static const greyC1 = lightGrey;
  static const black18 = darkGrey;
  static const grey6B = grey;
  static const grey61 = darkGrey;
  static const greyD9 = borderLight;
  static const greyF5 = Color(0xFFF5F5F5);
}
