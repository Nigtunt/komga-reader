/// Flutter 漫画阅读器 - 底部导航组件
/// 
/// 这个文件提供应用的底部导航栏
/// 包含 4 个 Tab：
/// 1. 首页
/// 2. 浏览
/// 3. 下载
/// 4. 设置
/// 
/// 使用 Material Design 的 BottomNavigationBar

import 'package:flutter/material.dart';

/// 底部导航组件
/// 
/// 这是一个无状态组件（StatelessWidget）
/// 因为状态由父组件管理
class BottomNavigationWidget extends StatelessWidget {
  /// 当前选中的 Tab 索引
  final int currentIndex;
  
  /// Tab 切换回调
  /// 
  /// [index] 选中的 Tab 索引
  final ValueChanged<int> onTap;
  
  /// 构造函数
  const BottomNavigationWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // BottomNavigationBar 是 Material Design 的底部导航栏
    return BottomNavigationBar(
      // 当前选中的索引
      currentIndex: currentIndex,
      
      // Tab 切换回调
      onTap: onTap,
      
      // 导航项列表
      items: const [
        // 1. 首页
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),      // 未选中图标
          activeIcon: Icon(Icons.home),          // 选中图标
          label: '首页',                         // 标签文字
        ),
        
        // 2. 浏览
        BottomNavigationBarItem(
          icon: Icon(Icons.library_outlined),
          activeIcon: Icon(Icons.library),
          label: '浏览',
        ),
        
        // 3. 下载
        BottomNavigationBarItem(
          icon: Icon(Icons.download_outlined),
          activeIcon: Icon(Icons.download),
          label: '下载',
        ),
        
        // 4. 设置
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: '设置',
        ),
      ],
    );
  }
}
