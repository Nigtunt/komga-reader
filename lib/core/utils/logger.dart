import 'package:logger/logger.dart';

/// Logger 实例
Logger? _logger;

/// 获取 Logger 实例
Logger get logger {
  _logger ??= Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );
  return _logger!;
}

/// Logger 服务
class LoggerService {
  LoggerService._();
  
  /// 初始化 Logger
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
      level: Level.debug,
    );
  }
  
  /// 设置 Logger 级别
  static void setLevel(Level level) {
    _logger = Logger(
      printer: _logger?.printer,
      level: level,
    );
  }
}
