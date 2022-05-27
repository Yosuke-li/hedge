import 'dart:convert';
import 'dart:io';

import 'package:hedge_manager/helper/global/api.dart';
import 'package:hedge_manager/helper/log_utils.dart';
import 'package:hedge_manager/widget/api_call_back.dart';
import 'package:hedge_manager/widget/message_center/massage/socket_msg.dart';

typedef TryCatchFunc = Future<bool?>? Function();

class HedgeSocket {
  static int _reconnectTimes = 0;

  static HedgeSocket? _utils;

  static String _url = ApiUrl.webSocketUrl;

  static WebSocket? _webSocket;

  static TryCatchFunc? _tryCatchFunc;

  static bool onTapReconnect = false;

  factory HedgeSocket({required TryCatchFunc func}) =>
      _utils ?? HedgeSocket._setUtils(func);

  HedgeSocket._setUtils(TryCatchFunc func) {
    _init();
    _utils = this;
    _tryCatchFunc = func;
  }

  static Future<void> _init() async {
    try {
      _webSocket = await loadingCallback(() => WebSocket.connect(_url));
      _webSocket?.listen(_onEvent, onDone: _onDone, onError: _onError);
    } catch (err) {
      _tryCatchFunc?.call();
      throw const SocketException('connect fail');
    }
  }

  static _onDone() async {
    _tryCatchFunc?.call();
    Log.info('close sever');
  }

  static _reconnect() async {
    if (_reconnectTimes < 2) {
      _reconnectTimes++;
      try {
        SocketMsgConduit.clean();
        _webSocket = await loadingCallback(() => WebSocket.connect(_url));
        _webSocket?.listen(_onEvent, onDone: _onDone, onError: _onError);
      } catch (err) {
        _utils = null;
        _tryCatchFunc?.call();
        throw const SocketException('reconnect fail');
      }
    } else {
      _utils = null;
      throw const SocketException('reconnect fail');
    }
  }

  static _onEvent(event) {
    Log.info('${_webSocket.hashCode}: $event');
    SocketMsgConduit.listener(event);
    if (onTapReconnect) {
      SocketMsgConduit.onTapReconnect();
      onTapReconnect = false;
    }
  }

  static _onError(err, stack) {
    _utils = null;
    Log.error('on error: $err', stackTrace: stack);
  }

  static onChangeUrl() {
    _url = ApiUrl.webSocketUrl;
  }

  static void dispose() async {
    _utils = null;
    _reconnectTimes = 0;
    _tryCatchFunc = null;
    onTapReconnect = false;
    SocketMsgConduit.clean();
    _webSocket?.done;
    _webSocket?.close();
    _webSocket = null;
  }
}
