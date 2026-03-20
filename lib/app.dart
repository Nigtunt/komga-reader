import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'features/auth/screens/server_config_screen.dart';
import 'features/auth/screens/server_config_list_screen.dart';
import 'presentation/providers/theme_provider.dart';

class KomgaReaderApp extends ConsumerWidget {
  const KomgaReaderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp(
      title: 'Komga Reader',
      debugShowCheckedModeBanner: false,
      
      // 主题配置
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      
      // 路由配置
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.serverConfig: (context) => const ServerConfigScreen(),
        AppRoutes.serverConfigList: (context) => const ServerConfigListScreen(),
      },
      
      // 错误处理
      builder: (context, child) {
        return ErrorWidget.builder = (FlutterErrorDetails details) {
          return Material(
            child: Container(
              color: Theme.of(context).colorScheme.error,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
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
        return child!;
      },
    );
  }
}
