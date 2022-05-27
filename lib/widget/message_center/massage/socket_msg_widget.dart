import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:hedge_manager/helper/array_helper.dart';
import 'package:hedge_manager/helper/log_utils.dart';
import 'package:hedge_manager/model/msg_content.dart';
import 'package:hedge_manager/widget/message_center/massage/socket_msg.dart';
import 'package:hedge_manager/widget/message_center/socket_listener.dart';

class SocketMsgWidget extends StatefulWidget {
  const SocketMsgWidget({Key? key}) : super(key: key);

  @override
  State<SocketMsgWidget> createState() => _SocketMsgWidgetState();
}

class _SocketMsgWidgetState extends State<SocketMsgWidget> with SocketListener {
  List<MsgContent> _msgs = <MsgContent>[];
  int now = 0;

  @override
  void initState() {
    super.initState();
    _init();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _msgs = SocketMsgConduit.getAll;
      _msgs.removeWhere((element) => element.content.isEmpty);
      setState(() {});
    });
  }

  void _init() {
    onListener((msgContent) {
      _msgs.add(msgContent);
      _msgs.removeWhere((element) => element.content.isEmpty);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: RepaintBoundary(
              child: Swiper.list(
                loop: false,
                autoplay: now == (_msgs.length - 1) ? false : true,
                scrollDirection: Axis.vertical,
                list: _msgs,
                index: now,
                onIndexChanged: (int index) {
                  now = index;
                  setState(() {});
                },
                builder: (BuildContext context, dynamic data, int index) {
                  final _msg = ArrayHelper.get(_msgs, index);
                  return SizedBox(
                    height: 50,
                    child: Text('$index: ${_msg?.content}'),
                  );
                },
              ),
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Row(
                  children: const [
                    Text('查看更多'),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.file_copy, size: 15)
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const _DateTimer(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  List<int> get listenerTypes => [2, 3, 4, 5, 6];

  @override
  int get msgType => 2;
}

class _DateTimer extends StatefulWidget {
  const _DateTimer({Key? key}) : super(key: key);

  @override
  State<_DateTimer> createState() => _DateTimerState();
}

class _DateTimerState extends State<_DateTimer> {
  DateTime now = DateTime.now();
  late void Function() _timer;

  void startClock() {
    _timer = Timer.periodic(const Duration(microseconds: 1000), (Timer t) {
      if (!mounted) {
        return;
      }
      setState(() {
        now = DateTime.now();
      });
    }).cancel;
    setState(() {});
  }

  String pad0(int num) {
    if (num < 10) {
      return '0${num.toString()}';
    }
    return num.toString();
  }

  @override
  void initState() {
    super.initState();
    startClock();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.call();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: 150,
        child: Text(
            '${now.year}-${pad0(now.month)}-${pad0(now.day)} ${pad0(now.hour)}:${pad0(now.minute)}:${pad0(now.second)}'),
      ),
    );
  }
}
