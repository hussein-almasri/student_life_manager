import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {
      'darkMode': darkMode,
      'notificationsEnabled': notificationsEnabled,
      'languageCode': languageCode,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      darkMode: map['darkMode'] ?? false,
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      languageCode: map['languageCode'] ?? 'ar',
    );
  }

  // ✅ هذا المهم
  String toJson() => jsonEncode(toMap());

  factory AppSettings.fromJson(String source) =>
      AppSettings.fromMap(jsonDecode(source));
}
