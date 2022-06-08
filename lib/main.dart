import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:hedge_manager/helper/init.dart';
import 'package:hedge_manager/page/login/login.dart';
import 'package:hedge_manager/widget/desktop_sys_manager.dart';
import 'package:hedge_manager/widget/local_log.dart';
import 'package:hedge_manager/widget/modal_utils.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:window_manager/window_manager.dart';

import 'helper/global/lib_color_schemes.g.dart';
import 'helper/log_utils.dart';
import 'helper/navigator_helper.dart';

void main(List<String> args) async {
  if (runWebViewTitleBarWidget(args)) {
    return;
  }

  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    localNotifier.setup(appName: 'com.example.hedgeManager');

    await windowManager.ensureInitialized();

    windowManager.waitUntilReadyToShow().then((value) async {
      // await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      await windowManager.setSize(const Size(1250, 800));
      await windowManager.setTitle('保值监控');
      await windowManager.setMinimumSize(const Size(1250, 800));
      await windowManager.center();
      await windowManager.show();
    });
  }
  runZonedGuarded<Future<void>>(() async {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://4d789249c7bb474c9f603c9f0cea23cb@o396530.ingest.sentry.io/6419985';
        options.tracesSampleRate = 1.0;
      },
      appRunner: () => runApp(const MyApp()),
    );
  }, (Object error, StackTrace stackTrace) {
    _errorHandler(FlutterErrorDetails(exception: error, stack: stackTrace));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ModalStyleWidget(
      child: DesktopSysManager(
        child: NavigatorInitializer(
          child: MaterialApp(
            theme: ThemeData(colorScheme: lightColorScheme),
            builder: BotToastInit(),
            navigatorObservers: <NavigatorObserver>[
              BotToastNavigatorObserver()
            ],
            home: const LoginPage(),
          ),
        ),
      ),
    );
  }
}

//错误信息处理
void _errorHandler(FlutterErrorDetails details) async {
  await ReportError().reportError(details.exception, details.stack);
  LocalLog.setLog(
      '${LogLevel.ERROR.toString()} -- ${DateTime.now().toString()} -- ${details.exception}');

  if (ReportError().isInDebugMode) {
    FlutterError.dumpErrorToConsole(details);
  } else {
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  }

  if (details.exception is TimeoutException) {
    Log.info('_errorHandler TimeoutException');
  } else if (details.exception is SocketException) {
    Log.info('_errorHandler SocketException');
  } else if (details.exception is Exception) {
    Log.info('_errorHandler Exception');
  }
}
