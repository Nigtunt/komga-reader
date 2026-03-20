# 🚀 Android APK 构建指南

**工作流文件**: `.github/workflows/release.yaml`  
**更新时间**: 2026-03-20

---

## 📋 工作流说明

### 单一工作流，两种模式

| 触发条件 | 构建类型 | 产物 |
|----------|---------|------|
| 推送到 main/develop | Debug APK | Artifacts（保存 30 天） |
| 推送版本标签（v*） | Release APK | GitHub Release（永久） |

---

## ⚡ 快速开始

### 1. 测试构建（推送代码）

```bash
# 任何代码推送都会触发构建
git add .
git commit -m "feat: 测试构建"
git push
```

**结果**:
- ✅ 自动触发 Android 构建
- ✅ 生成 Debug APK
- ✅ 在 Actions → Artifacts 下载

---

### 2. 发布版本（创建标签）

```bash
# 1. 更新版本号（pubspec.yaml）
version: 1.0.0+1

# 2. 提交
git add pubspec.yaml
git commit -m "chore: 发布 v1.0.0"
git push

# 3. 创建并推送标签
git tag v1.0.0
git push origin v1.0.0
```

**结果**:
- ✅ 自动触发 Release 构建
- ✅ 生成 Release APK
- ✅ 创建 GitHub Release
- ✅ 在 Releases 页面下载

---

## 🔧 工作流详解

### 构建步骤

```yaml
1. ✅ 检出代码
2. ✅ 设置 Java 17（Android 构建必需）
3. ✅ 设置 Flutter 3.x
4. ✅ 获取依赖（flutter pub get）
5. 📝 代码分析（可选，失败不影响构建）
6. 📱 构建 APK
   - Debug: flutter build apk --debug
   - Release: flutter build apk --release
7. 📦 上传产物
8. 🎉 创建 GitHub Release（仅版本标签）
```

### 关键改进

相比之前的配置：

| 改进项 | 之前 | 现在 |
|--------|------|------|
| **工作流数量** | 2 个（易混淆） | 1 个（清晰） |
| **Java 环境** | ❌ 未配置 | ✅ Java 17 |
| **Action 版本** | v2/v3（旧） | v4（最新） |
| **代码分析** | 强制（可能失败） | 可选（不阻塞） |
| **产物保留** | 不明确 | 明确（30/90 天） |
| **Release 笔记** | ❌ 无 | ✅ 自动生成 |

---

## 📦 构建产物

### Debug APK（日常开发）

**位置**:
```
Actions → 对应构建运行 → Artifacts → debug-apk
```

**特点**:
- 📱 包含调试信息
- 🔍 可用于测试
- ⚠️ 体积较大
- 📅 保留 30 天

**下载安装**:
1. 访问 Actions 页面
2. 点击最近的构建
3. 滚动到底部找到 "Artifacts"
4. 点击 `debug-apk` 下载
5. 解压得到 `app-debug.apk`

---

### Release APK（正式发布）

**位置**:
```
Releases → 对应版本 → Assets → app-release.apk
```

**特点**:
- 🚀 优化后的性能
- 📦 体积更小
- 🔒 可签名（需配置）
- 📅 永久保留

**下载安装**:
1. 访问 Releases 页面
2. 选择对应版本
3. 点击 `app-release.apk` 下载

---

## 🏷️ 版本发布流程

### 完整步骤

```bash
# 1. 更新版本号
# 编辑 pubspec.yaml
version: 1.0.1+2  # 1.0.1 是版本号，2 是构建号

# 2. 提交更改
git add pubspec.yaml
git commit -m "chore: 发布版本 v1.0.1"
git push origin main

# 3. 创建标签
git tag v1.0.1
git push origin v1.0.1

# ✅ 构建自动开始！
```

### 版本命名规范

遵循 [Semantic Versioning](https://semver.org/):

```
v主版本。次版本。修订版

示例:
v1.0.0  # 第一个正式版本
v1.0.1  # 修复 bug
v1.1.0  # 新功能
v2.0.0  # 重大更新
```

---

## 🔐 Android 签名（可选）

### 为什么需要签名？

- 📱 Android 要求所有 APK 必须签名
- 🔒 Release APK 必须签名才能安装
- ✅ Debug APK 自动使用调试签名

### 配置签名

#### 1. 生成密钥库

```bash
keytool -genkey -v \
  -keystore upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

#### 2. 配置 GitHub Secrets

访问：`Settings` → `Secrets and variables` → `Actions`

添加以下 Secrets：

| Secret 名称 | 说明 | 示例 |
|------------|------|------|
| `ANDROID_KEYSTORE` | 密钥库 Base64 | `MII...` |
| `ANDROID_KEYSTORE_PASSWORD` | 密钥库密码 | `your_password` |
| `ANDROID_KEY_PASSWORD` | 密钥密码 | `your_key_password` |
| `ANDROID_KEY_ALIAS` | 密钥别名 | `upload` |

#### 3. 生成 Base64

```bash
# macOS
base64 upload-keystore.jks | pbcopy

# Linux/Windows
base64 upload-keystore.jks > keystore.txt
```

#### 4. 更新工作流（可选）

如果需要签名构建，告诉我，我会更新工作流配置。

---

## 🐛 故障排查

### Q1: 构建失败？

**查看日志**:
1. 访问 Actions 页面
2. 点击失败的构建
3. 展开各个步骤查看错误

**常见错误**:
- `No such file or directory` → 检查文件路径
- `Build failed` → 查看具体错误信息
- `Permission denied` → 检查文件权限

---

### Q2: 构建太慢？

**优化建议**:
- ✅ 使用缓存（已配置）
- ✅ 减少依赖数量
- ✅ 使用稳定的 Flutter 版本

---

### Q3: APK 无法安装？

**Debug APK**:
- ✅ 需要在开发者选项中开启 "USB 调试"
- ✅ 使用 ADB 安装：`adb install app-debug.apk`

**Release APK**:
- ⚠️ 需要签名才能安装
- 🔧 配置签名后重新构建

---

## 📊 构建时间

| 阶段 | 预计时间 |
|------|---------|
| 检出代码 | 10 秒 |
| 设置 Java | 30 秒 |
| 设置 Flutter | 1-2 分钟（有缓存） |
| 获取依赖 | 1-3 分钟 |
| 代码分析 | 1-2 分钟 |
| 构建 APK | 3-8 分钟 |
| **总计** | **8-15 分钟** |

---

## 🔗 相关链接

| 链接 | 说明 |
|------|------|
| **仓库** | https://github.com/Nigtunt/komga-reader |
| **Actions** | https://github.com/Nigtunt/komga-reader/actions |
| **Releases** | https://github.com/Nigtunt/komga-reader/releases |
| **工作流文件** | https://github.com/Nigtunt/komga-reader/blob/main/.github/workflows/release.yaml |

---

## ✅ 检查清单

构建测试：

- [ ] 推送代码到 main 分支
- [ ] 访问 Actions 页面
- [ ] 构建自动开始
- [ ] 等待构建完成（8-15 分钟）
- [ ] 下载 Debug APK
- [ ] 安装到设备测试

版本发布：

- [ ] 更新 pubspec.yaml 版本号
- [ ] 提交并推送
- [ ] 创建并推送版本标签
- [ ] 访问 Releases 页面
- [ ] 下载 Release APK
- [ ] 测试安装

---

**准备就绪**！现在可以推送代码测试构建了！🚀

有任何问题随时告诉我！
