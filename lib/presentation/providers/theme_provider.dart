import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/hive_boxes.dart';
import '../constants/pref_keys.dart';

/// 主题模式 Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }
  
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(PrefKeys.themeMode) ?? ThemeMode.system.index;
    state = ThemeMode.values[themeIndex];
  }
  
  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(PrefKeys.themeMode, mode.index);
    state = mode;
  }
  
  Future<void> toggleTheme() async {
    final nextMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setTheme(nextMode);
  }
}

/// 当前服务器 ID Provider
final currentServerIdProvider = StateNotifierProvider<CurrentServerIdNotifier, String?>((ref) {
  return CurrentServerIdNotifier();
});

class CurrentServerIdNotifier extends StateNotifier<String?> {
  CurrentServerIdNotifier() : super(null) {
    _loadServerId();
  }
  
  Future<void> _loadServerId() async {
    final box = Hive.box(HiveBoxes.settings);
    state = box.get(PrefKeys.currentServerId);
  }
  
  Future<void> setServerId(String? serverId) async {
    final box = Hive.box(HiveBoxes.settings);
    await box.put(PrefKeys.currentServerId, serverId);
    state = serverId;
  }
}

/// 网格大小 Provider（用于列表显示）
final gridSizeProvider = StateNotifierProvider<GridSizeNotifier, int>((ref) {
  return GridSizeNotifier();
});

class GridSizeNotifier extends StateNotifier<int> {
  GridSizeNotifier() : super(3) {
    _loadGridSize();
  }
  
  Future<void> _loadGridSize() async {
    final box = Hive.box(HiveBoxes.settings);
    state = box.get(PrefKeys.gridSize, defaultValue: 3);
  }
  
  Future<void> setGridSize(int size) async {
    final box = Hive.box(HiveBoxes.settings);
    await box.put(PrefKeys.gridSize, size);
    state = size;
  }
}
