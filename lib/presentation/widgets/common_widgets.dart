/// Flutter 漫画阅读器 - 通用 UI 组件
/// 
/// 这个文件提供可复用的 UI 组件
/// 使用这些组件可以保持 UI 风格统一
/// 
/// 包含组件：
/// - ErrorWidgetBuilder: 错误显示
/// - LoadingWidget: 加载指示器
/// - EmptyStateWidget: 空状态
/// - PrimaryButton: 主按钮
/// - SecondaryButton: 次要按钮
/// - AppTextField: 文本输入框
/// - AppCard: 卡片组件

import 'package:flutter/material.dart';

/// ==================== 错误显示组件 ====================

/// 错误显示组件
/// 
/// 用于显示错误信息和重试按钮
/// 
/// 使用场景：
/// - 网络请求失败
/// - 数据加载错误
/// - 任何需要显示错误的地方
///
/// 示例:
/// ```dart
/// ErrorWidgetBuilder(
///   message: '加载失败',
///   onRetry: () => refresh(),
/// )
/// ```
class ErrorWidgetBuilder extends StatelessWidget {
  /// 错误消息
  final String? message;
  
  /// 重试按钮点击回调
  final VoidCallback? onRetry;
  
  /// 错误图标
  final IconData? icon;
  
  /// 操作按钮文字
  final String? actionText;
  
  /// 构造函数
  const ErrorWidgetBuilder({
    super.key,
    this.message,
    this.onRetry,
    this.icon,
    this.actionText,
  });
  
