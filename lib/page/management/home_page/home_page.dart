import 'package:flutter/material.dart';
import 'package:hedge_manager/helper/event_bus_helper.dart';
import 'package:hedge_manager/helper/global/setting.dart';
import 'package:hedge_manager/helper/log_utils.dart';
import 'package:hedge_manager/helper/store.dart';
import 'package:hedge_manager/page/management/home_page/tool.dart';
import 'package:hedge_manager/widget/message_center/massage/socket_msg_widget.dart';
import 'package:hedge_manager/widget/message_center/socket_widget.dart';

import 'editor.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SocketWidget(
      child: _HomeChildPage(),
    );
  }
}

class _HomeChildPage extends StatefulWidget {
  @override
  _HomeChildPageState createState() => _HomeChildPageState();
}

class _HomeChildPageState extends State<_HomeChildPage> {
  EditorController editorController = EditorController();

  @override
  void dispose() {
    editorController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Log.init(isDebug: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/img.png'),
            alignment: Alignment.topCenter,
          ),
        ),
        child: Row(
          children: [
            Tool(
              key: Key(editorController.hashCode.toString()),
              controller: editorController,
            ),
            Expanded(
              child: Editor(
                key: Key(editorController.hashCode.toString()),
                controller: editorController,
              ),
            ),
            //todo 之后的日志
            // Expanded(
            //   child: Column(
            //     children: [
            //       SocketMsgWidget(
            //         key: Key(editorController.hashCode.toString()),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
