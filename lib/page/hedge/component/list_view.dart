import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hedge_manager/helper/array_helper.dart';
import 'package:hedge_manager/helper/log_utils.dart';
import 'package:hedge_manager/model/hedging_order.dart';
import 'package:hedge_manager/model/hedging_strategy.dart';
import 'package:hedge_manager/model/pricing_apply.dart';
import 'package:hedge_manager/page/hedge/component/controller.dart';
import 'package:hedge_manager/page/hedge/component/tree_view_two.dart';
import 'package:hedge_manager/widget/message_center/massage/socket_msg.dart';
import 'package:hedge_manager/widget/message_center/socket_listener.dart';

class ListViewPage extends StatefulWidget {
  final HedgeController controller;

  const ListViewPage({required this.controller, Key? key}) : super(key: key);

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage>
    with SocketListener<ListViewPage> {
  List<HedgingStrategy> strategies = <HedgingStrategy>[];
  late String schemeId;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      _changeStrategies();
    });

    onListener((msgContent) {
      if (msgContent.type == msgType) {
        _changeStrategies();
      }
    });
  }

  void _changeStrategies() {
    schemeId = widget.controller.hedgingSchemeId;
    strategies.clear();
    strategies.addAll(SocketMsgConduit.getHedgingStrategies);

    strategies = strategies
        .where(
          (element) => (element.ownerSchId == schemeId),
        )
        .toList();
    strategies.sort((a, b) => a.priorityNo.compareTo(b.priorityNo));
    Log.info(jsonEncode(strategies));

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant ListViewPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final HedgingStrategy strategy = ArrayHelper.get(strategies, index)!;
        return TreeViewSecPage(
          key: Key(strategy.strategyId.toString()),
          hedgingStrategy: strategy,
          isFreeze: strategy.stgStatus == 3,
          controller: widget.controller,
        );
      },
      itemCount: strategies.length,
    );
  }

  @override
  List<int> get listenerTypes => [2, 3, 4, 5, 6];

  @override
  int get msgType => 3;
}
