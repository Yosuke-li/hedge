import 'package:flutter/material.dart';
import 'package:hedge_manager/helper/event_bus_helper.dart';
import 'package:hedge_manager/helper/global/setting.dart';
import 'package:hedge_manager/helper/log_utils.dart';
import 'package:hedge_manager/helper/navigator.dart';
import 'package:hedge_manager/page/login/login.dart';
import 'package:hedge_manager/widget/api_call_back.dart';
import 'package:hedge_manager/widget/message_center/hedge_socket.dart';
import 'package:hedge_manager/widget/modal_utils.dart';

class SocketWidget extends StatefulWidget {
  final Widget child;

  const SocketWidget({required this.child, Key? key}) : super(key: key);

  @override
  State<SocketWidget> createState() => _SocketWidgetState();
}

class _SocketWidgetState extends State<SocketWidget> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    HedgeSocket(
      func: () {
        return ModalUtils.showModal(
          context,
          modalSize: ModalSize(width: 300),
          outsideDismiss: false,
          body: SizedBox(
            height: 100,
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '操作',
                          style: TextStyle(fontSize: 20),
                        ),
                        InkWell(
                          onTap: () {
                            NavigatorUtils.pushWidget(context, const LoginPage(),
                                replaceRoot: true);
                          },
                          child: const Icon(Icons.close),
                        )
                      ],
                    )
                ),
                const Expanded(
                  child: Center(
                    child: Text('与服务器断开连接，请选择接下来的操作'),
                  ),
                ),
              ],
            ),
          ),
          button1: const Text('重连'),
          onFun1: (context) async {
            HedgeSocket.dispose();
            NavigatorUtils.pop(context);
            await _init();
            HedgeSocket.onTapReconnect = true;
          },
          button2: const Text('返回登陆页面'),
          onFun2: (context) {
            NavigatorUtils.pushWidget(context, const LoginPage(),
                replaceRoot: true);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    HedgeSocket.dispose();
    Log.info('_SocketWidgetState dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
