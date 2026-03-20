# 贡献指南

感谢你对 Komga Reader 项目的关注！本文档将指导你如何为项目做出贡献。

## 🚀 快速开始

### 1. Fork 项目

点击 GitHub 页面右上角的 "Fork" 按钮。

### 2. 克隆仓库

```bash
git clone https://github.com/YOUR_USERNAME/komga-reader.git
cd komga-reader
```

### 3. 安装依赖

```bash
flutter pub get
```

### 4. 创建分支

```bash
git checkout -b feature/your-feature-name
```

## 📝 提交规范

我们遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

| 类型 | 说明 |
|------|------|
| `feat` | 新功能 |
| `fix` | 修复 bug |
| `docs` | 文档更新 |
| `style` | 代码格式（不影响代码运行） |
| `refactor` | 重构（既不是新功能也不是 bug 修复） |
| `test` | 添加或修改测试 |
| `chore` | 构建过程或辅助工具变动 |

### 提交格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

### 示例

```
feat(reader): 实现单页阅读模式

- 添加单页模式切换按钮
- 实现页面滑动逻辑
- 添加页面指示器

Closes #123
```

## 🔄  Pull Request 流程

1. **确保代码通过 CI 检查**
   - `flutter analyze` 无错误
   - `flutter test` 全部通过
   - `dart format` 格式化正确

2. **更新文档**
   - 如有新功能，更新 README 或添加文档
   - 更新 DEV_PROGRESS.md

3. **提交 PR**
   - 标题遵循提交规范
   - 描述清楚变更内容和原因
   - 关联相关 Issue

4. **代码审查**
   - 等待维护者审查
   - 根据反馈修改代码

## 📁 目录结构

```
lib/
├── core/           # 核心工具类
├── data/           # 数据层
├── domain/         # 领域层
├── presentation/   # 表现层
└── features/       # 功能模块
```

## 🧪 测试

```bash
# 运行所有测试
flutter test

# 运行特定测试
flutter test test/specific_test.dart

# 生成测试覆盖率
flutter test --coverage
```

## 📱 运行应用

```bash
# Android
flutter run

# iOS
flutter run

# 指定设备
flutter run -d <device_id>
```

## 🎨 代码风格

- 使用 `dart format` 格式化代码
- 遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart)
- 使用 `const` 构造函数
- 避免 `print`，使用 `logger`

## 🐛 报告 Bug

1. 检查是否已有相同 Bug 报告
2. 使用 Bug 报告模板
3. 提供详细信息：
   - 复现步骤
   - 预期行为
   - 实际行为
   - 环境信息（设备、系统版本等）

## 💡 功能建议

1. 检查是否已有相同建议
2. 使用功能建议模板
3. 说明使用场景和期望

## 📄 License

MIT License - 详见 [LICENSE](LICENSE)

---

感谢你的贡献！🎉
