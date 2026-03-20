/// Flutter 漫画阅读器 - 错误处理器
/// 
/// 这个文件提供统一的错误处理机制
/// 包括：
/// 1. 自定义异常类
/// 2. 错误捕获和转换
/// 3. 友好的错误消息显示
/// 
/// 使用场景：
/// - 网络请求错误处理
/// - 数据解析错误处理
/// - 本地存储错误处理

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../utils/logger.dart';

/// ==================== 异常类定义 ====================

/// 应用异常基类
/// 
/// 所有自定义异常都继承自这个类
/// 提供统一的错误信息格式
abstract class AppException implements Exception {
  /// 错误消息
  final String message;
  
  /// 原始错误对象
  final dynamic originalError;
  
  /// 错误堆栈跟踪
  final StackTrace? stackTrace;
  
  /// 构造函数
  AppException({
    required this.message,
    this.originalError,
    this.stackTrace,
  });
  
  /// 重写 toString 方法，方便日志输出
  @override
  String toString() => '$runtimeType: $message';
}

/// 网络异常
/// 
/// 用于处理网络请求相关的错误
/// 包括超时、连接失败、HTTP 错误等
class NetworkException extends AppException {
  /// HTTP 状态码（如果有）
  final int? statusCode;
  
  /// 构造函数
  NetworkException({
    required super.message,
    this.statusCode,
    super.originalError,
    super.stackTrace,
  });
  
  /// 从 Dio 错误创建网络异常
  /// 
  /// [error] Dio 抛出的异常
  /// 
  /// 根据错误类型返回相应的错误消息
  factory NetworkException.fromDioError(DioException error) {
    String message;
    
    // 根据错误类型返回不同的消息
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = '连接超时';
        break;
      case DioExceptionType.sendTimeout:
        message = '发送超时';
        break;
      case DioExceptionType.receiveTimeout:
        message = '接收超时';
        break;
      case DioExceptionType.connectionError:
        message = '网络连接失败';
        break;
      case DioExceptionType.cancel:
        message = '请求已取消';
        break;
      case DioExceptionType.badResponse:
        // 根据 HTTP 状态码返回消息
        message = _handleStatusCode(error.response?.statusCode);
        break;
      default:
        message = '网络请求失败';
    }
    
    return NetworkException(
      message: message,
      statusCode: error.response?.statusCode,
      originalError: error,
      stackTrace: error.stackTrace,
    );
  }
  
  /// 处理 HTTP 状态码
  /// 
  /// 将状态码转换为友好的错误消息
  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return '未授权，请重新登录';
      case 403:
        return '拒绝访问';
      case 404:
        return '资源不存在';
      case 500:
        return '服务器错误';
      case 502:
      case 503:
      case 504:
        return '服务器不可用';
      default:
        return '请求失败';
    }
  }
}

/// 认证异常
/// 
/// 用于处理用户认证相关的错误
class AuthException extends AppException {
  /// 构造函数
  AuthException({
    required super.message,
    super.originalError,
    super.stackTrace,
  });
  
  /// 创建未授权异常
  /// 
  /// 使用场景：用户未登录或登录已过期
  factory AuthException.unauthorized() {
    return AuthException(message: '未授权，请重新登录');
  }
  
  /// 创建凭证无效异常
  /// 
  /// 使用场景：用户名或密码错误
  factory AuthException.invalidCredentials() {
    return AuthException(message: '用户名或密码错误');
  }
}

/// 数据异常
/// 
/// 用于处理数据相关的错误
class DataException extends AppException {
  /// 构造函数
  DataException({
    required super.message,
    super.originalError,
    super.stackTrace,
  });
  
  /// 创建数据不存在异常
  /// 
  /// [resourceName] 资源名称
  factory DataException.notFound(String resourceName) {
    return DataException(message: '$resourceName 不存在');
  }
  
  /// 创建数据格式错误异常
  /// 
  /// [reason] 错误原因
  factory DataException.invalidFormat(String reason) {
    return DataException(message: '数据格式错误：$reason');
  }
}

/// 存储异常
/// 
/// 用于处理本地存储相关的错误
class StorageException extends AppException {
  /// 构造函数
  StorageException({
    required super.message,
    super.originalError,
    super.stackTrace,
  });
  
