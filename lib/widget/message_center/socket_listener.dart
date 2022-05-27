import 'package:flutter/material.dart';
import 'package:hedge_manager/helper/log_utils.dart';
import 'package:hedge_manager/model/msg_content.dart';
import 'package:hedge_manager/widget/message_center/massage/socket_msg_control.dart';

mixin SocketListener<T extends StatefulWidget> on State<T> {
  int get msgType;

  List<int> get listenerTypes;

  SocketMsgControl control = SocketMsgControl();

  void onListener(void Function(MsgContent msgContent) listener) {
    control.listenEvent(listenFunc: (MsgContent msgContent) {
      listener.call(msgContent);
    });
  }

  @override
  void initState() {
    control.init(T.hashCode);
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }
}