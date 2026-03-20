import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/hive_boxes.dart';
import '../models/server_config.dart';

/// 服务器配置列表 Provider
final serversProvider = FutureProvider<List<ServerConfig>>((ref) async {
  final box = Hive.box(HiveBoxes.serverConfig);
  final servers = <ServerConfig>[];
  
  for (final key in box.keys) {
    final map = box.get(key);
    if (map != null) {
      servers.add(ServerConfig.fromMap(map));
    }
  }
  
  // 按创建时间排序
  servers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  
  return servers;
});

/// 当前服务器 Provider
final currentServerProvider = FutureProvider<ServerConfig?>((ref) async {
  final box = Hive.box(HiveBoxes.settings);
  final currentServerId = box.get('current_server_id');
  
  if (currentServerId == null) {
    // 没有设置当前服务器，返回默认服务器
    final servers = await ref.watch(serversProvider.future);
    return servers.firstWhere((s) => s.isDefault, orElse: () => servers.firstOrNull);
  }
  
  return await ServerConfig.load(currentServerId);
});

/// 服务器配置 Provider（用于管理）
final serverConfigProvider = StateNotifierProvider<ServerConfigNotifier, AsyncValue<void>>((ref) {
  return ServerConfigNotifier(ref);
});

class ServerConfigNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  
  ServerConfigNotifier(this.ref) : super(const AsyncValue.data(null));
  
  /// 保存服务器配置
  Future<void> saveServer(ServerConfig config) async {
    state = const AsyncValue.loading();
    
    try {
      await config.save();
      ref.invalidate(serversProvider);
      ref.invalidate(currentServerProvider);
      
      // 如果是默认服务器，更新设置
      if (config.isDefault) {
        final box = Hive.box(HiveBoxes.settings);
        await box.put('current_server_id', config.id);
      }
      
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
  
  /// 删除服务器配置
  Future<void> deleteServer(String serverId) async {
    state = const AsyncValue.loading();
    
    try {
      final box = Hive.box(HiveBoxes.serverConfig);
      await box.delete(serverId);
      
      // 清除加密存储
      // TODO: 清理 flutter_secure_storage 中的数据
      
      ref.invalidate(serversProvider);
      ref.invalidate(currentServerProvider);
      
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
  
  /// 设置当前服务器
  Future<void> setCurrentServer(String serverId) async {
    try {
      final box = Hive.box(HiveBoxes.settings);
      await box.put('current_server_id', serverId);
      ref.invalidate(currentServerProvider);
    } catch (e) {
      rethrow;
    }
  }
}

/// 当前服务器 ID Provider（简化版）
final currentServerIdProvider = StateNotifierProvider<CurrentServerIdNotifier, String?>((ref) {
  return CurrentServerIdNotifier(ref);
});

class CurrentServerIdNotifier extends StateNotifier<String?> {
  final Ref ref;
  
  CurrentServerIdNotifier(this.ref) : super(null) {
    _loadCurrentServerId();
  }
  
  Future<void> _loadCurrentServerId() async {
    final box = Hive.box(HiveBoxes.settings);
    state = box.get('current_server_id');
  }
  
  Future<void> setServerId(String? serverId) async {
    final box = Hive.box(HiveBoxes.settings);
    await box.put('current_server_id', serverId);
    state = serverId;
    ref.invalidate(currentServerProvider);
  }
}
