import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hedge_manager/helper/log_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class WebViewText extends StatefulWidget {
  const WebViewText({
    Key? key,
  }) : super(key: key);

  @override
  State<WebViewText> createState() => _WebViewTextState();
}

class _WebViewTextState extends State<WebViewText> {
  static const String _url = 'http://39.108.117.149:8085/#login';

  final List<String> _allUrl = [];

  Future<String> _getDocument() async {
    final document = await getApplicationDocumentsDirectory();
    return path.join(document.path, 'flutter_desktop');
  }

  void _open() async {
    final webView = await WebviewWindow.create(
      configuration: CreateConfiguration(
        title: '设置',
        userDataFolderWindows: await _getDocument(),
      ),
    );
    webView.onClose.whenComplete(() => Log.info('Web窗口已关闭'));
    webView.launch(_url);
  }

  void _closeAll() async {
    WebviewWindow.clearAll().whenComplete(() => Log.info('所有Web窗口已关闭'));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _open();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Log.info('didChangeDependencies');
  }

  @override
  void didUpdateWidget(covariant WebViewText oldWidget) {
    super.didUpdateWidget(oldWidget);
    Log.info('didUpdateWidget');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('你已安装WebView2 Runtime'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _open,
              child: const Text('重新打开'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _closeAll,
              child: const Text('关闭所有Web窗口'),
            ),
            const SizedBox(height: 16),
            const Text('浏览历史：'),
            ...List.generate(_allUrl.length, (index) => Text(_allUrl[index]))
                .toList(),
          ],
        ),
      ),
    );
  }
}
