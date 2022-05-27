import 'package:hedge_manager/helper/global/user.dart';
import 'package:hedge_manager/helper/webview_utils.dart';
import 'package:hedge_manager/widget/message_center/hedge_socket.dart';

import '../dio/dio_helper.dart';

class ApiUrl {
  static String webViewUrl = Global.environment == 'debug'
      ? 'http://172.31.41.83:8081'
      : 'http://119.29.116.64:51215/#main/5';

  static String dioUrl = Global.environment == 'debug'
      ? 'http://172.31.41.83:8081'
      : 'http://119.29.116.64:51215';

  static String webSocketUrl = Global.environment == 'debug'
      ? 'ws://172.31.41.83:8009'
      : 'ws://119.29.116.64:51216';

  static void changing() {
    webViewUrl = Global.environment == 'debug'
        ? 'http://172.31.41.83:8081'
        : 'http://119.29.116.64:51215/#main/5';

    dioUrl = Global.environment == 'debug'
        ? 'http://172.31.41.83:8081'
        : 'http://119.29.116.64:51215';

    webSocketUrl = Global.environment == 'debug'
        ? 'ws://172.31.41.83:8009'
        : 'ws://119.29.116.64:51216';

    Request.onChangeUrl();
    WebViewUtils.onChangeUrl();
    HedgeSocket.onChangeUrl();
  }
}
