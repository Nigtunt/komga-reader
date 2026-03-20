# 🤖 GitHub Actions 自动构建指南

## ⚠️ 重要提示

由于 GitHub 安全限制，`.github/workflows/` 目录的文件需要**手动上传**到 GitHub。

---

## 📋 方法 1：通过 GitHub Web 界面（推荐）

### 步骤 1：访问仓库
打开 https://github.com/Nigtunt/komga-reader

### 步骤 2：添加 CI 工作流
1. 点击 **Add file** → **Create new file**
2. 文件名输入：`.github/workflows/ci.yml`
3. 复制以下内容并粘贴：

```yaml
name: Flutter CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: 'stable'
          cache: true
      
      - name: 安装依赖
        run: flutter pub get
      
      - name: 检查代码格式化
        run: dart format --output=none --set-exit-if-changed .
      
      - name: 静态分析
        run: flutter analyze
      
      - name: 运行测试
        run: flutter test
      
      - name: 构建 Debug APK
        run: flutter build apk --debug
      
      - name: 上传 APK
        uses: actions/upload-artifact@v3
        with:
          name: debug-apk
          path: build/app/outputs/flutter-apk/app-debug.apk
```

4. 点击 **Commit new file**

### 步骤 3：添加完整构建工作流
1. 再次点击 **Add file** → **Create new file**
2. 文件名输入：`.github/workflows/build.yml`
3. 复制本地文件 `.github/workflows/build.yml` 的全部内容并粘贴
4. 点击 **Commit new file**

---

## 📋 方法 2：使用有权限的 Token

### 生成新的 Personal Access Token

1. 访问 https://github.com/settings/tokens
2. 点击 **Generate new token (classic)**
3. 勾选以下权限：
   - ✅ `repo` (Full control of private repositories)
   - ✅ `workflow` (Update GitHub Action workflows) ⭐ **必需**
4. 生成并复制 Token

### 更新远程仓库 URL

```bash
cd /home/admin/openclaw/workspace/komga_reader

# 使用 Token 更新远程 URL
git remote set-url origin https://<YOUR_TOKEN>@github.com/Nigtunt/komga-reader.git

# 推送 workflow 文件
git push
```

---

## ✅ 验证工作流

### 1. 检查 Actions 标签
访问：https://github.com/Nigtunt/komga-reader/actions

应该能看到工作流列表

### 2. 手动触发工作流
1. 进入 Actions 标签
2. 选择 "Flutter CI" 或 "Flutter Build"
3. 点击 **Run workflow**
4. 选择分支（main）
5. 点击 **Run workflow** 按钮

### 3. 查看构建结果
- 绿色 ✅ = 成功
- 红色 ❌ = 失败（点击查看详情）

---

## 🔧 配置 Secrets（用于 Release 构建）

### 访问路径
`Settings` → `Secrets and variables` → `Actions` → `New repository secret`

### Android 签名（可选）

| Secret 名称 | 说明 | 示例值 |
|------------|------|--------|
| `ANDROID_KEYSTORE` | 密钥库 Base64 编码 | `MII...（长字符串）` |
| `ANDROID_KEYSTORE_PASSWORD` | 密钥库密码 | `your_password` |
| `ANDROID_KEY_PASSWORD` | 密钥密码 | `your_key_password` |
| `ANDROID_KEY_ALIAS` | 密钥别名 | `upload` |

### 生成密钥库

```bash
# 1. 创建密钥库
keytool -genkey -v \
  -keystore upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload

# 2. 编码为 Base64
base64 upload-keystore.jks | pbcopy  # macOS
# 或
base64 upload-keystore.jks > keystore.txt  # 其他系统
```

将 Base64 字符串复制到 `ANDROID_KEYSTORE`

---

## 🏷️ 发布新版本

### 1. 更新版本号
编辑 `pubspec.yaml`：
```yaml
version: 1.0.1+2  # 1.0.1 是版本，2 是构建号
```

### 2. 提交更改
```bash
git add .
git commit -m "chore: 发布版本 v1.0.1"
git push
```

### 3. 创建并推送标签
```bash
git tag v1.0.1
git push origin v1.0.1
```

### 4. 自动构建
推送标签后，GitHub Actions 会自动：
- ✅ 运行所有测试
- ✅ 构建 Release APK
- ✅ 创建 GitHub Release
- ✅ 上传构建产物

---

## 📊 查看构建产物

### Debug APK
1. 访问 Actions
2. 选择对应的构建运行
3. 在页面底部找到 "Artifacts"
4. 下载 `debug-apk.zip`

### Release APK
1. 访问 Releases: https://github.com/Nigtunt/komga-reader/releases
2. 下载对应版本的 APK

---

## 🐛 常见问题

### Q: 看不到 Actions 标签？
**A**: 在仓库 Settings → Actions → General 中启用 Actions

### Q: 构建失败？
**A**: 
1. 点击失败的运行
2. 展开各个步骤查看错误
3. 根据错误信息修复

### Q: 如何取消构建？
**A**: 在 Actions 页面点击运行，然后点击 "Cancel workflow"

---

## 📖 相关文档

- [BUILD_SETUP.md](./.github/BUILD_SETUP.md) - 详细配置指南
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [flutter-action](https://github.com/subosito/flutter-action)

---

**最后更新**: 2026-03-20
