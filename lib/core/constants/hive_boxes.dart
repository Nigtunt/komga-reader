/// Hive Box 名称常量
class HiveBoxes {
  HiveBoxes._();
  
  /// 服务器配置
  static const String serverConfig = 'server_config';
  
  /// 应用设置
  static const String settings = 'settings';
  
  /// 阅读进度
  static const String readingProgress = 'reading_progress';
  
  /// 收藏列表
  static const String favorites = 'favorites';
  
  /// 下载任务
  static const String downloadTasks = 'download_tasks';
  
  /// 阅读历史
  static const String history = 'history';
  
  /// 缓存的图书馆数据
  static const String libraries = 'libraries';
  
  /// 缓存的系列数据
  static const String series = 'series';
  
  /// 缓存的书籍数据
  static const String books = 'books';
}

/// API 相关常量
class ApiConstants {
  ApiConstants._();
  
  /// 默认超时时间（秒）
  static const int timeoutSeconds = 30;
  
  /// 图片连接超时（秒）
  static const int imageTimeoutSeconds = 60;
  
  /// API 版本
  static const String apiVersion = 'v1';
  
  /// 默认端口
  static const int defaultPort = 25600;
}

/// 首选项 Key
class PrefKeys {
  PrefKeys._();
  
  /// 当前服务器 ID
  static const String currentServerId = 'current_server_id';
  
  /// 主题模式
  static const String themeMode = 'theme_mode';
  
  /// 默认阅读模式
  static const String defaultReadingMode = 'default_reading_mode';
  
  /// 默认阅读方向
  static const String defaultReadingDirection = 'default_reading_direction';
  
  /// 是否保持屏幕常亮
  static const String keepScreenOn = 'keep_screen_on';
  
  /// 是否仅 WiFi 下载
  static const String downloadOnlyOnWifi = 'download_only_on_wifi';
  
  /// 最大并发下载数
  static const String maxConcurrentDownloads = 'max_concurrent_downloads';
  
  /// 网格大小
  static const String gridSize = 'grid_size';
  
  /// 语言
  static const String language = 'language';
}

/// 路由名称
class AppRoutes {
  AppRoutes._();
  
  static const String splash = '/';
  static const String login = '/login';
  static const String serverConfig = '/server-config';
  static const String home = '/home';
  static const String library = '/library';
  static const String series = '/series';
  static const String seriesDetail = '/series-detail';
  static const String bookDetail = '/book-detail';
  static const String reader = '/reader';
  static const String collections = '/collections';
  static const String readlists = '/readlists';
  static const String downloads = '/downloads';
  static const String settings = '/settings';
  static const String search = '/search';
}
