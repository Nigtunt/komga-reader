/// Flutter 漫画阅读器 - 主题配置
/// 
/// 这个文件定义了应用的主题系统，包括：
/// 1. 亮色主题（Light Theme）
/// 2. 暗色主题（Dark Theme）
/// 
/// 使用 Material 3 设计规范
/// 主题配置包括颜色、字体、组件样式等

import 'package:flutter/material.dart';

/// 应用主题配置类
/// 
/// 提供静态方法访问亮色和暗色主题
/// 使用私有构造函数防止实例化
class AppTheme {
  /// 私有构造函数，防止创建实例
  AppTheme._();
  
  // ==================== 颜色定义 ====================
  // 使用紫色系作为主色调
  
  /// 主色调 - 紫色
  /// 用于主要按钮、强调元素等
  static const Color _primaryColor = Color(0xFF6750A4);
  
  /// 主色调上的文字颜色
  /// 通常为白色，确保对比度
  static const Color _onPrimaryColor = Color(0xFFFFFFFF);
  
  /// 主色调容器背景色
  /// 用于卡片、芯片等容器
  static const Color _primaryContainerColor = Color(0xFFEADDFF);
  
  /// 主色调容器上的文字颜色
  static const Color _onPrimaryContainerColor = Color(0xFF21005D);
  
  /// 次要色调
  /// 用于辅助元素
  static const Color _secondaryColor = Color(0xFF625B71);
  
  /// 第三色调
  /// 用于特殊强调
  static const Color _tertiaryColor = Color(0xFF7D5260);
  
  /// 背景颜色
  static const Color _backgroundColor = Color(0xFFFFFBFE);
  
  /// 表面颜色（卡片、对话框等）
  static const Color _surfaceColor = Color(0xFFF7F2FA);
  
  /// 表面上的文字颜色
  static const Color _onSurfaceColor = Color(0xFF1C1B1F);
  
  /// 成功状态颜色（绿色）
  static const Color _successColor = Color(0xFF4CAF50);
  
  /// 警告状态颜色（橙色）
  static const Color _warningColor = Color(0xFFFF9800);
  
  /// 错误状态颜色（红色）
  static const Color _errorColor = Color(0xFFB00020);
  
  /// 信息状态颜色（蓝色）
  static const Color _infoColor = Color(0xFF2196F3);
  
  // ==================== 亮色主题 ====================
  
  /// 亮色主题配置
  /// 
  /// 这是应用在白天的默认主题
  /// 使用浅色背景和深色文字
  static ThemeData lightTheme = ThemeData(
    /// 启用 Material 3 设计
    /// Material 3 是最新的 Material Design 规范
    useMaterial3: true,
    
    /// 设置主题为亮色模式
    brightness: Brightness.light,
    
    /// 颜色方案
    /// 定义所有组件使用的颜色
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
    
    /// 卡片主题
    /// 配置所有 Card 组件的默认样式
    cardTheme: CardTheme(
      elevation: 2, // 阴影高度
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // 圆角
      ),
      color: Colors.white, // 背景色
    ),
    
    /// AppBar 主题
    /// 配置顶部导航栏的样式
    appBarTheme: const AppBarTheme(
      elevation: 0, // 无阴影
      centerTitle: true, // 标题居中
      backgroundColor: _surfaceColor,
      foregroundColor: _onSurfaceColor,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _onSurfaceColor,
      ),
    ),
    
    /// 按钮主题
    /// 配置 ElevatedButton 的样式
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0, // 无阴影
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
    
    /// 输入框主题
    /// 配置 TextFormField 的样式
    inputDecorationTheme: InputDecorationTheme(
      filled: true, // 填充背景
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none, // 无边框
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
    
    /// 底部导航栏主题
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 8, // 阴影
      type: BottomNavigationBarType.fixed, // 固定模式
      selectedItemColor: _primaryColor, // 选中项颜色
      unselectedItemColor: Colors.grey, // 未选中项颜色
    ),
    
    /// 浮动按钮主题
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: _primaryColor,
      foregroundColor: _onPrimaryColor,
    ),
    
    /// 进度条主题
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: _primaryColor,
    ),
    
    /// 开关主题
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        // 根据选中状态返回不同颜色
        if (states.contains(WidgetState.selected)) {
          return _primaryColor;
        }
        return Colors.grey;
      }),
    ),
  );
  
  // ==================== 暗色主题 ====================
  
  /// 暗色主题配置
  /// 
  /// 这是应用在夜间或暗色模式下的主题
  /// 使用深色背景和浅色文字，减少眼睛疲劳
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    /// 暗色模式的颜色方案
    /// 调整颜色以适应深色背景
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
    
    /// 暗色模式卡片主题
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFF2D2D2D), // 深灰色背景
    ),
    
    /// 暗色模式 AppBar 主题
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
    
    /// 暗色模式按钮主题
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
    
    /// 暗色模式输入框主题
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
    
    /// 暗色模式底部导航栏主题
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _primaryContainerColor,
      unselectedItemColor: Colors.grey,
    ),
    
    /// 暗色模式浮动按钮主题
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: _primaryContainerColor,
      foregroundColor: _onPrimaryContainerColor,
    ),
    
    /// 暗色模式进度条主题
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: _primaryContainerColor,
    ),
    
    /// 暗色模式开关主题
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
