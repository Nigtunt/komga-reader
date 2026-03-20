import 'dart:convert';
import 'dart:io';

/// String 扩展
extension StringExtension on String {
  /// 判断是否为空或空白
  bool get isNullOrEmpty => trim().isEmpty;
  
  /// 判断是否不为空或空白
  bool get isNotNullOrEmpty => trim().isNotEmpty;
  
  /// 判断是否为有效的 URL
  bool get isValidUrl {
    try {
      final uri = Uri.parse(this);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
  
  /// 移除 URL 末尾的斜杠
  String removeTrailingSlash() {
    return endsWith('/') ? substring(0, length - 1) : this;
  }
  
  /// 确保 URL 以 / 结尾
  String ensureTrailingSlash() {
    return endsWith('/') ? this : '$this/';
  }
}

/// DateTime 扩展
extension DateTimeExtension on DateTime {
  /// 格式化为相对时间字符串（如：刚刚、5 分钟前、1 小时前）
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
  String toDateString() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
  
  /// 格式化为时间字符串（HH:MM）
  String toTimeString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
  
  /// 格式化为日期时间字符串
  String toDateTimeString() {
    return '${toDateString()} ${toTimeString()}';
  }
}

/// List 扩展
extension ListExtension<T> on List<T> {
  /// 安全地获取元素，避免越界
  T? safeGet(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }
  
  /// 判断列表是否为空或 null
  bool get isNullOrEmpty => isEmpty;
  
  /// 判断列表是否不为空或 null
  bool get isNotNullOrEmpty => isNotEmpty;
}

/// int 扩展
extension IntExtension on int {
  /// 格式化为文件大小字符串
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
  String toPercentageString({int decimals = 0}) {
    return '${toStringAsFixed(decimals)}%';
  }
}

/// double 扩展
extension DoubleExtension on double {
  /// 格式化为百分比字符串
  String toPercentageString({int decimals = 0}) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }
}

/// Map 扩展
extension MapExtension<K, V> on Map<K, V> {
  /// 判断 Map 是否为空或 null
  bool get isNullOrEmpty => isEmpty;
  
  /// 判断 Map 是否不为空或 null
  bool get isNotNullOrEmpty => isNotEmpty;
}

/// bool 扩展
extension BoolExtension on bool {
  /// 如果是 true，执行回调
  T? ifTrue<T>(T Function() callback) {
    return this ? callback() : null;
  }
  
  /// 如果是 false，执行回调
  T? ifFalse<T>(T Function() callback) {
    return !this ? callback() : null;
  }
}
