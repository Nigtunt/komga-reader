/// Flutter 漫画阅读器 - 日志工具
/// 
/// 这个文件提供统一的日志记录功能
/// 使用 logger 包来输出格式化的日志信息
/// 
/// 日志级别：
/// - verbose: 详细日志（最详细）
/// - debug: 调试日志
/// - info: 信息日志
/// - warning: 警告日志
/// - error: 错误日志
/// - fatal: 致命错误

import 'package:logger/logger.dart';

/// 全局 Logger 实例
/// 
/// 使用懒加载，第一次使用时才创建
/// 这样避免不必要的初始化开销
Logger? _logger;

/// 获取 Logger 实例的 getter
/// 
/// 如果 [_logger] 为空，则创建一个新的 Logger
/// 使用 [PrettyPrinter] 来格式化日志输出
/// 
/// 返回 [Logger] 实例
Logger get logger {
  // 如果 logger 还未初始化，则创建
  _logger ??= Logger(
    // 配置日志打印机
    printer: PrettyPrinter(
      // 显示调用方法的堆栈层数
      // 帮助定位日志来源
      methodCount: 2,
      
      // 错误日志显示的方法堆栈层数
      errorMethodCount: 8,
      
      // 每行的最大字符数
      lineLength: 120,
      
      // 启用彩色输出
      // 不同级别使用不同颜色，便于区分
      colors: true,
      
      // 打印 emoji 表情
      // 不同级别有不同 emoji，更直观
      printEmojis: true,
      
      // 打印时间戳
      printTime: true,
    ),
  );
  return _logger!;
}

/// Logger 服务类
/// 
/// 提供日志初始化和配置的方法
/// 这是一个工具类，所有方法都是静态的
class LoggerService {
  /// 私有构造函数，防止实例化
  LoggerService._();
  
  /// 初始化 Logger
  /// 
  /// 应该在应用启动时调用（main 函数中）
  /// 配置全局的 Logger 实例
  static void init() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      // 设置日志级别为 debug
      // 只会显示 debug 及以上级别的日志
      level: Level.debug,
    );
  }
  
  /// 设置 Logger 级别
  /// 
  /// [level] 日志级别
  /// 
  /// 使用场景：
  /// - 开发环境：Level.debug（显示所有日志）
  /// - 生产环境：Level.warning（只显示警告和错误）
  static void setLevel(Level level) {
    _logger = Logger(
      printer: _logger?.printer, // 保持原有的打印机配置
      level: level, // 更新日志级别
    );
  }
}
