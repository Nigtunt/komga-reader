import 'package:flutter/material.dart';

/// 应用主题配置
class AppTheme {
  AppTheme._();
  
  // 主色调 - 紫色系
  static const Color _primaryColor = Color(0xFF6750A4);
  static const Color _onPrimaryColor = Color(0xFFFFFFFF);
  static const Color _primaryContainerColor = Color(0xFFEADDFF);
  static const Color _onPrimaryContainerColor = Color(0xFF21005D);
  
  // 次要色调
  static const Color _secondaryColor = Color(0xFF625B71);
  static const Color _tertiaryColor = Color(0xFF7D5260);
  
  // 背景色
  static const Color _backgroundColor = Color(0xFFFFFBFE);
  static const Color _surfaceColor = Color(0xFFF7F2FA);
  static const Color _onSurfaceColor = Color(0xFF1C1B1F);
  
  // 状态色
  static const Color _successColor = Color(0xFF4CAF50);
  static const Color _warningColor = Color(0xFFFF9800);
  static const Color _errorColor = Color(0xFFB00020);
  static const Color _infoColor = Color(0xFF2196F3);
  
  /// 亮色主题
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // 主色调
    colorScheme: const ColorScheme.light(
      primary: _primaryColor,
      onPrimary: _onPrimaryColor,
      primaryContainer: _primaryContainerColor,
      onPrimaryContainer: _onPrimaryContainerColor,
      secondary: _secondaryColor,
      onSecondary: Colors.white,
      tertiary: _tertiaryColor,
      onTertiary: Colors.white,
      surface: _surfaceColor,
      onSurface: _onSurfaceColor,
      error: _errorColor,
      onError: Colors.white,
    ),
    
    // 卡片主题
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
    ),
    
    // AppBar 主题
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: _surfaceColor,
      foregroundColor: _onSurfaceColor,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _onSurfaceColor,
      ),
    ),
    
    // 按钮主题
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // 输入框主题
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    
    // 底部导航栏主题
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _primaryColor,
      unselectedItemColor: Colors.grey,
    ),
    
    // 浮动按钮主题
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: _primaryColor,
      foregroundColor: _onPrimaryColor,
    ),
    
    // 进度条主题
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: _primaryColor,
    ),
    
    // 开关主题
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _primaryColor;
        }
        return Colors.grey;
      }),
    ),
  );
  
  /// 暗色主题
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // 主色调（暗色模式调整）
    colorScheme: const ColorScheme.dark(
      primary: _primaryContainerColor,
      onPrimary: _onPrimaryContainerColor,
      primaryContainer: _primaryColor,
      onPrimaryContainer: _onPrimaryColor,
      secondary: _secondaryColor,
      onSecondary: Colors.black,
      tertiary: _tertiaryColor,
      onTertiary: Colors.white,
      surface: Color(0xFF1C1B1F),
      onSurface: Color(0xFFE6E1E5),
      error: Color(0xFFCF6679),
      onError: Colors.black,
    ),
    
    // 卡片主题
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFF2D2D2D),
    ),
    
    // AppBar 主题
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF1C1B1F),
      foregroundColor: Color(0xFFE6E1E5),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE6E1E5),
      ),
    ),
    
    // 按钮主题
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // 输入框主题
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2D2D2D),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _primaryContainerColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCF6679)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    
    // 底部导航栏主题
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _primaryContainerColor,
      unselectedItemColor: Colors.grey,
    ),
    
    // 浮动按钮主题
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: _primaryContainerColor,
      foregroundColor: _onPrimaryContainerColor,
    ),
    
    // 进度条主题
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: _primaryContainerColor,
    ),
    
    // 开关主题
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _primaryContainerColor;
        }
        return Colors.grey;
      }),
    ),
  );
}