  /// 创建读取错误异常
  factory StorageException.readError() {
    return StorageException(message: '读取数据失败');
  }
  
  /// 创建写入错误异常
  factory StorageException.writeError() {
    return StorageException(message: '保存数据失败');
  }
}

/// ==================== 错误处理器 ====================

/// 全局错误处理器
/// 
/// 提供统一的错误捕获、转换和显示方法
/// 这是一个工具类，所有方法都是静态的
class ErrorHandler {
  /// 私有构造函数，防止实例化
  ErrorHandler._();
  
  /// 处理异步函数中的错误
  /// 
  /// [future] 要执行的异步函数
  /// [customMessage] 自定义错误消息
  /// [onError] 错误回调函数
  /// [defaultValue] 错误时返回的默认值
  /// 
  /// 使用场景：包装可能抛出异常的异步操作
  static Future<T> handleAsync<T>({
    required Future<T> Function() future,
    String? customMessage,
    Function(AppException)? onError,
    T? defaultValue,
  }) async {
    try {
      return await future();
    } catch (e, stackTrace) {
      // 将原始异常转换为 AppException
      final exception = _wrapException(e, stackTrace, customMessage);
      logger.e('Error: $exception', stackTrace: stackTrace);
      
      // 调用错误回调
      onError?.call(exception);
      
      // 如果提供了默认值，返回默认值
      if (defaultValue != null) {
        return defaultValue;
      }
      
      // 否则重新抛出异常
      rethrow;
    }
  }
  
  /// 处理同步函数中的错误
  /// 
  /// 参数和返回值与 handleAsync 类似，但用于同步函数
  static T handleSync<T>({
    required T Function() function,
    String? customMessage,
    Function(AppException)? onError,
    T? defaultValue,
  }) {
    try {
      return function();
    } catch (e, stackTrace) {
      final exception = _wrapException(e, stackTrace, customMessage);
      logger.e('Error: $exception', stackTrace: stackTrace);
      
      onError?.call(exception);
      
      if (defaultValue != null) {
        return defaultValue;
      }
      
      rethrow;
    }
  }
  
  /// 包装异常
  /// 
  /// 将各种类型的异常转换为 AppException
  /// 
  /// [e] 原始异常
  /// [stackTrace] 堆栈跟踪
  /// [customMessage] 自定义消息
  static AppException _wrapException(
    dynamic e,
    StackTrace stackTrace,
    String? customMessage,
  ) {
    // 如果已经是 AppException，直接返回
    if (e is AppException) {
      return e;
    }
    
    // 处理 Dio 异常
    if (e is DioException) {
      return NetworkException.fromDioError(e);
    }
    
    // 处理网络套接字异常
    if (e is SocketException) {
      return NetworkException(
        message: customMessage ?? '网络连接失败，请检查网络',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
    
    // 处理超时异常
    if (e is TimeoutException) {
      return NetworkException(
        message: customMessage ?? '请求超时',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
    
    // 其他异常
    return AppException(
      message: customMessage ?? '发生错误：$e',
      originalError: e,
      stackTrace: stackTrace,
    );
  }
  
  /// 显示错误 SnackBar
  /// 
  /// [context] BuildContext
  /// [exception] 要显示的异常
  /// 
  /// 使用场景：在 UI 上显示错误消息
  static void showSnackBar(BuildContext context, AppException exception) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(exception.message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: '知道了',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}

/// ==================== 异步扩展 ====================

/// 为 Future 添加错误处理扩展
extension AsyncErrorHandling<T> on Future<T> {
  /// 捕获错误并返回默认值
  /// 
  /// [defaultValue] 错误时返回的值
  /// 
  /// 使用场景：允许操作失败但不影响程序流程
  Future<T> onErrorReturn(T defaultValue) async {
    try {
      return await this;
    } catch (e) {
      return defaultValue;
    }
  }
  
  /// 捕获错误并执行回调
  /// 
  /// [callback] 错误回调函数，接收错误和堆栈
  /// 
  /// 使用场景：记录错误日志后继续处理
  Future<T> onErrorCatch(void Function(dynamic error, StackTrace stack) callback) async {
    try {
      return await this;
    } catch (e, stack) {
      callback(e, stack);
      rethrow;
    }
  }
}