  @override
  Widget build(BuildContext context) {
    // 获取当前主题
    final theme = Theme.of(context);
    
    // 居中显示错误信息
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // 设置列为最小高度
          mainAxisSize: MainAxisSize.min,
          children: [
            // 错误图标
            Icon(
              icon ?? Icons.error_outline, // 默认使用错误图标
              size: 64,
              color: theme.colorScheme.error, // 使用主题错误色
            ),
            const SizedBox(height: 16),
            
            // 错误消息
            Text(
              message ?? '出错了，请稍后重试',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center, // 文字居中
            ),
            
            // 如果有重试回调，显示重试按钮
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh), // 刷新图标
                label: Text(actionText ?? '重试'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ==================== 加载组件 ====================

/// 加载指示器组件
/// 
/// 显示加载动画和可选的提示文字
/// 
/// 使用场景：
/// - 数据加载中
/// - 提交处理中
/// - 任何需要显示加载状态的地方
///
/// 示例:
/// ```dart
/// LoadingWidget(message: '加载中...')
/// ```
class LoadingWidget extends StatelessWidget {
  /// 加载提示文字
  final String? message;
  
  /// 加载动画大小
  final double? size;
  
  /// 构造函数
  const LoadingWidget({
    super.key,
    this.message,
    this.size,
  });
  
  @override
  Widget build(BuildContext context) {
    // 居中显示
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 圆形进度条
          SizedBox(
            width: size ?? 48, // 默认 48x48
            height: size ?? 48,
            child: const CircularProgressIndicator(),
          ),
          
          // 如果有提示文字，显示文字
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ==================== 空状态组件 ====================

/// 空状态组件
/// 
/// 显示空状态提示和操作按钮
/// 
/// 使用场景：
/// - 列表为空
/// - 没有数据
/// - 搜索结果为空
///
/// 示例:
/// ```dart
/// EmptyStateWidget(
///   message: '暂无数据',
///   icon: Icons.inbox_outlined,
///   action: PrimaryButton(text: '添加数据'),
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  /// 主要提示消息
  final String message;
  
  /// 次要提示消息
  final String? subMessage;
  
  /// 图标
  final IconData? icon;
  
  /// 操作按钮
  final Widget? action;
  
  /// 构造函数
  const EmptyStateWidget({
    super.key,
    required this.message,
    this.subMessage,
    this.icon,
    this.action,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // 居中显示
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 图标
            Icon(
              icon ?? Icons.inbox_outlined, // 默认使用收件箱图标
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            
            // 主要消息
            Text(
              message,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            
            // 次要消息（如果有）
            if (subMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                subMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            // 操作按钮（如果有）
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// ==================== 按钮组件 ====================

/// 主按钮（Primary Button）
/// 
/// 用于重要的操作，如提交、保存等
/// 
/// 特点：
/// - 使用主题主色调
/// - 视觉突出
///
/// 示例:
/// ```dart
/// PrimaryButton(
///   text: '保存',
///   onPressed: () => save(),
///   isLoading: isSaving,
/// )
/// ```
class PrimaryButton extends StatelessWidget {
  /// 按钮文字
  final String text;
  
  /// 点击回调
  final VoidCallback? onPressed;
  
  /// 是否显示加载状态
  final bool isLoading;
  
  /// 图标
  final IconData? icon;
  
  /// 是否占满全宽
  final bool fullWidth;
  
  /// 构造函数
  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
  });
  
  @override
  Widget build(BuildContext context) {
    // 设置按钮宽度
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      
      // ElevatedButton 是 Material Design 的凸起按钮
      child: ElevatedButton(
        // 如果正在加载，禁用按钮
        onPressed: isLoading ? null : onPressed,
        
        // 按钮内容
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                // 如果有图标，设置最小宽度；否则最大宽度
                mainAxisSize: icon != null ? MainAxisSize.min : MainAxisSize.max,
                mainAxisAlignment:
                    icon != null ? MainAxisAlignment.center : null,
                children: [
                  // 图标（如果有）
                  if (icon != null) ...[
                    Icon(icon),
                    const SizedBox(width: 8),
                  ],
                  // 文字
                  Text(text),
                ],
              ),
      ),
    );
  }
}

/// 次要按钮（Secondary Button）
/// 
/// 用于次要操作，如取消、返回等
/// 
/// 特点：
/// - 使用描边样式
/// - 视觉不如主按钮突出
///
/// 示例:
/// ```dart
/// SecondaryButton(
///   text: '取消',
///   onPressed: () => cancel(),
/// )
/// ```
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  
  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      
      // OutlinedButton 是描边按钮
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisSize: icon != null ? MainAxisSize.min : MainAxisSize.max,
                mainAxisAlignment:
                    icon != null ? MainAxisAlignment.center : null,
                children: [
                  if (icon != null) ...[
                    Icon(icon),
                    const SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}

/// ==================== 输入组件 ====================

/// 文本输入框
/// 
/// 封装了 TextFormField，使用主题样式
/// 
/// 使用场景：
/// - 表单输入
/// - 搜索框
/// - 任何需要文本输入的地方
///
/// 示例:
/// ```dart
/// AppTextField(
///   labelText: '用户名',
///   prefixIcon: Icons.person,
///   validator: (v) => v.isEmpty ? '必填' : null,
/// )
/// ```
class AppTextField extends StatelessWidget {
  /// 文本控制器
  final TextEditingController? controller;
  
  /// 标签文字
  final String? labelText;
  
  /// 提示文字
  final String? hintText;
  
  /// 前缀图标
  final IconData? prefixIcon;
  
  /// 后缀组件
  final Widget? suffixIcon;
  
  /// 是否隐藏文本（用于密码）
  final bool obscureText;
  
  /// 键盘类型
  final TextInputType? keyboardType;
  
  /// 验证器
  final String? Function(String?)? validator;
  
  /// 文本变化回调
  final ValueChanged<String>? onChanged;
  
  /// 编辑完成回调
  final VoidCallback? onEditingComplete;
  
  /// 最大行数
  final int? maxLines;
  
  /// 是否启用
  final bool enabled;
  
  /// 构造函数
  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.maxLines = 1,
    this.enabled = true,
  });
  
  @override
  Widget build(BuildContext context) {
    // TextFormField 是支持验证的文本输入框
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      maxLines: maxLines,
      enabled: enabled,
      
      // 使用主题的输入装饰
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// ==================== 卡片组件 ====================

/// 卡片组件
/// 
/// 封装了 Card 和 InkWell，提供点击效果
/// 
/// 使用场景：
/// - 列表项
/// - 选项卡
/// - 任何需要点击的卡片
///
/// 示例:
/// ```dart
/// AppCard(
///   onTap: () => openDetail(),
///   child: Text('卡片内容'),
/// )
/// ```
class AppCard extends StatelessWidget {
  /// 卡片内容
  final Widget child;
  
  /// 点击回调
  final VoidCallback? onTap;
  
  /// 内边距
  final EdgeInsetsGeometry? padding;
  
  /// 外边距
  final EdgeInsetsGeometry? margin;
  
  /// 构造函数
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      // 使用默认外边距
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      
      // InkWell 提供点击水波纹效果
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12), // 圆角
        
        // 内容区域
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}
