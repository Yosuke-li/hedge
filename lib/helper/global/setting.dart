import 'package:hedge_manager/model/msg_content.dart';

class Event {
  late MsgContent msg;
  late bool isReconnect;
}

typedef CancelCallBack = void Function();