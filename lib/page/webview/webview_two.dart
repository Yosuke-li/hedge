// import 'package:hedge_manager/helper/dio/dio_helper.dart';
// import 'package:hedge_manager/helper/global/api.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;
// import 'package:shell/shell.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'dart:async';
//
// import 'package:webview_windows/webview_windows.dart';
//
// final navigatorKey = GlobalKey<NavigatorState>();
//
// class ExampleBrowser extends StatefulWidget {
//   const ExampleBrowser({Key? key}) : super(key: key);
//
//   @override
//   State<ExampleBrowser> createState() => _ExampleBrowser();
// }
//
// class _ExampleBrowser extends State<ExampleBrowser> {
//   final _controller = WebviewController();
//   String? now;
//
//   static Future<String> _getDocument() async {
//     final document = await getApplicationDocumentsDirectory();
//     return path.join(document.path, 'MicrosoftEdgeWebview2Setup.exe');
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }
//
//   Future<void> initPlatformState() async {
//     try {
//       await _controller.initialize();
//       _controller.url.listen((url) {});
//
//       await _controller.setBackgroundColor(Colors.transparent);
//       // await _controller.openDevTools();
//       await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
//       await _controller.loadUrl(ApiUrl.webViewUrl);
//
//       if (!mounted) return;
//       setState(() {});
//     } on PlatformException catch (e) {
//       WidgetsBinding.instance?.addPostFrameCallback((_) {
//         showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             title: const Text('出错了'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Code: ${e.code}'),
//                 Text('Message: ${e.message}'),
//               ],
//             ),
//             actions: [
//               if (e.code == 'environment_creation_failed')
//                 TextButton(
//                   onPressed: () async {
//                     final getPath = await _getDocument();
//                     await Request.downloadFile(
//                         'https://go.microsoft.com/fwlink/p/?LinkId=2124703',
//                         getPath, (int loaded, int total) {
//                       now = (loaded / total * 100).toStringAsFixed(2);
//                       setState(() {});
//                     }).whenComplete(() async {
//                       final shell = Shell();
//                       await shell.start(getPath);
//                     });
//                   },
//                   child: const Text('下载并安装相应环境'),
//                 ),
//               TextButton(
//                 child: const Text('退出'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               )
//             ],
//           ),
//         );
//       });
//     }
//   }
//
//   Widget compositeView() {
//     if (!_controller.value.isInitialized) {
//       return const Text(
//         '加载中...如若遇到windows版本过低无法使用此页面，请长按左边图标',
//         style: TextStyle(
//           fontSize: 24.0,
//           fontWeight: FontWeight.w900,
//         ),
//       );
//     } else {
//       return Webview(
//         _controller,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: compositeView(),
//       ),
//     );
//   }
// }
