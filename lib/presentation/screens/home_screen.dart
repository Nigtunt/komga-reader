import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_routes.dart';
import '../widgets/bottom_navigation.dart';

/// 主页面（带底部导航）
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeTab(),      // 首页
    const LibraryTab(),   // 浏览
    const DownloadsTab(), // 下载
    const SettingsTab(),  // 设置
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

/// 首页 Tab
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.search);
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 继续阅读 (On Deck)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return _buildOnDeckCard(context, index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 最近阅读
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
                  ...List.generate(5, (index) => _buildRecentItem(context, index)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOnDeckCard(BuildContext context, int index) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text(
            '漫画标题 $index',
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          LinearProgressIndicator(
            value: 0.3 + (index * 0.1),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecentItem(BuildContext context, int index) {
    return ListTile(
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
      title: Text('漫画标题 $index'),
      subtitle: Text('第 ${index + 1} 话 • ${(0.3 + index * 0.1).toStringAsFixed(0)}%'),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {},
      ),
    );
  }
}

/// 图书馆 Tab
class LibraryTab extends StatelessWidget {
  const LibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('图书馆'),
      ),
      body: const Center(
        child: Text('图书馆列表'),
      ),
    );
  }
}

/// 下载 Tab
class DownloadsTab extends StatelessWidget {
  const DownloadsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('下载'),
      ),
      body: const Center(
        child: Text('下载管理'),
      ),
    );
  }
}

/// 设置 Tab
class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('主题'),
            subtitle: const Text('切换亮色/暗色模式'),
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cloud_off),
            title: const Text('服务器配置'),
            subtitle: const Text('管理 Komga 服务器'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.serverConfig);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('关于'),
            subtitle: const Text('版本 1.0.0'),
            onTap: () {
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
