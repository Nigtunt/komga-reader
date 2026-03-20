# 🚀 GitHub Actions 构建测试指南

**目标**: 测试 GitHub Actions 自动构建流程  
**预计时间**: 10-15 分钟

---

## 📋 步骤 1：上传 CI 工作流文件

### 方法 A：通过 GitHub Web 界面（最简单）

#### 1. 访问仓库
打开：https://github.com/Nigtunt/komga-reader

#### 2. 创建 workflow 文件

1. 点击 **Add file** 按钮
2. 选择 **Create new file**
3. 在文件名输入框输入：`.github/workflows/ci.yml`
   - 注意：`.github` 是文件夹，`workflows` 是子文件夹，`ci.yml` 是文件名

#### 3. 复制以下内容

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

#### 4. 提交文件

- 滚动到页面底部
- 在 "Commit new file" 输入框填写：`feat: 添加 CI 工作流`
- 点击 **Commit new file** 按钮

---

## 📋 步骤 2：验证 Actions 已启用

### 1. 访问 Actions 标签
点击仓库顶部的 **Actions** 标签

### 2. 检查是否看到工作流
应该能看到 "Flutter CI" 工作流

如果看不到，说明：
- Actions 可能被禁用
- 访问 `Settings` → `Actions` → `General` → 启用 Actions

---

## 📋 步骤 3：触发构建测试

### 方法 A：推送一次代码更改（推荐）

```bash
cd /home/admin/openclaw/workspace/komga_reader

# 创建一个小改动（比如更新 README）
echo "" >> README.md
echo "**构建测试**: $(date)" >> README.md

# 提交并推送
git add README.md
git commit -m "chore: 触发构建测试"
git push origin main
```

### 方法 B：手动触发工作流

1. 访问：https://github.com/Nigtunt/komga-reader/actions
2. 点击左侧的 **Flutter CI**
3. 点击右侧的 **Run workflow** 按钮
4. 选择分支：`main`
5. 点击 **Run workflow**

---

## 📋 步骤 4：查看构建状态

### 实时监控

1. 访问：https://github.com/Nigtunt/komga-reader/actions
2. 点击正在运行的构建（最顶部的那个）
3. 点击 `build` 任务
4. 展开各个步骤查看进度

### 构建步骤

你会看到以下步骤依次执行：

```
✅ Set up job
✅ Run actions/checkout@v3
✅ Run subosito/flutter-action@v2
🔄 Install dependencies          ← 当前步骤
⏳ Verify formatting
⏳ Analyze project source
⏳ Run tests
⏳ Build APK
⏳ Upload APK
✅ Complete job
```

### 预计时间
- 第一次构建：5-10 分钟（需要下载 Flutter SDK 和依赖）
- 后续构建：2-5 分钟（有缓存）

---

## 📋 步骤 5：查看构建结果

### 成功 ✅

如果所有步骤都是绿色 ✅：

1. **下载 APK**:
   - 滚动到页面底部
   - 找到 "Artifacts" 部分
   - 点击 `debug-apk` 下载
   - 解压后得到 `app-debug.apk`

2. **安装测试**:
   ```bash
   # 通过 ADB 安装到 Android 设备
   adb install app-debug.apk
   ```

### 失败 ❌

如果有步骤是红色 ❌：

1. **点击查看失败步骤**
2. **查看错误日志**
3. **常见错误**:
   - 代码格式化问题 → 运行 `dart format .`
   - 静态分析错误 → 修复警告
   - 测试失败 → 修复测试
   - 构建失败 → 检查依赖配置

---

## 🔍 故障排查

### Q1: Actions 标签不显示？

**A**: 启用 Actions
```
Settings → Actions → General → Allow all actions and reusable workflows
```

### Q2: 构建一直卡在 "Queued"？

**A**: GitHub Actions 队列拥堵，稍等几分钟即可

### Q3: 提示 "Resource not accessible by integration"？

**A**: 这是权限问题
```
Settings → Actions → General → Workflow permissions
→ 选择 "Read and write permissions"
```

### Q4: 构建失败怎么办？

**A**: 
1. 点击失败的步骤查看日志
2. 根据错误信息修复
3. 推送代码会自动重新触发构建

---

## 📊 构建产物

### Debug APK 位置

构建成功后，APK 文件在：
```
Artifacts → debug-apk → build/app/outputs/flutter-apk/app-debug.apk
```

### 下载方法

1. 访问构建页面
2. 滚动到底部
3. 点击 `debug-apk` 链接
4. 下载 ZIP 文件
5. 解压得到 APK

---

## 🎯 下一步：添加完整构建工作流

测试成功后，可以继续添加完整构建工作流：

### 创建 build.yml

1. 同样方法创建文件：`.github/workflows/build.yml`
2. 复制 `.github/workflows/build.yml` 的内容
3. 提交

这个工作流包含：
- Android Release 构建
- iOS 构建
- Web 构建
- 自动发布到 GitHub Releases

---

## 📝 快速命令参考

```bash
# 查看本地 Git 状态
cd /home/admin/openclaw/workspace/komga_reader
git status

# 推送代码触发构建
git push origin main

# 创建版本标签（触发 Release 构建）
git tag v1.0.0
git push origin v1.0.0

# 查看远程仓库
git remote -v
```

---

## 🔗 相关链接

- **仓库地址**: https://github.com/Nigtunt/komga-reader
- **Actions 页面**: https://github.com/Nigtunt/komga-reader/actions
- **CI 工作流**: https://github.com/Nigtunt/komga-reader/blob/main/.github/workflows/ci.yml
- **构建指南**: https://github.com/Nigtunt/komga-reader/blob/main/GITHUB_ACTIONS_GUIDE.md

---

## ✅ 检查清单

- [ ] 已创建 `.github/workflows/ci.yml`
- [ ] 已提交到 GitHub
- [ ] Actions 标签可见
- [ ] 构建已触发
- [ ] 构建成功完成
- [ ] APK 已下载
- [ ] （可选）APK 已安装测试

---

**准备就绪**！现在请按照步骤 1 上传 ci.yml 文件，然后我会帮你继续后续步骤。

有任何问题随时告诉我！🚀
