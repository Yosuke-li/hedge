import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hedge_manager/helper/navigator.dart';
import 'package:hedge_manager/helper/webview_utils.dart';
import 'package:hedge_manager/page/hedge/hedge_page.dart';
import 'package:hedge_manager/page/login/login.dart';
import 'package:hedge_manager/page/login/webview_text.dart';
import 'package:hedge_manager/page/webview/webview_two.dart';
import 'package:hedge_manager/widget/management/common/view_key.dart';
import 'package:hedge_manager/widget/management/widget/custom_expansion_tile.dart';
import 'package:hedge_manager/widget/message_center/hedge_socket.dart';
import 'dart:math' as math;

import 'editor.dart';

class Tool extends StatefulWidget {
  final EditorController controller;

  const Tool({Key? key, required this.controller}) : super(key: key);

  @override
  _ToolState createState() => _ToolState();
}

class _GroupItem {
  final String title;
  final VoidCallback callback;

  _GroupItem(this.title, this.callback);
}

class _ToolState extends State<Tool> {
  final Map<String, bool> expanded = <String, bool>{};

  void _handleHedgeInfoTap() {
    widget.controller.open(
      key: ConstViewKey.hedgeInfo,
      tab: '套保监控',
      contentIfAbsent: (_) => const HedgePage(),
    );
  }

  // void _handleWebViewTap() {
  //   widget.controller.open(
  //     key: ConstViewKey.webViewInfo,
  //     tab: 'webView',
  //     contentIfAbsent: (_) => const ExampleBrowser(),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _handleHedgeInfoTap();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      padding: const EdgeInsets.only(bottom: 10),
      color: const Color(0xff333333),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const InkWell(
            child: SizedBox(
              width: 60,
              height: 60,
              child: Icon(
                IconData(0xec2e, fontFamily: 'AliIcons'),
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Material(
                  type: MaterialType.transparency,
                  child: buildToolGroup(
                    key: ConstViewKey.hedgeInfo,
                    groupName: '',
                    icon: Icon(
                      const IconData(0xe623, fontFamily: 'AliIcons'),
                      size: 30,
                      color: widget.controller.current?.key ==
                              ConstViewKey.hedgeInfo
                          ? const Color(0xff50A250)
                          : Colors.white,
                    ),
                    callback: () {
                      _handleHedgeInfoTap();
                    },
                  ),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: buildToolGroup(
                    key: ConstViewKey.webViewInfo,
                    groupName: '',
                    icon: Icon(
                      const IconData(0xeb8f, fontFamily: 'AliIcons'),
                      size: 30,
                      color: widget.controller.current?.key ==
                              ConstViewKey.webViewInfo
                          ? const Color(0xff50A250)
                          : Colors.white,
                    ),
                    callback: () {
                      WebViewUtils();
                    },
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              NavigatorUtils.pushWidget(context, const LoginPage(),
                  replaceCurrent: true);
            },
            child: Image.asset(
              'assets/img/tuichu.png',
              color: Colors.white,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildToolGroup(
      {required ViewKey key,
      required String groupName,
      List<_GroupItem>? groupItems,
      VoidCallback? callback,
      VoidCallback? longPressCallBack,
      Widget? icon}) {
    return CustomExpansionTile(
      value: expanded[groupName] == true,
      customHead: (_, animation) => InkWell(
        child: SizedBox(
          width: 60,
          height: 55,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      icon ??
                          Transform.rotate(
                            angle: math.pi * (1.5 + animation.value / 2),
                            child: const Icon(
                              Icons.expand_more,
                              size: 16,
                            ),
                          ),
                      if (groupName.isNotEmpty)
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            groupName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              Container(
                width: 4,
                color: widget.controller.current?.key == key
                    ? const Color(0xff50A250)
                    : const Color(0xff333333),
              ),
            ],
          ),
        ),
        onLongPress: () {
          longPressCallBack?.call();
        },
        onTap: () {
          if (callback != null) {
            callback.call();
          } else {
            if (expanded[groupName] == null) {
              expanded[groupName] = true;
            } else {
              expanded[groupName] = !expanded[groupName]!;
            }
          }
          setState(() {});
        },
      ),
      children: groupItems
              ?.map((e) => InkWell(
                    onTap: e.callback,
                    child: Container(
                      padding: const EdgeInsets.all(8.0).copyWith(left: 32),
                      alignment: Alignment.centerLeft,
                      child: Text(e.title),
                    ),
                  ))
              .toList(growable: false) ??
          [],
    );
  }
}
