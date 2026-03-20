/// Hive Box 名称常量
/// 
/// Hive 使用 Box 来组织数据，类似于数据库中的"表"
/// 这个文件定义了所有 Box 的名称，方便统一管理和引用
///
/// 使用常量的好处：
/// 1. 避免拼写错误
/// 2. 集中管理，易于维护
/// 3. IDE 可以提供自动补全

/// 存储 Box 名称的常量类
/// 
/// 构造函数标记为私有（_），防止实例化
/// 所有成员都是 static，直接通过类名访问
class HiveBoxes {
  /// 私有构造函数，防止创建实例
  HiveBoxes._();
  
  /// 服务器配置 Box
  /// 
  /// 存储内容：
  /// - 服务器 ID
  /// - 服务器名称
  /// - 服务器地址
  /// - 认证信息（加密）
  /// - 创建/更新时间
  static const String serverConfig = 'server_config';
  
  /// 应用设置 Box
  /// 
  /// 存储内容：
  /// - 当前服务器 ID
  /// - 主题模式（亮色/暗色）
  /// - 默认阅读模式
  /// - 网格大小
  /// - 语言设置
  static const String settings = 'settings';
  
  /// 阅读进度 Box
  /// 
  /// 存储内容：
  /// - 书籍 ID
  /// - 当前页码
  /// - 阅读进度百分比
  /// - 最后阅读时间
  static const String readingProgress = 'reading_progress';
  
  /// 收藏列表 Box
  /// 
  /// 存储用户收藏的系列和书籍
  static const String favorites = 'favorites';
  
  /// 下载任务 Box
  /// 
  /// 存储内容：
  /// - 下载任务 ID
  /// - 书籍信息
  /// - 下载状态
  /// - 下载进度
  /// - 本地文件路径
  static const String downloadTasks = 'download_tasks';
  
  /// 阅读历史 Box
  /// 
  /// 记录用户的阅读历史记录
  static const String history = 'history';
  
  /// 图书馆缓存 Box
  /// 
  /// 缓存从服务器获取的图书馆数据
  /// 减少网络请求，提高加载速度
  static const String libraries = 'libraries';
  
  /// 系列数据缓存 Box
  /// 
  /// 缓存系列列表和详情数据
  static const String series = 'series';
  
  /// 书籍数据缓存 Box
  /// 
  /// 缓存书籍列表和详情数据
  static const String books = 'books';
}

/// API 相关常量
/// 
/// 定义与网络请求相关的常量值
class ApiConstants {
  /// 私有构造函数，防止实例化
  ApiConstants._();
  
  /// 默认超时时间（秒）
  /// 
  /// 用于普通网络请求
  /// 超过这个时间请求会被自动取消
  static const int timeoutSeconds = 30;
  
  /// 图片连接超时（秒）
  /// 
  /// 图片通常较大，所以设置更长的超时时间
  static const int imageTimeoutSeconds = 60;
  
  /// API 版本
  /// 
  /// 当前使用的 Komga API 版本
  /// 格式：v{版本号}
  static const String apiVersion = 'v1';
  
  /// 默认端口
  /// 
  /// Komga 服务器的默认端口号
  /// 如果用户没有指定端口，使用这个值
  static const int defaultPort = 25600;
}

/// 首选项 Key 常量
/// 
/// 用于 SharedPreferences 和 Hive 设置存储
/// 定义所有设置项的键名
class PrefKeys {
  /// 私有构造函数，防止实例化
  PrefKeys._();
  
  /// 当前服务器 ID
  /// 
  /// 存储当前选中的服务器配置 ID
  static const String currentServerId = 'current_server_id';
  
  /// 主题模式
  /// 
  /// 存储用户的主题偏好
  /// 值：0=system, 1=light, 2=dark
  static const String themeMode = 'theme_mode';
  
  /// 默认阅读模式
  /// 
  /// 存储用户偏好的阅读模式
  /// 值：single_page, double_page, continuous
  static const String defaultReadingMode = 'default_reading_mode';
  
  /// 默认阅读方向
  /// 
  /// 存储漫画的阅读方向
  /// 值：left_to_right, right_to_left, vertical
  static const String defaultReadingDirection = 'default_reading_direction';
  
  /// 是否保持屏幕常亮
  /// 
  /// 阅读时防止屏幕自动关闭
  /// 值：true/false
  static const String keepScreenOn = 'keep_screen_on';
  
  /// 是否仅 WiFi 下载
  /// 
  /// 只在 WiFi 环境下下载漫画
  /// 值：true/false
  static const String downloadOnlyOnWifi = 'download_only_on_wifi';
  
  /// 最大并发下载数
  /// 
  /// 同时进行的下载任务数量
  /// 值：整数（如 3）
  static const String maxConcurrentDownloads = 'max_concurrent_downloads';
  
  /// 网格大小
  /// 
  /// 列表视图每行显示的项数
  /// 值：整数（如 3）
  static const String gridSize = 'grid_size';
  
  /// 语言
  /// 
  /// 应用界面语言
  /// 值：zh_CN, en_US 等
  static const String language = 'language';
}

/// 路由名称常量
/// 
/// 定义所有页面的路由路径
/// 使用常量避免硬编码字符串
class AppRoutes {
  /// 私有构造函数，防止实例化
  AppRoutes._();
  
  /// 启动页
  /// 
  /// 应用启动时显示的第一个页面
  /// 用于初始化和加载数据
  static const String splash = '/';
  
  /// 登录页（预留）
  static const String login = '/login';
  
  /// 服务器配置页
  /// 
  /// 添加或编辑 Komga 服务器配置
  static const String serverConfig = '/server-config';
  
  /// 服务器列表页
  /// 
  /// 显示所有已配置的服务器
  static const String serverConfigList = '/server-config-list';
  
  /// 主页
  /// 
  /// 应用的主要界面，包含底部导航栏
  static const String home = '/home';
  
  /// 图书馆页
  static const String library = '/library';
  
  /// 系列页
  static const String series = '/series';
  
  /// 系列详情页
  static const String seriesDetail = '/series-detail';
  
  /// 书籍详情页
  static const String bookDetail = '/book-detail';
  
  /// 阅读器页
  /// 
  /// 漫画阅读界面
  static const String reader = '/reader';
  
  /// 合集页
  static const String collections = '/collections';
  
  /// 阅读列表页
  static const String readlists = '/readlists';
  
  /// 下载页
  static const String downloads = '/downloads';
  
  /// 设置页
  static const String settings = '/settings';
  
  /// 搜索页
  static const String search = '/search';
}
