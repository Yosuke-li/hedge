import 'package:hedge_manager/helper/global/user.dart';
import 'package:hedge_manager/helper/webview_utils.dart';
import 'package:hedge_manager/widget/message_center/hedge_socket.dart';

import '../dio/dio_helper.dart';

class Url {
  static const String releaseWeb = 'http://119.29.116.64:51215/#main/5';
  static const String releaseDio = 'http://119.29.116.64:51215';
  static const String releaseSocket = 'ws://119.29.116.64:51216';

  static String debugWeb = 'http://172.31.41.83:8081';
  static String debugDio = 'http://172.31.41.83:8081';
  static String debugSocket = 'ws://172.31.41.83:8009';
}

class ApiUrl {
  static String webViewUrl =
      Global.environment == 'debug' ? Url.debugWeb : Url.releaseWeb;

  static String dioUrl =
      Global.environment == 'debug' ? Url.debugDio : Url.releaseDio;

  static String webSocketUrl =
      Global.environment == 'debug' ? Url.debugSocket : Url.releaseWeb;

  static void changing() {
    webViewUrl = Global.environment == 'debug' ? Url.debugWeb : Url.releaseWeb;

    dioUrl = Global.environment == 'debug' ? Url.debugDio : Url.releaseDio;

    webSocketUrl =
        Global.environment == 'debug' ? Url.debugSocket : Url.releaseWeb;

    Request.onChangeUrl();
    WebViewUtils.onChangeUrl();
    HedgeSocket.onChangeUrl();
  }
}
