import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_routes.dart';
import '../../widgets/common_widgets.dart';
import '../providers/server_config_provider.dart';

/// 服务器配置列表页面
class ServerConfigListScreen extends ConsumerWidget {
  const ServerConfigListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serversAsync = ref.watch(serversProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('服务器配置'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.serverConfig);
            },
          ),
        ],
      ),
      body: serversAsync.when(
        data: (servers) {
          if (servers.isEmpty) {
            return EmptyStateWidget(
              message: '暂无服务器配置',
              subMessage: '点击下方按钮添加 Komga 服务器',
              icon: Icons.cloud_off,
              action: PrimaryButton(
                text: '添加服务器',
                icon: Icons.add,
                fullWidth: true,
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.serverConfig);
                },
              ),
            );
          }
          
          return ListView.builder(
            itemCount: servers.length,
            itemBuilder: (context, index) {
              final server = servers[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.cloud,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(server.name),
                  subtitle: Text(server.baseUrl),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (server.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '默认',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // TODO: 编辑服务器
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // 选择此服务器
                    ref.read(currentServerIdProvider.notifier).setServerId(server.id);
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorWidgetBuilder(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(serversProvider);
          },
        ),
      ),
    );
  }
}
