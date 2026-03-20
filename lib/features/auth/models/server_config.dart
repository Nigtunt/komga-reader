/// Flutter 漫画阅读器 - 服务器配置模型
/// 
/// 这个文件定义了 Komga 服务器的配置数据模型
/// 包含服务器的所有必要信息：
/// - 服务器基本信息（ID、名称、地址）
/// - 认证信息（Basic Auth 或 API Key）
/// - 配置信息（是否默认服务器）
/// - 时间戳（创建和更新时间）
/// 
/// 使用 Hive 进行本地存储
/// 敏感数据（密码、API Key）使用 flutter_secure_storage 加密存储

import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/constants/hive_boxes.dart';

/// ==================== 认证类型枚举 ====================

/// 认证方式
/// 
/// 支持两种认证方式：
/// 1. basic - HTTP Basic Authentication（用户名 + 密码）
/// 2. apiKey - API Key 认证（在请求头中传递）
enum AuthType {
  /// HTTP Basic 认证
  /// 使用用户名和密码进行认证
  basic,
  
  /// API Key 认证
  /// 使用 API Key 进行认证，更安全
  apiKey,
}

/// ==================== 服务器配置模型 ====================

/// 服务器配置数据模型
/// 
/// 用于存储 Komga 服务器的配置信息
/// 可以保存多个服务器配置，用户可切换
class ServerConfig {
  /// 服务器唯一标识符
  /// 
  /// 使用 UUID 生成，确保唯一性
  final String id;
  
  /// 服务器名称
  /// 
  /// 用户自定义的友好名称，如"我的漫画库"
  final String name;
  
  /// 服务器基础 URL
  /// 
  /// 例如：https://komga.example.com 或 http://192.168.1.100:25600
  final String baseUrl;
  
  /// 认证类型
  /// 
  /// 决定使用哪种认证方式
  final AuthType authType;
  
  /// 用户名（Basic Auth 时使用）
  /// 
  /// 仅当 authType 为 basic 时使用
  final String? username;
  
  /// 密码（Basic Auth 时使用）
  /// 
  /// 敏感数据，加密存储
  final String? password;
  
  /// API Key（API Key 认证时使用）
  /// 
  /// 敏感数据，加密存储
  final String? apiKey;
  
  /// 是否为默认服务器
  /// 
  /// 如果为 true，应用启动时自动连接此服务器
  final bool isDefault;
  
  /// 创建时间
  final DateTime createdAt;
  
  /// 最后更新时间
  final DateTime updatedAt;
  
  /// 构造函数
  /// 
  /// 所有字段都是必需的，除了认证相关字段
  ServerConfig({
    required this.id,
    required this.name,
    required this.baseUrl,
    required this.authType,
    this.username,
    this.password,
    this.apiKey,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// ==================== 序列化方法 ====================
  
  /// 转换为 Map
  /// 
  /// 用于存储到 Hive
  /// 注意：敏感数据（密码、API Key）不保存在 Map 中
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'baseUrl': baseUrl,
      'authType': authType.index,  // 枚举转为整数
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  /// 从 Map 创建实例
  /// 
  /// 用于从 Hive 读取数据
  /// 
  /// [map] Hive 中存储的 Map 数据
  factory ServerConfig.fromMap(Map<String, dynamic> map) {
    return ServerConfig(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      baseUrl: map['baseUrl'] ?? '',
      authType: AuthType.values[map['authType'] ?? 0],
      isDefault: map['isDefault'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
  
  /// ==================== 复制方法 ====================
  
  /// 复制到新实例
  /// 
  /// 用于修改部分字段后创建新对象
  /// 
  /// 示例:
  /// ```dart
  /// final updatedConfig = config.copyWith(
  ///   name: '新名称',
  ///   isDefault: true,
  /// );
  /// ```
  ServerConfig copyWith({
    String? id,
    String? name,
    String? baseUrl,
    AuthType? authType,
    String? username,
    String? password,
    String? apiKey,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServerConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      baseUrl: baseUrl ?? this.baseUrl,
      authType: authType ?? this.authType,
      username: username ?? this.username,
      password: password ?? this.password,
      apiKey: apiKey ?? this.apiKey,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  /// ==================== 存储方法 ====================
  
  /// 保存到 Hive
  /// 
  /// 分两步：
  /// 1. 将非敏感数据保存到 Hive
  /// 2. 将敏感数据（密码、API Key）保存到 FlutterSecureStorage
  Future<void> save() async {
    // 1. 打开 Hive Box
    final box = Hive.box(HiveBoxes.serverConfig);
    
    // 2. 保存非敏感数据
    await box.put(id, toMap());
    
    // 3. 保存敏感数据到加密存储
    final secureStorage = FlutterSecureStorage();
    
    // 保存密码（如果有）
    if (password != null) {
      await secureStorage.write(key: 'password_$id', value: password);
    }
    
    // 保存 API Key（如果有）
    if (apiKey != null) {
      await secureStorage.write(key: 'apikey_$id', value: apiKey);
    }
    
    // 保存用户名（如果有）
    if (username != null) {
      await secureStorage.write(key: 'username_$id', value: username);
    }
  }
  
  /// 从 Hive 加载
  /// 
  /// 分两步：
  /// 1. 从 Hive 读取非敏感数据
  /// 2. 从 FlutterSecureStorage 读取敏感数据
  /// 
  /// [id] 服务器 ID
  static Future<ServerConfig?> load(String id) async {
    // 1. 打开 Hive Box
    final box = Hive.box(HiveBoxes.serverConfig);
    
    // 2. 读取非敏感数据
    final map = box.get(id);
    if (map == null) return null;
    
    // 3. 创建配置对象
    final config = ServerConfig.fromMap(map);
    
    // 4. 从加密存储加载敏感数据
    final secureStorage = FlutterSecureStorage();
    
    return config.copyWith(
      username: await secureStorage.read(key: 'username_$id'),
      password: await secureStorage.read(key: 'password_$id'),
      apiKey: await secureStorage.read(key: 'apikey_$id'),
    );
  }
  
  /// ==================== 辅助方法 ====================
  
  /// 获取完整的 API URL
  /// 
  /// 用于构建 API 请求的基础 URL
  String get apiUrl {
    return baseUrl;
  }
  
  /// 重写 toString 方法
  /// 
  /// 用于日志输出和调试
  @override
  String toString() => 'ServerConfig(id: $id, name: $name, baseUrl: $baseUrl)';
  
  /// 重写相等性比较
  /// 
  /// 两个配置对象如果 ID 相同，则视为相等
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerConfig && runtimeType == other.runtimeType && id == other.id;
  
  /// 重写 hashCode
  /// 
  /// 配合 operator == 使用
  @override
  int get hashCode => id.hashCode;
}
