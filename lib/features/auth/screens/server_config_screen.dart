import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../constants/app_routes.dart';
import '../../../widgets/common_widgets.dart';
import '../providers/server_config_provider.dart';
import '../models/server_config.dart';

/// 添加/编辑服务器页面
class ServerConfigScreen extends ConsumerStatefulWidget {
  final String? serverId;
  
  const ServerConfigScreen({
    super.key,
    this.serverId,
  });

  @override
  ConsumerState<ServerConfigScreen> createState() => _ServerConfigScreenState();
}

class _ServerConfigScreenState extends ConsumerState<ServerConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _urlController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _apiKeyController;
  
  AuthType _authType = AuthType.basic;
  bool _isDefault = false;
  bool _isLoading = false;
  bool _isEditing = false;
  
  @override
  void initState() {
    super.initState();
    _isEditing = widget.serverId != null;
    
    _nameController = TextEditingController();
    _urlController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _apiKeyController = TextEditingController();
    
    if (_isEditing) {
      _loadServerConfig();
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }
  
  Future<void> _loadServerConfig() async {
    // TODO: 加载现有配置
  }
  
  Future<void> _saveServer() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final config = ServerConfig(
        id: widget.serverId ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        baseUrl: _urlController.text.trim().removeTrailingSlash(),
        authType: _authType,
        username: _authType == AuthType.basic ? _usernameController.text.trim() : null,
        password: _authType == AuthType.basic ? _passwordController.text : null,
        apiKey: _authType == AuthType.apiKey ? _apiKeyController.text.trim() : null,
        isDefault: _isDefault,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await ref.read(serverConfigProvider.notifier).saveServer(config);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? '服务器已更新' : '服务器已添加'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('保存失败：$e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;
    
    // TODO: 测试连接
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('连接测试功能开发中...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑服务器' : '添加服务器'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _deleteServer(),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 服务器名称
            AppTextField(
              controller: _nameController,
              labelText: '服务器名称',
              hintText: '例如：我的漫画库',
              prefixIcon: Icons.cloud,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入服务器名称';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // 服务器地址
            AppTextField(
              controller: _urlController,
              labelText: '服务器地址',
              hintText: '例如：https://komga.example.com',
              prefixIcon: Icons.link,
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入服务器地址';
                }
                if (!value.isValidUrl) {
                  return '请输入有效的 URL（http://或 https://）';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // 认证方式
            Text(
              '认证方式',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<AuthType>(
              segments: const [
                ButtonSegment(
                  value: AuthType.basic,
                  label: Text('Basic Auth'),
                  icon: Icon(Icons.lock),
                ),
                ButtonSegment(
                  value: AuthType.apiKey,
                  label: Text('API Key'),
                  icon: Icon(Icons.vpn_key),
                ),
              ],
              selected: {_authType},
              onSelectionChanged: (Set<AuthType> selected) {
                setState(() => _authType = selected.first);
              },
            ),
            const SizedBox(height: 16),
            
            // Basic Auth 字段
            if (_authType == AuthType.basic) ...[
              AppTextField(
                controller: _usernameController,
                labelText: '用户名',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (_authType == AuthType.basic && (value == null || value.isEmpty)) {
                    return '请输入用户名';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordController,
                labelText: '密码',
                prefixIcon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (_authType == AuthType.basic && (value == null || value.isEmpty)) {
                    return '请输入密码';
                  }
                  return null;
                },
              ),
            ],
            
            // API Key 字段
            if (_authType == AuthType.apiKey) ...[
              AppTextField(
                controller: _apiKeyController,
                labelText: 'API Key',
                prefixIcon: Icons.vpn_key,
                obscureText: true,
                validator: (value) {
                  if (_authType == AuthType.apiKey && (value == null || value.isEmpty)) {
                    return '请输入 API Key';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 24),
            
            // 设为默认
            SwitchListTile(
              title: const Text('设为默认服务器'),
              subtitle: const Text('启动时自动连接此服务器'),
              value: _isDefault,
              onChanged: (value) {
                setState(() => _isDefault = value);
              },
            ),
            const SizedBox(height: 32),
            
            // 测试连接按钮
            SecondaryButton(
              text: '测试连接',
              icon: Icons.wifi,
              fullWidth: true,
              onPressed: _testConnection,
            ),
            const SizedBox(height: 16),
            
            // 保存按钮
            PrimaryButton(
              text: _isEditing ? '保存更改' : '添加服务器',
              icon: Icons.save,
              fullWidth: true,
              isLoading: _isLoading,
              onPressed: _saveServer,
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _deleteServer() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除服务器'),
        content: const Text('确定要删除此服务器配置吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    
    if (confirmed == true && mounted) {
      await ref.read(serverConfigProvider.notifier).deleteServer(widget.serverId!);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('服务器已删除')),
        );
      }
    }
  }
}
