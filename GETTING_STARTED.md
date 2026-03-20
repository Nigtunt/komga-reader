# 🚀 快速开始指南

## 环境要求

- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android Studio / VS Code
- Android 设备 / iOS 模拟器

## 安装步骤

### 1. 获取依赖

```bash
cd komga_reader
flutter pub get
```

### 2. 运行应用

```bash
# Android
flutter run

# iOS
flutter run

# 指定设备
flutter run -d <device_id>
```

### 3. 代码生成（如需要）

```bash
# 运行 build_runner
flutter pub run build_runner build --delete-conflicting-outputs

# 监听模式
flutter pub run build_runner watch
```

## 项目结构说明

```
lib/
├── main.dart                          # 应用入口
├── app.dart                           # 应用配置和路由
│
├── core/                              # 核心模块
│   ├── constants/                     # 常量定义
│   │   ├── hive_boxes.dart           # Hive Box 名称
│   │   ├── pref_keys.dart            # 首选项 Key
│   │   ├── api_constants.dart        # API 常量
│   │   └── app_routes.dart           # 路由名称
│   ├── theme/                         # 主题配置
│   │   └── app_theme.dart            # 亮色/暗色主题
│   ├── utils/                         # 工具类
│   │   └── logger.dart               # 日志工具
│   ├── extensions/                    # 扩展方法
│   │   └── common_extensions.dart    # 常用扩展
│   └── error/                         # 错误处理
│       └── error_handler.dart        # 异常处理
│
├── data/                              # 数据层
│   └── services/                      # 服务
│       └── dio_client.dart           # Dio 客户端 + 拦截器
│
├── presentation/                      # 表现层
│   ├── screens/                       # 页面
│   │   ├── splash_screen.dart        # 启动页
│   │   └── home_screen.dart          # 主页面
│   ├── widgets/                       # 组件
│   │   ├── common_widgets.dart       # 通用组件
│   │   └── bottom_navigation.dart    # 底部导航
│   └── providers/                     # Riverpod
│       └── theme_provider.dart       # 主题 Provider
│
└── features/                          # 功能模块
    └── auth/                          # 认证模块
        ├── models/                    # 数据模型
        │   └── server_config.dart    # 服务器配置
        ├── screens/                   # 页面
        │   ├── server_config_screen.dart      # 服务器配置
        │   └── server_config_list_screen.dart # 服务器列表
        └── providers/                 # Provider
            └── server_config_provider.dart    # 配置管理
```

## 功能使用说明

### 添加服务器

1. 启动应用后，会自动跳转到服务器配置页面
2. 填写以下信息：
   - **服务器名称**: 自定义名称（如：我的漫画库）
   - **服务器地址**: Komga 服务器 URL（如：https://komga.example.com）
   - **认证方式**: 选择 Basic Auth 或 API Key
   - **认证信息**: 用户名/密码 或 API Key
3. 点击"测试连接"验证配置
4. 点击"添加服务器"保存

### 切换主题

1. 进入"设置"Tab
2. 切换"主题"开关
3. 应用会在亮色/暗色模式间切换

## 开发指南

### 添加新页面

1. 在 `presentation/screens/` 创建新页面
2. 在 `app.dart` 中添加路由
3. 在 `app_routes.dart` 中定义路由名称

### 添加新 Provider

1. 在 `presentation/providers/` 或对应 feature 的 `providers/` 目录创建
2. 使用 `@riverpod` 注解或继承 `StateNotifier`
3. 在页面中使用 `ref.watch()` 或 `ref.read()` 访问

### 添加新模型

1. 在对应 feature 的 `models/` 目录创建
2. 实现 `toMap()` 和 `fromMap()` 方法
3. 如需 Hive 存储，添加 `@HiveType` 注解

## 常见问题

### Q: 如何连接本地 Komga 服务器？

A: 使用以下格式：
- HTTP: `http://192.168.x.x:25600`
- HTTPS: `https://komga.local`

确保手机和服务器在同一网络。

### Q: 如何清除应用数据？

A: 
- Android: 设置 > 应用 > Komga Reader > 存储 > 清除数据
- iOS: 删除应用后重新安装

### Q: 代码生成失败怎么办？

A: 运行以下命令清理并重新生成：
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## 下一步开发计划

1. ✅ 项目基础框架（已完成）
2. 🔲 Komga API 认证
3. 🔲 图书馆数据加载
4. 🔲 系列/书籍浏览
5. 🔲 阅读器核心功能
6. 🔲 下载功能

## 参考资源

- [设计文档](DESIGN.md)
- [开发进度](DEV_PROGRESS.md)
- [Komga API 文档](https://komga.org/docs/openapi/komga-api/)
- [Flutter 文档](https://flutter.dev/docs)
- [Riverpod 文档](https://riverpod.dev/)

---

**最后更新**: 2026-03-20
