# مكون التحميل (Loading Dialog)

## الوصف
مكون تحميل جميل ومتجاوب يستخدم Lottie animation لعرض حالة التحميل عند رفع المحتوى في تطبيق النظافة.

## المميزات
- ✅ استخدام Lottie animation من ملف `assets/lottie/loading.json`
- ✅ تصميم متجاوب مع جميع أحجام الشاشات
- ✅ دعم اللغتين العربية والإنجليزية
- ✅ رسائل مخصصة حسب نوع المحتوى
- ✅ تصميم جميل مع ظلال وحواف مدورة
- ✅ إمكانية إغلاق التحميل أو منعه

## الاستخدام

### 1. استيراد المكون
```dart
import '../../../../core/widget/loading_dialog.dart';
```

### 2. إظهار التحميل
```dart
// إظهار التحميل مع رسالة افتراضية
LoadingDialog.show(context);

// إظهار التحميل مع رسالة مخصصة
LoadingDialog.show(
  context,
  message: 'جاري رفع تقرير النظافة...',
);

// إظهار التحميل مع إمكانية الإغلاق
LoadingDialog.show(
  context,
  message: 'جاري الرفع...',
  barrierDismissible: true,
);
```

### 3. إخفاء التحميل
```dart
LoadingDialog.hide(context);
```

## أمثلة الاستخدام

### في شاشة النظافة
```dart
BlocListener<UploadCleaningCubit, UploadState>(
  listener: (context, state) {
    state.maybeWhen(
      loading: () {
        LoadingDialog.show(
          context,
          message: context.translate('cleaningUpload'),
        );
      },
      success: (message) {
        LoadingDialog.hide(context);
        _showSuccessDialog(message);
      },
      error: (error) {
        LoadingDialog.hide(context);
        _showErrorSnackbar(error);
      },
      orElse: () {},
    );
  },
),
```

### في شاشة التلفيات
```dart
BlocListener<UploadDamageCubit, UploadState>(
  listener: (context, state) {
    state.maybeWhen(
      loading: () {
        LoadingDialog.show(
          context,
          message: context.translate('damageUpload'),
        );
      },
      success: (message) {
        LoadingDialog.hide(context);
        _showSuccessDialog(message);
      },
      error: (error) {
        LoadingDialog.hide(context);
        _showErrorSnackbar(error);
      },
      orElse: () {},
    );
  },
),
```

## الترجمات المطلوبة

### العربية (ar.json)
```json
{
  "uploading": "جاري الرفع...",
  "pleaseWait": "يرجى الانتظار...",
  "uploadSuccess": "تم الرفع بنجاح",
  "uploadError": "حدث خطأ في الرفع",
  "cleaningUpload": "جاري رفع تقرير النظافة...",
  "damageUpload": "جاري رفع تقرير التلفيات..."
}
```

### الإنجليزية (en.json)
```json
{
  "uploading": "Uploading...",
  "pleaseWait": "Please wait...",
  "uploadSuccess": "Upload successful",
  "uploadError": "Upload error occurred",
  "cleaningUpload": "Uploading cleaning report...",
  "damageUpload": "Uploading damage report..."
}
```

## الملفات المطلوبة
- `assets/lottie/loading.json` - ملف Lottie animation
- `lib/core/widget/loading_dialog.dart` - مكون التحميل
- `lang/ar.json` و `lang/en.json` - ملفات الترجمة

## التصميم
- حجم الـ Lottie animation: 120x120
- الحواف مدورة: 20px
- الظلال: 20px blur مع شفافية 10%
- الخط: Cairo للعربية
- الألوان: تستخدم نظام الألوان الخاص بالتطبيق

## ملاحظات
- تأكد من أن ملف `loading.json` موجود في المسار الصحيح
- تأكد من إضافة الترجمات المطلوبة
- استخدم `LoadingDialog.hide(context)` دائماً لإخفاء التحميل
- يمكن تخصيص الرسالة حسب نوع المحتوى المراد رفعه
