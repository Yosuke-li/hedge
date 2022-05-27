import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hedge_manager/helper/log_utils.dart';
import 'package:hedge_manager/widget/toast_utils.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

/// 系统托盘
class DesktopSysManager extends StatefulWidget {
  Widget child;

  DesktopSysManager({Key? key, required this.child}) : super(key: key);

  @override
  _DesktopSysManagerState createState() => _DesktopSysManagerState();
}

class _DesktopSysManagerState extends State<DesktopSysManager>
    with TrayListener {
  final TrayManager _trayManager = TrayManager.instance;

  @override
  void initState() {
    super.initState();
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      _trayManager.addListener(this);
      _show();
    }
  }

  /// 系统托盘里显示图标
  void _show() async {
    await _trayManager.setIcon('assets/img/favicon.ico');
    _generateContextMenu();
  }

  /// 设置菜单项
  void _generateContextMenu() async {
    List<MenuItem> items = [
      MenuItem(label: '首页'),
      MenuItem(label: '中台'),
    ];
    await _trayManager.setContextMenu(Menu(items: items));
  }

  @override
  void onTrayIconMouseDown() async {
    await windowManager.show();
    Log.info('鼠标左键点击');
  }

  @override
  void onTrayIconRightMouseDown() async {
    await _trayManager.popUpContextMenu();
    Log.info('鼠标右键点击');
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    ToastUtils.showToast(msg: '你选择了${menuItem.label}');
  }

  @override
  void dispose() {
    if (mounted) {
      return;
    }
    _trayManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
