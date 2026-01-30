class AppSettings {
  final bool darkMode;
  final String languageCode;

  const AppSettings({
    required this.darkMode,
    required this.languageCode,
  });

  /// الإعدادات الافتراضية حسب لغة الجهاز
  factory AppSettings.defaultSettings(String deviceLang) {
    return AppSettings(
      darkMode: false,
      languageCode: deviceLang,
    );
  }

  /// نسخة معدّلة من الإعدادات
  AppSettings copyWith({
    bool? darkMode,
    String? languageCode,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  /// تحويل إلى Map للتخزين
  Map<String, dynamic> toMap() {
    return {
      'darkMode': darkMode,
      'languageCode': languageCode,
    };
  }

  /// إنشاء من Map
  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      darkMode: map['darkMode'] as bool? ?? false,
      languageCode: map['languageCode'] as String? ?? 'ar',
    );
  }
}
