/// Flutter 漫画阅读器 - 常用扩展方法
/// 
/// 这个文件为 Dart 的基础类型添加扩展方法
/// 扩展方法可以让类型拥有新的功能，而无需修改原始类型
/// 
/// 包含的扩展：
/// - String: URL 处理、空值判断
/// - DateTime: 时间格式化
/// - List: 安全访问、空值判断
/// - int/double: 格式化为文件大小、百分比
/// - Map: 空值判断
/// - bool: 条件执行

import 'dart:convert';
import 'dart:io';

/// String 类型的扩展方法
extension StringExtension on String {
  /// 判断字符串是否为空或只包含空白字符
  /// 
  /// 使用场景：表单验证
  /// 
  /// 示例：
  /// ```dart
  /// "".isNullOrEmpty // true
  /// "   ".isNullOrEmpty // true
  /// "hello".isNullOrEmpty // false
  /// ```
  bool get isNullOrEmpty => trim().isEmpty;
  
  /// 判断字符串是否不为空且包含非空白字符
  /// 
  /// 是 [isNullOrEmpty] 的反义
  bool get isNotNullOrEmpty => trim().isNotEmpty;
  
  /// 判断字符串是否为有效的 URL
  /// 
  /// 检查标准：
  /// 1. 可以成功解析为 Uri 对象
  /// 2. 包含 scheme（http 或 https）
  /// 
  /// 使用场景：服务器地址验证
  bool get isValidUrl {
    try {
      final uri = Uri.parse(this);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      // 解析失败，不是有效 URL
      return false;
    }
  }
  
  /// 移除字符串末尾的斜杠（/）
  /// 
  /// 使用场景：URL 处理
  /// 
  /// 示例：
  /// ```dart
  /// "https://example.com/".removeTrailingSlash() // "https://example.com"
  /// "https://example.com".removeTrailingSlash() // "https://example.com"
  /// ```
  String removeTrailingSlash() {
    return endsWith('/') ? substring(0, length - 1) : this;
  }
  
  /// 确保字符串以斜杠（/）结尾
  /// 
  /// 如果已有斜杠则不变，否则添加
  /// 
  /// 示例：
  /// ```dart
  /// "https://example.com".ensureTrailingSlash() // "https://example.com/"
  /// "https://example.com/".ensureTrailingSlash() // "https://example.com/"
  /// ```
  String ensureTrailingSlash() {
    return endsWith('/') ? this : '$this/';
  }
}

/// DateTime 类型的扩展方法
extension DateTimeExtension on DateTime {
  /// 格式化为相对时间字符串
  /// 
  /// 根据当前时间计算相对时间差
  /// 
  /// 返回格式：
  /// - 刚刚（不到 1 分钟）
  /// - X 分钟前
  /// - X 小时前
  /// - X 天前
  /// - X 个月前
  /// - X 年前
  /// 
  /// 使用场景：阅读历史、更新时间显示
  String toRelativeTimeString() {
    final now = DateTime.now();
    final difference = now.difference(this);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}年前';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}个月前';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
  
  /// 格式化为日期字符串（YYYY-MM-DD）
  /// 
  /// 示例：2024-01-15
  /// 
  /// 使用场景：漫画发布日期、添加日期显示
  String toDateString() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
  
  /// 格式化为时间字符串（HH:MM）
  /// 
  /// 示例：14:30
  /// 
  /// 使用场景：最后阅读时间显示
  String toTimeString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
  
  /// 格式化为日期时间字符串
  /// 
  /// 示例：2024-01-15 14:30
  /// 
  /// 使用场景：完整的日期时间显示
  String toDateTimeString() {
    return '${toDateString()} ${toTimeString()}';
  }
}

/// List 类型的扩展方法
extension ListExtension<T> on List<T> {
  /// 安全地获取列表元素，避免越界异常
  /// 
  /// 如果索引超出范围，返回 null 而不是抛出异常
  /// 
  /// 使用场景：不确定列表长度时的元素访问
  /// 
  /// 示例：
  /// ```dart
  /// [1, 2, 3].safeGet(1) // 2
  /// [1, 2, 3].safeGet(10) // null
  /// ```
  T? safeGet(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }
  
  /// 判断列表是否为空或 null
  /// 
  /// 使用场景：检查数据是否已加载
  bool get isNullOrEmpty => isEmpty;
  
  /// 判断列表是否不为空或 null
  /// 
  /// 是 [isNullOrEmpty] 的反义
  bool get isNotNullOrEmpty => isNotEmpty;
}

/// int 类型的扩展方法
extension IntExtension on int {
  /// 将字节数格式化为人类可读的文件大小
  /// 
  /// 自动选择合适的单位（B, KB, MB, GB）
  /// 
  /// 示例：
  /// ```dart
  /// 1024.toFileSizeString() // "1.0 KB"
  /// 1536000.toFileSizeString() // "1.5 MB"
  /// ```
  /// 
  /// 使用场景：显示下载文件大小、缓存大小
  String toFileSizeString() {
    if (this < 1024) {
      return '$this B';
    } else if (this < 1024 * 1024) {
      return '${(this / 1024).toStringAsFixed(1)} KB';
    } else if (this < 1024 * 1024 * 1024) {
      return '${(this / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(this / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }
  
  /// 格式化为百分比字符串
  /// 
  /// [decimals] 小数位数，默认为 0
  /// 
  /// 示例：
  /// ```dart
  /// 75.toPercentageString() // "75%"
  /// 75.toPercentageString(decimals: 1) // "75.0%"
  /// ```
  String toPercentageString({int decimals = 0}) {
    return toStringAsFixed(decimals).toPercentageString();
  }
}

/// double 类型的扩展方法
extension DoubleExtension on double {
  /// 将小数格式化为百分比字符串
  /// 
  /// 自动乘以 100 并添加 % 符号
  /// 
  /// [decimals] 小数位数，默认为 0
  /// 
  /// 示例：
  /// ```dart
  /// 0.75.toPercentageString() // "75%"
  /// 0.756.toPercentageString(decimals: 1) // "75.6%"
  /// ```
  /// 
  /// 使用场景：阅读进度显示
  String toPercentageString({int decimals = 0}) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }
}

/// Map 类型的扩展方法
extension MapExtension<K, V> on Map<K, V> {
  /// 判断 Map 是否为空
  /// 
  /// 使用场景：检查缓存数据是否存在
  bool get isNullOrEmpty => isEmpty;
  
  /// 判断 Map 是否不为空
  /// 
  /// 是 [isNullOrEmpty] 的反义
  bool get isNotNullOrEmpty => isNotEmpty;
}

/// bool 类型的扩展方法
extension BoolExtension on bool {
  /// 如果值为 true，执行回调函数
  /// 
  /// [callback] 要执行的函数
  /// 
  /// 返回回调的结果，如果为 false 则返回 null
  /// 
  /// 使用场景：条件执行
  /// 
  /// 示例：
  /// ```dart
  /// true.ifTrue(() => "执行了") // "执行了"
  /// false.ifTrue(() => "执行了") // null
  /// ```
  T? ifTrue<T>(T Function() callback) {
    return this ? callback() : null;
  }
  
  /// 如果值为 false，执行回调函数
  /// 
  /// 是 [ifTrue] 的反义
  T? ifFalse<T>(T Function() callback) {
    return !this ? callback() : null;
  }
}
