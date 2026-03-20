/// 错误处理工具类
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../utils/logger.dart';

/// 应用异常基类
abstract class AppException implements Exception {
  final String message;
  final dynamic originalError;
  final StackTrace? stackTrace;
  
  AppException({
    required this.message,
    this.originalError,
    this.stackTrace,
  });
  
  @override
  String toString() => '$runtimeType: $message';
}

/// 网络异常
class NetworkException extends AppException {
  final int? statusCode;
  
  NetworkException({
    required super.message,
    this.statusCode,
    super.originalError,
    super.stackTrace,
  });
  
  factory NetworkException.fromDioError(DioException error) {
    String message;
    
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
class AuthException extends AppException {
  AuthException({
    required super.message,
    super.originalError,
    super.stackTrace,
  });
  
  factory AuthException.unauthorized() {
    return AuthException(message: '未授权，请重新登录');
  }
  
  factory AuthException.invalidCredentials() {
    return AuthException(message: '用户名或密码错误');
  }
}

/// 数据异常
class DataException extends AppException {
  DataException({
    required super.message,
    super.originalError,
    super.stackTrace,
  });
  
  factory DataException.notFound(String resourceName) {
    return DataException(message: '$resourceName 不存在');
  }
  
  factory DataException.invalidFormat(String reason) {
    return DataException(message: '数据格式错误：$reason');
  }
}

/// 存储异常
class StorageException extends AppException {
  StorageException({
    required super.message,
    super.originalError,
    super.stackTrace,
  });
  
  factory StorageException.readError() {
    return StorageException(message: '读取数据失败');
  }
  
  factory StorageException.writeError() {
    return StorageException(message: '保存数据失败');
  }
}

/// 全局错误处理器
class ErrorHandler {
  ErrorHandler._();
  
  /// 处理异步函数中的错误
  static Future<T> handleAsync<T>({
    required Future<T> Function() future,
    String? customMessage,
    Function(AppException)? onError,
    T? defaultValue,
  }) async {
    try {
      return await future();
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
  
  /// 处理同步函数中的错误
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
  static AppException _wrapException(
    dynamic e,
    StackTrace stackTrace,
    String? customMessage,
  ) {
    if (e is AppException) {
      return e;
    }
    
    if (e is DioException) {
      return NetworkException.fromDioError(e);
    }
    
    if (e is SocketException) {
      return NetworkException(
        message: customMessage ?? '网络连接失败，请检查网络',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
    
    if (e is TimeoutException) {
      return NetworkException(
        message: customMessage ?? '请求超时',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
    
    return AppException(
      message: customMessage ?? '发生错误：$e',
      originalError: e,
      stackTrace: stackTrace,
    );
  }
  
  /// 显示错误 SnackBar
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

/// 异步扩展 - 捕获错误
extension AsyncErrorHandling<T> on Future<T> {
  /// 捕获错误并返回默认值
  Future<T> onErrorReturn(T defaultValue) async {
    try {
      return await this;
    } catch (e) {
      return defaultValue;
    }
  }
  
  /// 捕获错误并执行回调
  Future<T> onErrorCatch(void Function(dynamic error, StackTrace stack) callback) async {
    try {
      return await this;
    } catch (e, stack) {
      callback(e, stack);
      rethrow;
    }
  }
}
