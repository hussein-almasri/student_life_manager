class AppSettings {
  final bool darkMode;
  final bool notificationsEnabled;
  final String languageCode;

  const AppSettings({
    required this.darkMode,
    required this.notificationsEnabled,
    required this.languageCode,
  });

  /// الإعدادات الافتراضية حسب لغة الجهاز
  factory AppSettings.defaultSettings(String deviceLang) {
    return AppSettings(
      darkMode: false,
      notificationsEnabled: true,
      languageCode: deviceLang,
    );
  }

  /// نسخة معدّلة من الإعدادات
  AppSettings copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
    String? languageCode,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  /// تحويل إلى Map للتخزين في Hive
  Map<String, dynamic> toMap() {
    return {
      'darkMode': darkMode,
      'notificationsEnabled': notificationsEnabled,
      'languageCode': languageCode,
    };
  }

  /// إنشاء من Map (Hive)
  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      darkMode: map['darkMode'] as bool? ?? false,
      notificationsEnabled:
          map['notificationsEnabled'] as bool? ?? true,
      languageCode: map['languageCode'] as String? ?? 'ar',
    );
  }
}
