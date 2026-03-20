/// Flutter 漫画阅读器 - 应用配置组件
/// 
/// 这个文件定义了应用的主组件 [KomgaReaderApp]，负责：
/// 1. 配置 MaterialApp（Material Design 风格的应用）
/// 2. 设置主题（亮色/暗色模式）
/// 3. 配置路由（页面导航）
/// 4. 全局错误处理
///
/// 使用 Riverpod 的 [ConsumerWidget] 来响应主题变化

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'features/auth/screens/server_config_screen.dart';
import 'features/auth/screens/server_config_list_screen.dart';
import 'presentation/providers/theme_provider.dart';

/// Komga Reader 应用主组件
/// 
/// 这是一个 [ConsumerWidget]，可以访问 Riverpod 的状态管理
/// 主要用于监听主题模式的变化并实时更新 UI
///
/// [super.key] Flutter 2.0+ 的组件唯一标识符
class KomgaReaderApp extends ConsumerWidget {
  /// 构造函数，标记为 const 以提高性能
  const KomgaReaderApp({super.key});

  /// 构建应用 UI 的方法
  /// 
  /// [context] BuildContext，提供主题、路由等信息
  /// [ref] Riverpod 的引用，用于访问 Provider
  /// 
  /// 返回 [MaterialApp] 作为应用的根组件
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 从 Provider 获取当前的主题模式
    // themeModeProvider 管理亮色/暗色/系统跟随
    final themeMode = ref.watch(themeModeProvider);
    
    // MaterialApp 是 Material Design 风格应用的主组件
    // 它提供导航、主题、本地化等功能
    return MaterialApp(
      // 应用标题，显示在任务管理器中
      title: 'Komga Reader',
      
      // 是否在右上角显示调试横幅
      // 生产环境应设为 false
      debugShowCheckedModeBanner: false,
      
      // 亮色主题配置
      // 定义颜色、字体、组件样式等
      theme: AppTheme.lightTheme,
      
      // 暗色主题配置
      // 当用户切换到暗色模式时使用
      darkTheme: AppTheme.darkTheme,
      
      // 当前使用的主题模式
      // 可以是 light、dark 或 system
      themeMode: themeMode,
      
      // 路由配置表
      // 定义页面路径和对应的组件
      // 使用命名路由可以方便地在应用中导航
      initialRoute: AppRoutes.splash,
      routes: {
        // 启动页 - 应用启动时显示的第一个页面
        AppRoutes.splash: (context) => const SplashScreen(),
        
        // 主页面 - 包含底部导航栏的主要界面
        AppRoutes.home: (context) => const HomeScreen(),
        
        // 服务器配置页面 - 添加/编辑 Komga 服务器
        AppRoutes.serverConfig: (context) => const ServerConfigScreen(),
        
        // 服务器列表页面 - 显示所有已配置的服务器
        AppRoutes.serverConfigList: (context) => const ServerConfigListScreen(),
      },
      
      // 全局错误处理器
      // 当应用发生未捕获错误时显示友好的错误界面
      builder: (context, child) {
        // 重写 Flutter 的默认错误组件
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Material(
            // 使用错误主题色作为背景
            child: Container(
              color: Theme.of(context).colorScheme.error,
              child: Center(
                child: Column(
                  // 设置列为最小高度，避免占满整个屏幕
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 错误图标
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    
                    // 错误信息文本
                    Text(
                      '出错了 ${details.exception}',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        };
        
        // 返回原始的子组件（如果没有错误）
        return child!;
      },
    );
  }
}
