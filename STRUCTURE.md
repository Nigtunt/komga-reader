# 📁 Komga Reader 项目结构说明

> 本文档详细介绍项目的目录结构、文件组织和架构设计，帮助 Flutter 初学者快速理解项目。

**最后更新**: 2026-03-20  
**项目版本**: 1.0.0

---

## 📚 目录

1. [整体结构](#整体结构)
2. [核心文件说明](#核心文件说明)
3. [分层架构详解](#分层架构详解)
4. [文件命名规范](#文件命名规范)
5. [代码组织原则](#代码组织原则)
6. [新手必读](#新手必读)

---

## 🏗️ 整体结构

### 项目根目录

```
komga_reader/
├── 📁 .github/                    # GitHub 相关配置
│   ├── workflows/                 # GitHub Actions 工作流
│   └── CONTRIBUTING.md           # 贡献指南
│
├── 📁 .dart_tool/                # Dart 工具缓存（自动生成，不提交）
├── 📁 .git/                      # Git 版本控制（自动生成，不提交）
├── 📁 android/                   # Android 平台特定代码
├── 📁 ios/                       # iOS 平台特定代码
├── 📁 test/                      # 测试文件
├── 📁 assets/                    # 静态资源（图片、字体等）
│
├── 📄 main.dart                  # ⭐ 应用入口（从这里开始！）
├── 📄 app.dart                   # ⭐ 应用配置
├── 📄 pubspec.yaml               # ⭐ 项目依赖配置
├── 📄 analysis_options.yaml      # 代码规范配置
├── 📄 .gitignore                 # Git 忽略规则
├── 📄 README.md                  # 项目说明
├── 📄 GETTING_STARTED.md         # 快速开始指南
├── 📄 DESIGN.md                  # 详细设计文档
├── 📄 DEV_PROGRESS.md            # 开发进度
└── 📄 STRUCTURE.md               # 📖 你正在看的文档
```

### lib 目录（核心代码）

```
lib/
├── 📄 main.dart                  # 应用启动入口
├── 📄 app.dart                   # 应用主组件和路由配置
│
├── 📁 core/                      # 核心工具模块
│   ├── constants/               # 常量定义
│   │   ├── hive_boxes.dart     # Hive 数据库表名
│   │   ├── pref_keys.dart      # 设置项键名
│   │   ├── api_constants.dart  # API 相关常量
│   │   └── app_routes.dart     # 路由路径
│   │
│   ├── theme/                   # 主题配置
│   │   └── app_theme.dart      # 亮色/暗色主题
│   │
│   ├── utils/                   # 工具类
│   │   └── logger.dart         # 日志工具
│   │
│   ├── extensions/              # 扩展方法
│   │   └── common_extensions.dart  # 常用类型扩展
│   │
│   └── error/                   # 错误处理
│       └── error_handler.dart  # 异常定义和处理器
│
├── 📁 data/                      # 数据层
│   ├── models/                  # 数据模型（待添加）
│   ├── repositories/            # 数据仓库实现（待添加）
│   ├── datasources/             # 数据源
│   │   ├── remote/             # 远程数据源（网络 API）
│   │   └── local/              # 本地数据源（数据库）
│   └── services/                # 服务层
│       └── dio_client.dart     # 网络客户端
│
├── 📁 domain/                    # 领域层（业务逻辑）
│   ├── entities/                # 业务实体（待添加）
│   ├── repositories/            # 仓库接口（待添加）
│   └── usecases/                # 用例（待添加）
│
├── 📁 presentation/              # 表现层（UI）
│   ├── screens/                 # 页面
│   │   ├── splash_screen.dart  # 启动页
│   │   └── home_screen.dart    # 主页
│   │
│   ├── widgets/                 # 可复用组件
│   │   ├── common_widgets.dart # 通用组件
│   │   └── bottom_navigation.dart # 底部导航
│   │
│   └── providers/               # 状态管理
│       └── theme_provider.dart # 主题 Provider
│
└── 📁 features/                  # 功能模块
    └── auth/                     # 认证模块
        ├── models/              # 数据模型
        │   └── server_config.dart  # 服务器配置
        │
        ├── screens/             # 页面
        │   ├── server_config_screen.dart      # 配置页
        │   └── server_config_list_screen.dart # 列表页
        │
        └── providers/           # 状态管理
            └── server_config_provider.dart    # 配置管理
```

---

## 🎯 核心文件说明

### 1. main.dart - 应用入口

**重要程度**: ⭐⭐⭐⭐⭐  
**阅读顺序**: 第 1 个

```dart
// 这是应用启动时执行的第一个文件
// 类似于 Java 的 main 方法

void main() async {
  // 1. 初始化 Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. 初始化日志
  LoggerService.init();
  
  // 3. 初始化数据库
  await _initHive();
  
  // 4. 启动应用
  runApp(KomgaReaderApp());
}
```

**作用**:
- 应用启动
- 初始化各种服务
- 创建根组件

---

### 2. app.dart - 应用配置

**重要程度**: ⭐⭐⭐⭐⭐  
**阅读顺序**: 第 2 个

```dart
// 定义整个应用的外观和行为
class KomgaReaderApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Komga Reader',
      theme: AppTheme.lightTheme,    // 亮色主题
      darkTheme: AppTheme.darkTheme, // 暗色主题
      routes: {                       // 路由配置
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
```

**作用**:
- 配置 MaterialApp
- 设置主题
- 定义路由

---

### 3. pubspec.yaml - 依赖配置

**重要程度**: ⭐⭐⭐⭐  
**阅读顺序**: 第 3 个

```yaml
name: komga_reader           # 项目名称
description: 漫画阅读器        # 项目描述
version: 1.0.0+1             # 版本号

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0   # 状态管理
  dio: ^5.4.0                # 网络请求
  hive: ^2.2.3               # 本地存储
  # ... 其他依赖
```

**作用**:
- 定义项目信息
- 声明依赖包
- 配置资源文件

---

## 🏛️ 分层架构详解

### 为什么需要分层？

想象你在盖房子：
- **地基** = data 层（数据存储）
- **框架** = domain 层（业务逻辑）
- **装修** = presentation 层（UI 界面）

分层的好处：
1. **职责清晰** - 每层只做一件事
2. **易于维护** - 改 UI 不影响数据
3. **易于测试** - 可以单独测试每层
4. **易于替换** - 可以换数据库不改 UI

---

### 分层详解

#### Data 层（数据层）

**职责**: 管理数据的存储和获取

```
data/
├── services/dio_client.dart    # 网络请求
├── datasources/local/          # 本地数据库操作
└── repositories/               # 数据仓库（实现）
```

**示例**:
```dart
// 从网络获取漫画列表
final books = await komgaApi.getBooks(libraryId);

// 保存到本地数据库
await hiveBox.put('books', books);
```

---

#### Domain 层（领域层）

**职责**: 处理业务逻辑

```
domain/
├── entities/          # 业务实体
├── repositories/      # 仓库接口
└── usecases/          # 用例（具体业务）
```

**示例**:
```dart
// 业务逻辑：获取已读书籍
class GetReadBooksUseCase {
  Future<List<Book>> execute() async {
    final books = await repository.getAllBooks();
    return books.where((b) => b.isRead).toList();
  }
}
```

---

#### Presentation 层（表现层）

**职责**: 显示 UI 和响应用户操作

```
presentation/
├── screens/           # 完整页面
├── widgets/           # 可复用组件
└── providers/         # 状态管理
```

**示例**:
```dart
// 显示漫画列表
class BookListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookCard(book: books[index]);
      },
    );
  }
}
```

---

## 📝 文件命名规范

### 通用规则

1. **使用小写字母和下划线**
   - ✅ `server_config.dart`
   - ❌ `ServerConfig.dart`

2. **文件名反映内容**
   - ✅ `book_list_screen.dart`
   - ❌ `books.dart`

3. **类型后缀**
   - `*_screen.dart` - 页面
   - `*_widget.dart` - 组件
   - `*_provider.dart` - Provider
   - `*_model.dart` - 数据模型
   - `*_service.dart` - 服务
   - `*_repository.dart` - 仓库

---

### 类命名规则

1. **大驼峰命名**（PascalCase）
   - ✅ `ServerConfig`
   - ✅ `BookListScreen`

2. **组件类以 Widget 或 Screen 结尾**
   - ✅ `class BookCard extends StatelessWidget`
   - ✅ `class HomeScreen extends StatefulWidget`

---

## 🎨 代码组织原则

### 1. 单一职责原则

每个文件/类只做一件事：

```dart
// ✅ 好的设计
class ThemeProvider { }  // 只管理主题
class ServerProvider { } // 只管理服务器

// ❌ 不好的设计
class EverythingProvider { 
  // 既管理主题，又管理服务器，还管理...
}
```

---

### 2. 依赖倒置原则

高层模块不依赖低层模块：

```dart
// ✅ 好的设计
abstract class BookRepository {
  // 定义接口
  Future<List<Book>> getBooks();
}

class BookRepositoryImpl implements BookRepository {
  // 具体实现
}
```

---

### 3. 组件复用原则

提取可复用的组件：

```dart
// ✅ 提取通用组件
class AppButton extends StatelessWidget { }
class AppTextField extends StatelessWidget { }

// 在多个页面中使用
AppButton(text: '保存')
AppButton(text: '取消')
```

---

## 📖 新手必读

### 学习路径

#### 第 1 天：理解项目结构

1. 阅读 `main.dart` - 了解应用如何启动
2. 阅读 `app.dart` - 了解应用配置
3. 阅读 `pubspec.yaml` - 了解使用的库

#### 第 2 天：理解 Flutter 基础

1. **Widget 是什么？**
   - Widget = UI 组件
   - 一切皆 Widget（按钮、文本、布局等）

2. **两种 Widget**
   - `StatelessWidget` - 无状态（不变）
   - `StatefulWidget` - 有状态（可变）

3. **BuildContext**
   - Widget 的上下文
   - 用于访问主题、路由等

#### 第 3 天：理解状态管理

1. **为什么需要状态管理？**
   - 数据变化时，UI 自动更新
   - 避免手动刷新

2. **Riverpod 基础**
   ```dart
   // 定义 Provider
   final countProvider = StateProvider((ref) => 0);
   
   // 读取状态
   final count = ref.watch(countProvider);
   
   // 修改状态
   ref.read(countProvider.notifier).state++;
   ```

#### 第 4-7 天：实践

1. 尝试修改主题颜色
2. 添加一个新页面
3. 实现一个简单的功能

---

### 常见问题

#### Q1: 从哪里开始修改代码？

**A**: 从 `presentation/screens/` 开始
- 想改 UI？找对应的 screen 文件
- 想加页面？在 screens/ 创建新文件

#### Q2: 如何添加新页面？

**A**: 三步走
```dart
// 1. 创建页面文件
// lib/presentation/screens/my_screen.dart

// 2. 在 app.dart 添加路由
routes: {
  '/my-page': (context) => MyScreen(),
}

// 3. 导航到新页面
Navigator.pushNamed(context, '/my-page');
```

#### Q3: 如何调试代码？

**A**: 使用 logger
```dart
logger.d('调试信息');
logger.i('普通信息');
logger.w('警告');
logger.e('错误');
```

#### Q4: 代码太多看不懂怎么办？

**A**: 
1. 从简单的文件开始（如 constants/）
2. 多看注释
3. 运行应用，边看边试
4. 不要试图一次理解所有代码

---

### 关键概念解释

#### Widget（组件）

Flutter 中一切皆 Widget：
- 按钮是 Widget
- 文本是 Widget
- 布局是 Widget
- 甚至应用本身也是 Widget

```dart
// Widget 就像乐高积木
// 可以组合出各种界面
Column(           // 垂直布局
  children: [
    Text('标题'),  // 文本
    Button(),     // 按钮
    Image(),      // 图片
  ]
)
```

---

#### Provider（状态管理）

Provider 是管理数据的地方：

```dart
// 想象 Provider 是一个全局变量
// 但更安全、更强大

// 定义
final themeProvider = StateProvider((ref) => ThemeMode.light);

// 在 UI 中使用
final theme = ref.watch(themeProvider);

// 修改
ref.read(themeProvider.notifier).state = ThemeMode.dark;
```

---

#### Route（路由）

路由就是页面导航：

```dart
// 定义路由（在 app.dart）
routes: {
  '/home': (context) => HomeScreen(),
}

// 跳转到页面
Navigator.pushNamed(context, '/home');

// 跳转并传递参数
Navigator.pushNamed(context, '/detail', arguments: bookId);
```

---

## 🎯 总结

### 项目结构记忆口诀

```
main.dart 是入口，app.dart 配路由
core 放核心工具，data 管数据流
domain 装业务，presentation 显 UI
features 模块清，新手不用愁
```

### 下一步

1. ✅ 阅读本文，了解项目结构
2. 📖 阅读 `GETTING_STARTED.md`，学习如何运行
3. 🎨 阅读 `DESIGN.md`，了解详细设计
4. 💻 开始动手实践！

---

**祝你学习愉快！** 🚀

如有问题，请查看：
- Flutter 官方文档：https://flutter.dev/docs
- Riverpod 文档：https://riverpod.dev/
- 项目 Issues：https://github.com/Nigtunt/komga-reader/issues
