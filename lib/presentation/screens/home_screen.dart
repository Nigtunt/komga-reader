/// Flutter 漫画阅读器 - 主页面（带底部导航）
/// 
/// 这是应用的主要界面，包含：
/// 1. 底部导航栏（4 个 Tab）
/// 2. 首页 Tab（继续阅读、最近阅读）
/// 3. 图书馆 Tab（框架）
/// 4. 下载 Tab（框架）
/// 5. 设置 Tab（主题切换）
/// 
/// 使用 [ConsumerStatefulWidget] 管理当前选中的 Tab

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_routes.dart';
import '../widgets/bottom_navigation.dart';

/// 主页面组件
/// 
/// 这是应用的核心页面
/// 使用 IndexedStack 来保持每个 Tab 的状态
class HomeScreen extends ConsumerStatefulWidget {
  /// 构造函数
  const HomeScreen({super.key});

  /// 创建状态类
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

/// 主页面状态类
class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// 当前选中的 Tab 索引
  /// 
  /// 0 = 首页
  /// 1 = 浏览
  /// 2 = 下载
  /// 3 = 设置
  int _currentIndex = 0;
  
  /// Tab 页面列表
  /// 
  /// 使用懒加载，只创建一次
  final List<Widget> _screens = [
    const HomeTab(),      // 首页 Tab
    const LibraryTab(),   // 图书馆 Tab
    const DownloadsTab(), // 下载 Tab
    const SettingsTab(),  // 设置 Tab
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold 提供 Material Design 页面结构
    return Scaffold(
      // IndexedStack 保持所有子组件的状态
      // 切换 Tab 时不会重新加载
      body: IndexedStack(
        // 当前显示的子组件索引
        index: _currentIndex,
        // 所有子组件
        children: _screens,
      ),
      
      // 底部导航栏
      bottomNavigationBar: BottomNavigationWidget(
        // 当前选中的索引
        currentIndex: _currentIndex,
        // Tab 切换回调
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

/// ==================== 首页 Tab ====================

/// 首页 Tab
/// 
/// 显示：
/// 1. 继续阅读（On Deck）- 横向滚动列表
/// 2. 最近阅读 - 纵向列表
class HomeTab extends StatelessWidget {
  /// 构造函数
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold 提供 AppBar
    return Scaffold(
      // 顶部导航栏
      appBar: AppBar(
        title: const Text('首页'),
        // 右侧操作按钮
        actions: [
          // 搜索按钮
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // 导航到搜索页面
              Navigator.of(context).pushNamed(AppRoutes.search);
            },
          ),
        ],
      ),
      
      // CustomScrollView 支持滚动和 Sliver 组件
      body: CustomScrollView(
        slivers: [
          // 1. 继续阅读区域
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题和"查看全部"按钮
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '继续阅读',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('查看全部'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // 横向滚动列表
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      // 水平滚动
                      scrollDirection: Axis.horizontal,
                      itemCount: 5, // 示例数据，实际应从 API 获取
                      itemBuilder: (context, index) {
                        return _buildOnDeckCard(context, index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 2. 最近阅读区域
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '最近阅读',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  
                  // 最近阅读列表
                  ...List.generate(5, (index) => _buildRecentItem(context, index)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建"继续阅读"卡片
  /// 
  /// [context] BuildContext
  /// [index] 索引（用于示例数据）
  Widget _buildOnDeckCard(BuildContext context, int index) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 封面图占位
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.auto_stories,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // 标题
          Text(
            '漫画标题 $index',
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // 超出显示省略号
          ),
          
          // 进度条
          LinearProgressIndicator(
            value: 0.3 + (index * 0.1),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }
  
  /// 构建最近阅读列表项
  /// 
  /// [context] BuildContext
  /// [index] 索引
  Widget _buildRecentItem(BuildContext context, int index) {
    return ListTile(
      // 封面图
      leading: Container(
        width: 50,
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          Icons.auto_stories,
          size: 24,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      
      // 标题
      title: Text('漫画标题 $index'),
      
      // 副标题（话数和进度）
      subtitle: Text('第 ${index + 1} 话 • ${(0.3 + index * 0.1).toStringAsFixed(0)}%'),
      
      // 更多操作按钮
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {},
      ),
    );
  }
}

/// ==================== 图书馆 Tab ====================

/// 图书馆 Tab
/// 
/// 显示所有图书馆列表
/// 目前为框架，待后续实现
class LibraryTab extends StatelessWidget {
  /// 构造函数
  const LibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('图书馆'),
      ),
      body: const Center(
        child: Text('图书馆列表（开发中...）'),
      ),
    );
  }
}

/// ==================== 下载 Tab ====================

/// 下载 Tab
/// 
/// 显示下载管理界面
/// 目前为框架，待后续实现
class DownloadsTab extends StatelessWidget {
  /// 构造函数
  const DownloadsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('下载'),
      ),
      body: const Center(
        child: Text('下载管理（开发中...）'),
      ),
    );
  }
}

/// ==================== 设置 Tab ====================

/// 设置 Tab
/// 
/// 显示应用设置
/// 包含：
/// - 主题切换
/// - 服务器配置
/// - 关于信息
class SettingsTab extends ConsumerWidget {
  /// 构造函数
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      
      // 设置列表
      body: ListView(
        children: [
          // 1. 主题设置
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('主题'),
            subtitle: const Text('切换亮色/暗色模式'),
            trailing: Switch(
              // 当前是否为暗色模式
              value: Theme.of(context).brightness == Brightness.dark,
              // 切换主题
              onChanged: (value) {
                // 使用 Riverpod 切换主题
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
            ),
          ),
          const Divider(),
          
          // 2. 服务器配置
          ListTile(
            leading: const Icon(Icons.cloud_off),
            title: const Text('服务器配置'),
            subtitle: const Text('管理 Komga 服务器'),
            onTap: () {
              // 导航到服务器配置页面
              Navigator.of(context).pushNamed(AppRoutes.serverConfig);
            },
          ),
          const Divider(),
          
          // 3. 关于
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('关于'),
            subtitle: const Text('版本 1.0.0'),
            onTap: () {
              // 显示关于对话框
              showAboutDialog(
                context: context,
                applicationName: 'Komga Reader',
                applicationVersion: '1.0.0',
                applicationLegalese: 'MIT License',
              );
            },
          ),
        ],
      ),
    );
  }
}
