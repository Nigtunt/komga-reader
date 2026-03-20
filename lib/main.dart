/// Flutter 漫画阅读器 - 应用入口文件
/// 
/// 这是整个应用的启动点，负责：
/// 1. 初始化 Flutter 绑定
/// 2. 初始化日志系统
/// 3. 初始化本地数据库（Hive）
/// 4. 启动应用主组件
///
/// 执行流程：
/// main() -> WidgetsFlutterBinding.ensureInitialized()
///        -> LoggerService.init()
///        -> _initHive()
///        -> runApp(ProviderScope(child: KomgaReaderApp()))

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'core/constants/hive_boxes.dart';
import 'core/utils/logger.dart';

/// 应用主入口函数
/// 
/// [async] 因为需要等待 Hive 初始化完成
void main() async {
  // 确保 Flutter 的 Widgets 绑定已初始化
  // 这是在调用任何 Flutter API 之前必须做的
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化日志系统，用于开发调试
  LoggerService.init();
  logger.i('🚀 Komga Reader 应用启动...');
  
  // 初始化 Hive 本地数据库
  // Hive 是一个轻量级、快速的键值存储数据库
  await _initHive();
  
  // 启动应用
  // ProviderScope 是 Riverpod 状态管理的根组件
  // 它提供全局的状态管理能力
  runApp(
    const ProviderScope(
      child: KomgaReaderApp(),
    ),
  );
}

/// 初始化 Hive 本地数据库
/// 
/// Hive 用于存储：
/// - 服务器配置
/// - 应用设置
/// - 阅读进度
/// - 缓存数据等
///
/// 使用 [getApplicationDocumentsDirectory] 获取应用的文档目录
/// 这是存储持久化数据的安全位置
Future<void> _initHive() async {
  logger.d('📦 正在初始化 Hive 数据库...');
  
  // 初始化 Hive Flutter
  // 这会设置 Hive 使用 Flutter 的路径提供者
  await Hive.initFlutter();
  
  // 获取应用的文档目录
  // 这是 Flutter 应用存储持久化数据的标准位置
  final appDir = await getApplicationDocumentsDirectory();
  logger.d('📁 应用文档目录：${appDir.path}');
  
  // 打开基础的 Hive Box（类似于数据库表）
  // HiveBoxes.settings - 存储应用设置
  // HiveBoxes.serverConfig - 存储服务器配置
  // Box 是 Hive 的基本存储单元，用于存储键值对
  await Hive.openBox(HiveBoxes.settings);
  await Hive.openBox(HiveBoxes.serverConfig);
  
  logger.i('✅ Hive 数据库初始化成功');
}
