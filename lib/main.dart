import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'core/constants/hive_boxes.dart';
import 'core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化 Logger
  LoggerService.init();
  logger.i('🚀 Komga Reader starting...');
  
  // 初始化 Hive
  await _initHive();
  
  // 启动应用
  runApp(
    const ProviderScope(
      child: KomgaReaderApp(),
    ),
  );
}

Future<void> _initHive() async {
  logger.d('📦 Initializing Hive...');
  
  await Hive.initFlutter();
  
  // 获取应用文档目录
  final appDir = await getApplicationDocumentsDirectory();
  logger.d('📁 App directory: ${appDir.path}');
  
  // 打开基础 Box
  await Hive.openBox(HiveBoxes.settings);
  await Hive.openBox(HiveBoxes.serverConfig);
  
  logger.i('✅ Hive initialized successfully');
}
