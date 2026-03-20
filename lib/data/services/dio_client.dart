import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants/hive_boxes.dart';
import '../../constants/api_constants.dart';
import '../../utils/logger.dart';

/// Dio 客户端 Provider（单例）
class DioClient {
  static Dio? _instance;
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  DioClient._();
  
  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }
  
  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: ApiConstants.timeoutSeconds),
        receiveTimeout: const Duration(seconds: ApiConstants.timeoutSeconds),
        sendTimeout: const Duration(seconds: ApiConstants.timeoutSeconds),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    // 添加日志拦截器
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      logPrint: (obj) => logger.d(obj),
    ));
    
    // 添加认证拦截器
    dio.interceptors.add(AuthInterceptor(_secureStorage));
    
    // 添加错误处理拦截器
    dio.interceptors.add(ErrorInterceptor());
    
    return dio;
  }
  
  /// 设置基础 URL
  static void setBaseUrl(String baseUrl) {
    _instance?.options.baseUrl = baseUrl;
  }
  
  /// 清除认证信息
  static Future<void> clearAuth() async {
    await _secureStorage.deleteAll();
  }
  
  /// 重置 Dio 实例（切换服务器时调用）
  static void reset() {
    _instance?.interceptors.clear();
    _instance = null;
  }
}

/// 认证拦截器
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  
  AuthInterceptor(this._secureStorage);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 跳过登录和登出请求
    if (options.path.contains('/api/v1/auth') || 
        options.path.contains('/api/logout')) {
      return handler.next(options);
    }
    
    try {
      // 尝试获取 API Key
      final apiKey = await _secureStorage.read(key: 'api_key');
      if (apiKey != null && apiKey.isNotEmpty) {
        options.headers['X-API-Key'] = apiKey;
        logger.d('🔑 Using API Key authentication');
      }
      
      // 尝试获取 Session Token
      final sessionToken = await _secureStorage.read(key: 'session_token');
      if (sessionToken != null && sessionToken.isNotEmpty) {
        options.headers['X-Auth-Token'] = sessionToken;
        logger.d('🔑 Using Session authentication');
      }
      
      // 尝试获取 Basic Auth
      final username = await _secureStorage.read(key: 'username');
      final password = await _secureStorage.read(key: 'password');
      if (username != null && password != null) {
        final credentials = base64Encode('$username:$password'.codeUnits);
        options.headers['Authorization'] = 'Basic $credentials';
        logger.d('🔑 Using Basic authentication');
      }
    } catch (e) {
      logger.e('❌ Failed to load auth credentials: $e');
    }
    
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 处理 401 未授权
    if (err.response?.statusCode == 401) {
      logger.w('⚠️ Authentication failed, clearing credentials...');
      await _secureStorage.deleteAll();
      // 可以触发登录事件
    }
    handler.next(err);
  }
}

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage;
    
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = '连接超时，请检查网络';
        break;
      case DioExceptionType.connectionError:
        errorMessage = '网络连接失败，请检查服务器地址';
        break;
      case DioExceptionType.cancel:
        errorMessage = '请求已取消';
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        errorMessage = _handleStatusCode(statusCode);
        break;
      default:
        errorMessage = '未知错误：${err.message}';
    }
    
    logger.e('❌ Dio Error: $errorMessage', error: err);
    
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        type: err.type,
        error: errorMessage,
        response: err.response,
      ),
    );
  }
  
  String _handleStatusCode(int? statusCode) {
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
        return '请求失败 (状态码：$statusCode)';
    }
  }
}

/// 自定义 Dio 异常
class DioExceptionWrapper implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;
  
  DioExceptionWrapper({
    required this.message,
    this.statusCode,
    this.originalError,
  });
  
  @override
  String toString() => 'DioExceptionWrapper: $message (status: $statusCode)';
}
