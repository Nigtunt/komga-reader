# Flutter 自动构建配置指南

## 📋 概述

本项目配置了完整的 GitHub Actions 自动构建流程，包括：

1. ✅ **CI 检查** - 代码格式化、静态分析、测试
2. ✅ **Android 构建** - Debug 和 Release APK
3. ✅ **iOS 构建** - IPA 文件
4. ✅ **Web 构建** - Web 版本
5. ✅ **自动发布** - 创建 GitHub Release

---

## 🚀 触发条件

### CI 检查
- 推送到 `main` 或 `develop` 分支
- 创建 Pull Request

### Release 构建
- 推送版本标签（如 `v1.0.0`）

---

## ⚙️ 配置 Secrets

在 GitHub 仓库中配置以下 Secrets：

### 访问路径
`Settings` → `Secrets and variables` → `Actions` → `New repository secret`

### Android 签名配置（可选）

#### 1. ANDROID_KEYSTORE
Android 签名密钥库的 Base64 编码

**生成方法**：
```bash
# 创建密钥库
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# 编码为 Base64
cat upload-keystore.jks | base64 | pbcopy  # macOS
# 或
base64 upload-keystore.jks > keystore.txt  # 其他系统
```

将生成的 Base64 字符串复制到 `ANDROID_KEYSTORE`

#### 2. ANDROID_KEYSTORE_PASSWORD
密钥库密码

#### 3. ANDROID_KEY_PASSWORD
密钥密码

#### 4. ANDROID_KEY_ALIAS
密钥别名

### 配置 android/key.properties

在项目中创建 `android/key.properties`：

```properties
storePassword=${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
keyPassword=${{ secrets.ANDROID_KEY_PASSWORD }}
keyAlias=${{ secrets.ANDROID_KEY_ALIAS }}
storeFile=upload-keystore.jks
```

---

## 📦 构建产物

### CI 构建（每次推送）

| 产物 | 位置 | 说明 |
|------|------|------|
| Debug APK | Artifacts | 调试版本，可直接安装 |

### Release 构建（版本标签）

| 产物 | 位置 | 说明 |
|------|------|------|
| Release APK | GitHub Release | 签名后的发布版本 |
| iOS App | Artifacts | iOS 应用（需签名） |
| Web Build | GitHub Pages | Web 版本（可选） |

---

## 🏷️ 发布流程

### 1. 更新版本号

在 `pubspec.yaml` 中更新版本号：

```yaml
version: 1.0.1+2  # 1.0.1 是版本名，2 是构建号
```

### 2. 提交并推送

```bash
git add .
git commit -m "chore: 发布版本 v1.0.1"
git push
```

### 3. 创建并推送标签

```bash
# 创建标签
git tag v1.0.1

# 推送标签到 GitHub
git push origin v1.0.1
```

### 4. 自动构建和发布

推送标签后，GitHub Actions 会自动：

1. 运行所有 CI 检查
2. 构建 Android Release APK
3. 构建 iOS App
4. 创建 GitHub Release
5. 上传构建产物

---

## 📊 查看构建状态

### 构建历史
访问：`https://github.com/Nigtunt/komga-reader/actions`

### 构建产物
- 点击对应的工作流运行
- 在页面底部找到 "Artifacts"
- 下载需要的文件

### Release 页面
访问：`https://github.com/Nigtunt/komga-reader/releases`

---

## 🔧 自定义配置

### 修改 Flutter 版本

编辑 `.github/workflows/build.yml`：

```yaml
- uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.16.0'  # 指定具体版本
    channel: 'stable'
```

### 添加其他平台

#### Linux
```yaml
- name: 构建 Linux
  run: flutter build linux
```

#### macOS
```yaml
- name: 构建 macOS
  run: flutter build macos
```

#### Windows
```yaml
- name: 构建 Windows
  run: flutter build windows
```

### 配置自动部署

#### 部署到 Firebase App Distribution
```yaml
- name: 部署到 Firebase
  uses: wzieba/Firebase-Distribution-Github-Action@v1
  with:
    appId: ${{ secrets.FIREBASE_APP_ID }}
    serviceCredentialsFileContent: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}
    groups: testers
    file: build/app/outputs/flutter-apk/app-release.apk
```

#### 部署到 Google Play
```yaml
- name: 发布到 Google Play
  uses: r0adkll/upload-google-play@v1
  with:
    serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
    packageName: com.komga.reader
    releaseFiles: build/app/outputs/flutter-apk/app-release.apk
    track: internal
```

---

## 🐛 常见问题

### Q1: 构建失败怎么办？

**A**: 查看构建日志：
1. 访问 Actions 页面
2. 点击失败的运行
3. 展开各个步骤查看错误信息

### Q2: Android 签名失败？

**A**: 检查：
1. Secrets 是否正确配置
2. `android/key.properties` 是否存在
3. 密钥库文件是否正确解码

### Q3: iOS 构建需要开发者账号吗？

**A**: 是的，需要：
- Apple Developer 账号（$99/年）
- 配置证书和描述文件
- 或使用 `--no-codesign` 跳过签名（仅用于测试）

### Q4: 如何跳过某些步骤？

**A**: 使用条件判断：
```yaml
- name: 可选步骤
  if: false  # 永远不执行
  run: ...
```

---

## 📈 优化建议

### 1. 启用缓存
```yaml
- uses: subosito/flutter-action@v2
  with:
    cache: true
```

### 2. 并行构建
```yaml
strategy:
  matrix:
    os: [ubuntu-latest, macos-latest]
```

### 3. 只构建变更的内容
```yaml
paths:
  - 'lib/**'
  - 'pubspec.yaml'
```

---

## 🔗 相关资源

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Flutter 官方文档](https://flutter.dev/docs)
- [flutter-action](https://github.com/subosito/flutter-action)
- [Android 签名配置](https://developer.android.com/studio/publish/app-signing)

---

**最后更新**: 2026-03-20
