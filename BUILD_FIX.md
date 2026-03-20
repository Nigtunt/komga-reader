# 🔧 Android 构建错误修复说明

**修复时间**: 2026-03-20  
**问题**: Gradle 项目配置错误

---

## ❌ 原始错误

```
[!] Your app is using an unsupported Gradle project. 
To fix this problem, create a new project by running 
`flutter create -t app <app-directory>`
```

**原因**: 项目缺少完整的 Android Gradle 配置文件

---

## ✅ 已修复内容

### 1. 创建 Gradle 配置文件

#### `android/settings.gradle`
```gradle
pluginManagement {
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id "dev.flutter.flutter-gradle-plugin" version "1.0.0" apply false
    id "com.android.application" version "8.1.0" apply false
    id "org.jetbrains.kotlin.android" version "1.9.0" apply false
}
```

#### `android/build.gradle`
```gradle
buildscript {
    ext.kotlin_version = '1.9.0'
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}
```

#### `android/app/build.gradle`
```gradle
android {
    namespace "com.komga.komga_reader"
    compileSdkVersion 34
    ndkVersion flutter.ndkVersion
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
    
    defaultConfig {
        applicationId "com.komga.komga_reader"
        minSdkVersion 21
        targetSdkVersion 34
        multiDexEnabled true
    }
}
```

---

### 2. 创建 Android 配置文件

#### `android/local.properties`
```properties
sdk.dir=/usr/local/android-sdk
flutter.sdk=/usr/local/flutter
flutter.versionName=1.0.0
flutter.versionCode=1
```

#### `android/app/src/main/AndroidManifest.xml`
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="Komga Reader"
        android:icon="@mipmap/ic_launcher">
        <activity android:name=".MainActivity" ...>
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
```

#### `android/app/src/main/kotlin/com/komga/komga_reader/MainActivity.kt`
```kotlin
package com.komga.komga_reader

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}
```

---

### 3. 更新 GitHub Actions

#### 使用固定 Flutter 版本
```yaml
- name: 设置 Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.16.0'  # 使用稳定版本
    channel: 'stable'
    cache: true
```

#### 添加清理步骤
```yaml
- name: 清理构建
  run: flutter clean

- name: 重新获取依赖
  run: flutter pub get
```

#### 禁用图标优化（加速构建）
```yaml
- name: 构建 Debug APK
  run: flutter build apk --debug --no-tree-shake-icons
```

---

## 📊 技术栈版本

| 组件 | 版本 | 说明 |
|------|------|------|
| **Flutter** | 3.16.0 | 稳定版本 |
| **Dart** | 3.2.0 | 配套版本 |
| **Gradle** | 8.1.0 | Android 构建工具 |
| **Kotlin** | 1.9.0 | Android 开发语言 |
| **Java** | 17 | JDK 版本 |
| **Android SDK** | 34 | 编译 SDK 版本 |
| **minSdkVersion** | 21 | 最低支持 Android 5.0 |
| **targetSdkVersion** | 34 | 目标 Android 版本 |

---

## 🚀 现在可以测试了

### 推送代码触发构建

```bash
cd /home/admin/openclaw/workspace/komga_reader
git commit --allow-empty -m "chore: 测试构建"
git push
```

### 查看构建

1. 访问：https://github.com/Nigtunt/komga-reader/actions
2. 查看 "Android Release" 工作流
3. 等待构建完成（预计 10-15 分钟）
4. 下载 APK

---

## 🎯 关键改进

| 改进项 | 之前 | 现在 |
|--------|------|------|
| **Gradle 版本** | ❌ 未配置 | ✅ 8.1.0 |
| **Kotlin 版本** | ❌ 未配置 | ✅ 1.9.0 |
| **Flutter 版本** | 3.x（模糊） | 3.16.0（固定） |
| **配置文件** | ❌ 缺失 | ✅ 完整 |
| **清理步骤** | ❌ 无 | ✅ flutter clean |
| **构建优化** | ❌ 无 | ✅ --no-tree-shake-icons |

---

## 📝 文件清单

已创建/更新的文件：

```
android/
├── settings.gradle              ✅ 新建
├── build.gradle                 ✅ 新建
├── local.properties             ✅ 新建
└── app/
    ├── build.gradle             ✅ 新建
    └── src/main/
        ├── AndroidManifest.xml  ✅ 新建
        └── kotlin/.../
            └── MainActivity.kt  ✅ 新建

.github/workflows/
└── release.yaml                 ✅ 更新
```

---

## 🔍 故障排查

### 如果构建仍然失败

#### 1. 查看错误日志
```
Actions → 构建运行 → 查看失败步骤
```

#### 2. 常见问题

**Q: Gradle 版本不匹配？**
```
解决：确保使用 Gradle 8.1.0
```

**Q: Kotlin 版本错误？**
```
解决：使用 Kotlin 1.9.0
```

**Q: Flutter 版本问题？**
```
解决：使用 Flutter 3.16.0（稳定版）
```

**Q: SDK 版本太低？**
```
解决：compileSdkVersion 设置为 34
```

---

## ✅ 验证清单

- [x] Gradle 配置文件已创建
- [x] Kotlin 版本已配置
- [x] AndroidManifest.xml 已创建
- [x] MainActivity.kt 已创建
- [x] GitHub Actions 已更新
- [x] Flutter 版本固定为 3.16.0
- [x] 添加清理步骤
- [x] 禁用图标优化

---

## 📖 参考资源

- [Flutter Gradle 插件](https://docs.flutter.dev/deployment/android#gradle)
- [Android Gradle 配置](https://developer.android.com/build)
- [GitHub Actions Flutter](https://github.com/marketplace/actions/flutter-action)

---

**修复完成！** 现在推送代码测试构建吧！🚀
