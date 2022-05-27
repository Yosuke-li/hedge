import 'dart:async';

import 'package:hedge_manager/helper/global/setting.dart';
import 'package:hedge_manager/helper/log_utils.dart';
import 'package:hedge_manager/model/msg_content.dart';

class SocketMsgControl {
  static StreamController<MsgContent> _controller =
  StreamController<MsgContent>.broadcast();

  static void sendMsg(Event event) {
    _controller.add(event.msg);
  }

  static void clean() {
    _controller.close();
    _controller = StreamController<MsgContent>.broadcast();
  }

  late int _type;

  void init(int value) => _type = value;

  CancelCallBack listenEvent(
      {required Function(MsgContent test) listenFunc}) {
    final CancelCallBack callBack =
        _controller.stream.listen((MsgContent event) {
          listenFunc(event);
        }).cancel;
    return callBack;
  }

  void dispose() {
    _controller.close();
    _controller = StreamController<MsgContent>.broadcast();
  }
}