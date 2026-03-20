import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/constants/hive_boxes.dart';

/// 认证类型
enum AuthType {
  basic,
  apiKey,
}

/// 服务器配置模型
class ServerConfig {
  final String id;
  final String name;
  final String baseUrl;
  final AuthType authType;
  final String? username;
  final String? password;  // 加密存储
  final String? apiKey;    // 加密存储
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  
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
  
  /// 转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'baseUrl': baseUrl,
      'authType': authType.index,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  /// 从 Map 创建
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
  
  /// 复制到新实例
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
  
  /// 保存到 Hive
  Future<void> save() async {
    final box = Hive.box(HiveBoxes.serverConfig);
    await box.put(id, toMap());
    
    // 敏感数据保存到加密存储
    final secureStorage = FlutterSecureStorage();
    if (password != null) {
      await secureStorage.write(key: 'password_$id', value: password);
    }
    if (apiKey != null) {
      await secureStorage.write(key: 'apikey_$id', value: apiKey);
    }
    if (username != null) {
      await secureStorage.write(key: 'username_$id', value: username);
    }
  }
  
  /// 从 Hive 加载
  static Future<ServerConfig?> load(String id) async {
    final box = Hive.box(HiveBoxes.serverConfig);
    final map = box.get(id);
    if (map == null) return null;
    
    final config = ServerConfig.fromMap(map);
    
    // 从加密存储加载敏感数据
    final secureStorage = FlutterSecureStorage();
    return config.copyWith(
      username: await secureStorage.read(key: 'username_$id'),
      password: await secureStorage.read(key: 'password_$id'),
      apiKey: await secureStorage.read(key: 'apikey_$id'),
    );
  }
  
  /// 获取完整的 API URL
  String get apiUrl {
    return baseUrl;
  }
  
  @override
  String toString() => 'ServerConfig(id: $id, name: $name, baseUrl: $baseUrl)';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerConfig && runtimeType == other.runtimeType && id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}
