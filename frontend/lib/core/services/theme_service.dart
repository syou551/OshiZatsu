import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// テーマ色の定義
class ThemeColors {
  final String name;
  final Color primaryColor;
  final Color primaryLightColor;
  final Color primaryDarkColor;

  const ThemeColors({
    required this.name,
    required this.primaryColor,
    required this.primaryLightColor,
    required this.primaryDarkColor,
  });
}

// プリセットテーマ色
class PresetThemeColors {
  static const List<ThemeColors> colors = [
    ThemeColors(
      name: 'ピンク',
      primaryColor: Color(0xFFFF6B9D),
      primaryLightColor: Color(0xFFFF8FB1),
      primaryDarkColor: Color(0xFFE55A8A),
    ),
    ThemeColors(
      name: 'ブルー',
      primaryColor: Color(0xFF6B9DFF),
      primaryLightColor: Color(0xFF8FB1FF),
      primaryDarkColor: Color(0xFF5A8AE5),
    ),
    ThemeColors(
      name: 'グリーン',
      primaryColor: Color(0xFF4CAF50),
      primaryLightColor: Color(0xFF66BB6A),
      primaryDarkColor: Color(0xFF388E3C),
    ),
    ThemeColors(
      name: 'オレンジ',
      primaryColor: Color(0xFFFF9800),
      primaryLightColor: Color(0xFFFFB74D),
      primaryDarkColor: Color(0xFFF57C00),
    ),
    ThemeColors(
      name: 'パープル',
      primaryColor: Color(0xFF9C27B0),
      primaryLightColor: Color(0xFFBA68C8),
      primaryDarkColor: Color(0xFF7B1FA2),
    ),
    ThemeColors(
      name: 'レッド',
      primaryColor: Color(0xFFE91E63),
      primaryLightColor: Color(0xFFF06292),
      primaryDarkColor: Color(0xFFC2185B),
    ),
    ThemeColors(
      name: 'ティール',
      primaryColor: Color(0xFF009688),
      primaryLightColor: Color(0xFF4DB6AC),
      primaryDarkColor: Color(0xFF00695C),
    ),
    ThemeColors(
      name: 'インディゴ',
      primaryColor: Color(0xFF3F51B5),
      primaryLightColor: Color(0xFF7986CB),
      primaryDarkColor: Color(0xFF303F9F),
    ),
  ];
}

// テーマサービスの状態
class ThemeState {
  final ThemeColors selectedColor;
  final bool isDarkMode;

  const ThemeState({
    required this.selectedColor,
    required this.isDarkMode,
  });

  ThemeState copyWith({
    ThemeColors? selectedColor,
    bool? isDarkMode,
  }) {
    return ThemeState(
      selectedColor: selectedColor ?? this.selectedColor,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

// テーマサービスのプロバイダー
final themeServiceProvider = StateNotifierProvider<ThemeService, ThemeState>((ref) {
  return ThemeService();
});

class ThemeService extends StateNotifier<ThemeState> {
  static const String _colorKey = 'selected_theme_color';
  static const String _darkModeKey = 'dark_mode_enabled';

  ThemeService() : super(
    ThemeState(
      selectedColor: PresetThemeColors.colors[0], // デフォルトはピンク
      isDarkMode: false,
    ),
  ) {
    _loadSettings();
  }

  // 設定を読み込み
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // テーマ色の読み込み
    final colorIndex = prefs.getInt(_colorKey) ?? 0;
    final selectedColor = PresetThemeColors.colors[colorIndex.clamp(0, PresetThemeColors.colors.length - 1)];
    
    // ダークモードの読み込み
    final isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    
    state = state.copyWith(
      selectedColor: selectedColor,
      isDarkMode: isDarkMode,
    );
  }

  // テーマ色を変更
  Future<void> setThemeColor(ThemeColors color) async {
    final prefs = await SharedPreferences.getInstance();
    final colorIndex = PresetThemeColors.colors.indexOf(color);
    
    if (colorIndex != -1) {
      await prefs.setInt(_colorKey, colorIndex);
      state = state.copyWith(selectedColor: color);
    }
  }

  // ダークモードを切り替え
  Future<void> toggleDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    final newDarkMode = !state.isDarkMode;
    
    await prefs.setBool(_darkModeKey, newDarkMode);
    state = state.copyWith(isDarkMode: newDarkMode);
  }

  // ダークモードを設定
  Future<void> setDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDarkMode);
    state = state.copyWith(isDarkMode: isDarkMode);
  }

  // 現在のテーマデータを取得
  ThemeData get currentTheme {
    return _buildTheme(state.selectedColor, state.isDarkMode);
  }

  // テーマデータを構築
  ThemeData _buildTheme(ThemeColors colors, bool isDarkMode) {
    final brightness = isDarkMode ? Brightness.dark : Brightness.light;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primaryColor,
        brightness: brightness,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : colors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF),
        selectedItemColor: colors.primaryColor,
        unselectedItemColor: isDarkMode ? Colors.grey : const Color(0xFF6C757D),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardTheme(
        color: isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFFFFFFF),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[50],
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : const Color(0xFF212529),
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : const Color(0xFF212529),
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : const Color(0xFF212529),
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : const Color(0xFF212529),
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDarkMode ? Colors.white : const Color(0xFF212529),
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDarkMode ? Colors.grey : const Color(0xFF6C757D),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.white : const Color(0xFF212529),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: isDarkMode ? Colors.white : const Color(0xFF212529),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: isDarkMode ? Colors.grey : const Color(0xFF6C757D),
        ),
      ),
    );
  }
}
