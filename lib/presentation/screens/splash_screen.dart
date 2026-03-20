/// Flutter 漫画阅读器 - 启动页
/// 
/// 这是应用启动时显示的第一个页面
/// 
/// 主要功能：
/// 1. 显示应用 Logo 和名称
/// 2. 进行应用初始化
/// 3. 根据初始化结果导航到相应页面
/// 
/// 生命周期：
/// initState() -> _initializeApp() -> 导航到其他页面

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_routes.dart';
import '../providers/theme_provider.dart';

/// 启动页组件
/// 
/// 使用 [ConsumerStatefulWidget] 因为需要：
/// 1. 访问 Riverpod Provider
/// 2. 有状态管理（初始化过程）
class SplashScreen extends ConsumerStatefulWidget {
  /// 构造函数，标记为 const 以提高性能
  const SplashScreen({super.key});

  /// 创建状态类
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

/// 启动页状态类
/// 
/// 管理启动页的状态和逻辑
class _SplashScreenState extends ConsumerState<SplashScreen> {
  /// 生命周期方法 - 组件创建后调用
  @override
  void initState() {
    super.initState();
    // 启动应用初始化
    _initializeApp();
  }
  
  /// 应用初始化方法
  /// 
  /// 执行流程：
  /// 1. 等待 1.5 秒（模拟初始化，实际项目中可能加载数据）
  /// 2. 检查是否有服务器配置
  /// 3. 根据检查结果导航到不同页面
  Future<void> _initializeApp() async {
    // 模拟初始化延迟
    // 实际项目中这里可能：
    // - 加载本地数据
    // - 检查用户登录状态
    // - 预加载资源等
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // 检查组件是否还在树中
    // 避免在组件销毁后执行导航
    if (!mounted) return;
    
    // 从 Provider 获取当前服务器 ID
    // currentServerIdProvider 管理当前选中的服务器
    final serverId = ref.read(currentServerIdProvider);
    
    // 再次检查组件状态
    if (!mounted) return;
    
    // 根据服务器 ID 决定导航目标
    if (serverId == null) {
      // 没有服务器配置，跳转到服务器配置页面
      // pushReplacementNamed 会替换当前页面，不能返回
      Navigator.of(context).pushReplacementNamed(AppRoutes.serverConfig);
    } else {
      // 有服务器配置，跳转到主页面
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  /// 构建 UI 方法
  /// 
  /// [context] BuildContext，提供主题等信息
  /// 
  /// 返回启动页的 UI 组件树
  @override
  Widget build(BuildContext context) {
    // 获取当前主题
    final theme = Theme.of(context);
    
    // Scaffold 提供 Material Design 的页面结构
    return Scaffold(
      // body 是页面的主体内容
      body: Center(
        // Center 将子组件居中显示
        child: Column(
          // 垂直排列子组件
          // mainAxisSize.min 表示列的高度刚好容纳所有子组件
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. App Logo
            Container(
              width: 120,
              height: 120,
              // BoxDecoration 定义容器的装饰
              decoration: BoxDecoration(
                // 使用主题色的容器色
                color: theme.colorScheme.primaryContainer,
                // 圆角
                borderRadius: BorderRadius.circular(30),
              ),
              // 图标
              child: Icon(
                Icons.auto_stories, // 书籍图标
                size: 64,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            
            // 间距
            const SizedBox(height: 32),
            
            // 2. App 名称
            Text(
              'Komga Reader',
              // 使用主题的标题样式
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold, // 加粗
                color: theme.colorScheme.primary, // 主色调
              ),
            ),
            
            // 间距
            const SizedBox(height: 8),
            
            // 3. 副标题
            Text(
              '轻量级漫画阅读器',
              // 使用主题的正文样式
              style: theme.textTheme.bodyLarge?.copyWith(
                // 降低透明度，使其不那么突出
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            
            // 间距
            const SizedBox(height: 48),
            
            // 4. 加载指示器
            const CircularProgressIndicator(),
            
            // 间距
            const SizedBox(height: 16),
            
            // 5. 加载文字
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
