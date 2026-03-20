import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_routes.dart';
import '../providers/theme_provider.dart';

/// 启动页
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    // 模拟初始化延迟
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (!mounted) return;
    
    // 检查是否有服务器配置
    final serverId = ref.read(currentServerIdProvider);
    
    if (!mounted) return;
    
    // 导航到相应页面
    if (serverId == null) {
      // 没有服务器配置，跳转到服务器配置页面
      Navigator.of(context).pushReplacementNamed(AppRoutes.serverConfig);
    } else {
      // 有服务器配置，跳转到首页
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.auto_stories,
                size: 64,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 32),
            
            // App 名称
            Text(
              'Komga Reader',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            
            // 副标题
            Text(
              '轻量级漫画阅读器',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 48),
            
            // 加载指示器
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            
            // 加载文本
            Text(
              '正在启动...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
