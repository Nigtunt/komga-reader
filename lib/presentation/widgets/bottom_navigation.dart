import 'package:flutter/material.dart';

/// 底部导航组件
class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  
  const BottomNavigationWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: '首页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_outlined),
          activeIcon: Icon(Icons.library),
          label: '浏览',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.download_outlined),
          activeIcon: Icon(Icons.download),
          label: '下载',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: '设置',
        ),
      ],
    );
  }
}
