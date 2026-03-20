/// Flutter 漫画阅读器 - 主题 Provider
/// 
/// 这个文件提供应用的状态管理
/// 使用 Riverpod 管理：
/// 1. 主题模式（亮色/暗色）
/// 2. 当前服务器 ID
/// 3. 网格大小设置
/// 
/// Provider 是 Riverpod 的核心概念
/// 用于管理应用的状态（数据）

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/hive_boxes.dart';
import '../constants/pref_keys.dart';

/// ==================== 主题模式 Provider ====================

/// 主题模式 Provider
/// 
/// 管理应用的主题模式（亮色/暗色/系统跟随）
/// 
/// 类型说明：
/// - StateNotifierProvider: 可以修改状态的 Provider
/// - ThemeModeNotifier: 状态管理类
/// - ThemeMode: 状态类型（Flutter 内置枚举）
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// 主题模式状态管理类
/// 
/// 继承 StateNotifier<ThemeMode>
/// [state] 是当前状态，可以通过修改 state 来更新 UI
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  /// 构造函数
  /// 
  /// 初始状态为 ThemeMode.system（跟随系统）
  ThemeModeNotifier() : super(ThemeMode.system) {
    // 创建实例后立即加载保存的主题
    _loadTheme();
  }
  
  /// 加载保存的主题
  /// 
  /// 从 SharedPreferences 读取用户上次选择的主题
  /// 使用 async/await 处理异步操作
  Future<void> _loadTheme() async {
    // 获取 SharedPreferences 实例
    final prefs = await SharedPreferences.getInstance();
    
    // 读取保存的主题索引
    // getInt 返回 int?，所以使用 ?? 提供默认值
    final themeIndex = prefs.getInt(PrefKeys.themeMode) ?? ThemeMode.system.index;
    
    // 根据索引获取对应的 ThemeMode
    state = ThemeMode.values[themeIndex];
  }
  
  /// 设置主题
  /// 
  /// [mode] 要设置的主题模式
  /// 
  /// 保存主题到 SharedPreferences 并更新状态
  /// 状态更新后，所有监听这个 Provider 的 UI 都会自动重建
  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    
    // 保存主题索引（0=system, 1=light, 2=dark）
    await prefs.setInt(PrefKeys.themeMode, mode.index);
    
    // 更新状态
    // 这会触发 UI 重建
    state = mode;
  }
  
  /// 切换主题
  /// 
  /// 在亮色和暗色之间切换
  /// 使用场景：主题切换按钮
  Future<void> toggleTheme() async {
    // 三元运算符
    // 如果是亮色，切换到暗色；否则切换到亮色
    final nextMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setTheme(nextMode);
  }
}

/// ==================== 当前服务器 ID Provider ====================

/// 当前服务器 ID Provider
/// 
/// 管理当前选中的服务器配置 ID
/// 
/// 使用 StateNotifier 因为需要：
/// 1. 保存服务器 ID 到本地存储
/// 2. 在多个页面间共享服务器 ID
final currentServerIdProvider = StateNotifierProvider<CurrentServerIdNotifier, String?>((ref) {
  return CurrentServerIdNotifier();
});

/// 当前服务器 ID 状态管理类
class CurrentServerIdNotifier extends StateNotifier<String?> {
  /// 构造函数
  /// 
  /// 初始状态为 null（未选择服务器）
  CurrentServerIdNotifier() : super(null) {
    _loadServerId();
  }
  
  /// 加载保存的服务器 ID
  /// 
  /// 从 Hive 读取当前服务器 ID
  Future<void> _loadServerId() async {
    // 打开设置 Box
    final box = Hive.box(HiveBoxes.settings);
    
    // 读取服务器 ID
    // get 返回动态类型，可能是 String 或 null
    state = box.get(PrefKeys.currentServerId);
  }
  
  /// 设置服务器 ID
  /// 
  /// [serverId] 服务器配置 ID，null 表示未选择
  /// 
  /// 保存到 Hive 并更新状态
  Future<void> setServerId(String? serverId) async {
    final box = Hive.box(HiveBoxes.settings);
    
    // 保存到 Hive
    // put 方法会覆盖旧值
    await box.put(PrefKeys.currentServerId, serverId);
    
    // 更新状态
    state = serverId;
  }
}

/// ==================== 网格大小 Provider ====================

/// 网格大小 Provider
/// 
/// 管理列表视图的网格大小（每行显示几项）
/// 
/// 使用场景：
/// - 漫画列表显示
/// - 系列列表显示
/// 
/// 默认值：3（每行 3 个）
final gridSizeProvider = StateNotifierProvider<GridSizeNotifier, int>((ref) {
  return GridSizeNotifier();
});

/// 网格大小状态管理类
class GridSizeNotifier extends StateNotifier<int> {
  /// 构造函数
  /// 
  /// 初始状态为 3（每行 3 个）
  GridSizeNotifier() : super(3) {
    _loadGridSize();
  }
  
  /// 加载保存的网格大小
  /// 
  /// 从 Hive 读取用户设置的网格大小
  Future<void> _loadGridSize() async {
    final box = Hive.box(HiveBoxes.settings);
    
    // 读取网格大小
    // get 方法第二个参数是默认值
    state = box.get(PrefKeys.gridSize, defaultValue: 3);
  }
  
  /// 设置网格大小
  /// 
  /// [size] 每行显示的项数
  /// 
  /// 保存到 Hive 并更新状态
  Future<void> setGridSize(int size) async {
    final box = Hive.box(HiveBoxes.settings);
    
    // 保存到 Hive
    await box.put(PrefKeys.gridSize, size);
    
    // 更新状态
    state = size;
  }
}
