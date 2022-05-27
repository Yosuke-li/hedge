import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hedge_manager/helper/array_helper.dart';
import 'package:hedge_manager/helper/log_utils.dart';
import 'package:hedge_manager/model/enter_strategy.dart';
import 'package:hedge_manager/model/hedging_order.dart';
import 'package:hedge_manager/model/hedging_scheme.dart';
import 'package:hedge_manager/model/hedging_strategy.dart';
import 'package:hedge_manager/model/pricing_apply.dart';
import 'package:hedge_manager/page/hedge/component/controller.dart';
import 'package:hedge_manager/page/hedge/hedge_helper.dart';
import 'package:hedge_manager/widget/message_center/massage/socket_msg.dart';
import 'package:hedge_manager/widget/message_center/socket_listener.dart';

class TreeViewSecPage extends StatefulWidget {
  final bool isFreeze;
  final HedgingStrategy hedgingStrategy;
  final HedgeController controller;

  const TreeViewSecPage({
    Key? key,
    required this.hedgingStrategy,
    this.isFreeze = false,
    required this.controller,
  }) : super(key: key);

  @override
  State<TreeViewSecPage> createState() => _TreeViewSecPageState();
}

class _TreeViewSecPageState extends State<TreeViewSecPage> {
  late bool showTree;
  late HedgingStrategy hedgingStrategy = widget.hedgingStrategy;
  List<HedgingOrder> orders = <HedgingOrder>[];

  @override
  void initState() {
    super.initState();
    showTree = false;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  void init() {
    orders = HedgeSumHelper.getOrders(hedgingStrategy.strategyId);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: showTree == true && orders.isNotEmpty == true
            ? const Color(0xffFDF8FC)
            : Colors.white,
        border: Border.all(
          color: const Color(0xffCAC4D0),
          width: showTree == true && orders.isNotEmpty == true ? 0.5 : 1.0,
          style: BorderStyle.solid,
        ),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: widget.isFreeze != true
                ? () {
                    showTree = !showTree;
                    setState(() {});
                  }
                : null,
            child: _TreeViewItemPage(
              key: Key(widget.hedgingStrategy.hashCode.toString()),
              hedgingStrategy: widget.hedgingStrategy,
              isFreeze: widget.isFreeze,
              showTree: showTree,
              controller: widget.controller,
            ),
          ),
          widget.isFreeze
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(right: 300, top: 20),
                    child: Transform.rotate(
                      angle: 50,
                      child: Container(
                        child: const Text(
                          '已冻结',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

class _TreeViewItemPage extends StatefulWidget {
  final HedgingStrategy hedgingStrategy;
  final bool isFreeze;
  final bool showTree;
  final HedgeController controller;

  const _TreeViewItemPage(
      {Key? key,
      required this.hedgingStrategy,
      required this.controller,
      this.isFreeze = false,
      this.showTree = true})
      : super(key: key);

  @override
  State<_TreeViewItemPage> createState() => _TreeViewItemPageState();
}

class _TreeViewItemPageState extends State<_TreeViewItemPage>
    with SocketListener<_TreeViewItemPage> {
  late HedgingStrategy hedgingStrategy = widget.hedgingStrategy;

  EnterStrategy? enterStrategy;
  List<HedgingOrder> orders = <HedgingOrder>[];
  List<PricingApply> prices = <PricingApply>[];

  final ScrollController _controller = ScrollController();
  late String key;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      init();
      _onListener();
    });

    widget.controller.addListener(() {
      init(key: widget.controller.searchKey);
    });
  }

  void init({String? key}) {
    if (hedgingStrategy.enterStgId != '-1') {
      enterStrategy = getEnterStrategy(hedgingStrategy.enterStgId);
    }
    orders = HedgeSumHelper.getOrders(hedgingStrategy.strategyId);
    if (key != null && key.isNotEmpty == true) {
      prices.clear();
      prices.addAll(SocketMsgConduit.getPricingApplies);
      prices = prices.where((element) {
        return element.pricingUsingCode
            .toUpperCase()
            .contains(key.toUpperCase());
      }).toList();
      orders = orders
          .where((element) => prices
              .map((e) => e.pricingId)
              .toList()
              .contains(element.ownerPricingId))
          .toList();
    }
    orders = orders
        .where((element) =>
            widget.controller.status.contains(element.hedgingStatus))
        .toList();
    if (mounted) {
      setState(() {});
    }
  }

  static EnterStrategy? getEnterStrategy(String stgId) {
    List<EnterStrategy> enterStrategies = SocketMsgConduit.getEnterStrategies;
    enterStrategies = enterStrategies
        .where((element) => element.enterStgId == stgId)
        .toList();
    if (enterStrategies.isNotEmpty == true) {
      return enterStrategies.first;
    }
    return null;
  }

  void _onListener() {
    onListener((msgContent) {
      init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: widget.showTree == true && orders.isNotEmpty == true
              ? const EdgeInsets.only(top: 20, left: 20, right: 20)
              : const EdgeInsets.only(top: 20, left: 20, right: 15, bottom: 20),
          padding: widget.showTree == true && orders.isNotEmpty == true
              ? const EdgeInsets.only(bottom: 20)
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 380,
                child: Row(
                  children: [
                    Text(
                      hedgingStrategy.enterStgId != '-1'
                          ? (enterStrategy?.enterStgName ?? '')
                          : (hedgingStrategy.enterUsingCode == null
                              ? '不进场'
                              : '标的进场'),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: widget.isFreeze
                            ? const Color(0x802196F3)
                            : (hedgingStrategy.enterStgId == '-1'
                                ? hedgingStrategy.enterUsingCode == null
                                    ? const Color(0xff8C1D18)
                                    : Colors.green
                                : const Color(0xff6E6EC4)),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      hedgingStrategy.enterUsingCode ?? '',
                      style: TextStyle(
                          fontSize: 26,
                          color: widget.isFreeze
                              ? const Color(0x80000000)
                              : Colors.black),
                    )
                  ],
                ),
              ),
              Scrollbar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Scrollbar(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (hedgingStrategy.futQty != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '已占  /  已用  /  可用期货数量',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: widget.isFreeze
                                          ? const Color(0x80797979)
                                          : const Color(0xff797979),
                                    ),
                                  ),
                                  Text(
                                    '${(hedgingStrategy.usedFutQty ?? 0).toStringAsFixed(1)} / ${(hedgingStrategy.completedFutQty ?? 0).toStringAsFixed(1)} / ${(hedgingStrategy.futQty! - (hedgingStrategy.usedFutQty ?? 0) - (hedgingStrategy.completedFutQty ?? 0)).toStringAsFixed(1)} 吨',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: widget.isFreeze
                                            ? const Color(0x80000000)
                                            : Colors.black),
                                  )
                                ],
                              ),
                            const SizedBox(
                              width: 50,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '已占  /  已用  /  可用现货数量',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: widget.isFreeze
                                        ? const Color(0x80797979)
                                        : const Color(0xff797979),
                                  ),
                                ),
                                Text(
                                  '${(hedgingStrategy.usedSpotQty).toStringAsFixed(1)} / ${(hedgingStrategy.completedSpotQty).toStringAsFixed(1)} /  ${(hedgingStrategy.spotQty - hedgingStrategy.completedSpotQty - hedgingStrategy.usedSpotQty).toStringAsFixed(1)}吨',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: widget.isFreeze
                                          ? const Color(0x80000000)
                                          : Colors.black),
                                )
                              ],
                            ),
                            if (hedgingStrategy.futQty != null)
                              const SizedBox(
                                width: 50,
                              ),
                            if (hedgingStrategy.futQty != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '当前  /  预期套保比例',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: widget.isFreeze
                                            ? const Color(0x80797979)
                                            : const Color(0xff797979)),
                                  ),
                                  Text(
                                    '${hedgingStrategy.completedSpotQty != 0 ? (((hedgingStrategy.completedFutQty ?? 0) / hedgingStrategy.completedSpotQty) * 100).toStringAsFixed(1) : 0}% / ${hedgingStrategy.spotQty != 0 ? ((hedgingStrategy.futQty! / hedgingStrategy.spotQty) * 100).toStringAsFixed(1) : 0}%',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: widget.isFreeze
                                            ? const Color(0x80000000)
                                            : Colors.black),
                                  )
                                ],
                              ),
                            const SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: widget.showTree
                          ? const Icon(Icons.keyboard_arrow_down)
                          : const Icon(Icons.keyboard_arrow_right),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Visibility(
          key: Key(orders.hashCode.toString()),
          visible: widget.showTree == true && orders.isNotEmpty == true,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 100, maxHeight: 150),
            child: Scrollbar(
              controller: _controller,
              child: Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                  color: Color(0xffF5EEFA),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: ListView.builder(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final order = ArrayHelper.get(orders, index)!;
                    final PricingApply? price =
                        HedgeSumHelper.getPrice(order.ownerPricingId);
                    final filledPrice =
                        HedgeSumHelper.filledOrderSumPrice(order.orderId);
                    return Container(
                      width: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xff797979),
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding:
                          const EdgeInsets.only(top: 10, right: 10, left: 10),
                      margin: const EdgeInsets.only(right: 10, left: 10),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '点价价格/最新成交',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff797979),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${price?.pricingPrice ?? 0}',
                                          style: const TextStyle(
                                              color: Colors.blue),
                                        ),
                                        const Text('/74,670'),
                                        const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 20,
                                          color: Colors.green,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      '成交数量/点价数量',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff797979),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          color: Colors.amber,
                                          child: Text(
                                            '${price?.pricedSpotQty.toStringAsFixed(1) ?? 0}',
                                          ),
                                        ),
                                        Container(
                                          color: Colors.amberAccent,
                                          child: Text(
                                            '/ ${price?.pricingSpotQty.toStringAsFixed(1) ?? 0}',
                                          ),
                                        ),
                                        const Text('吨'),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (hedgingStrategy.enterUsingCode != null)
                            SizedBox(
                              height: 1.0,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Container(
                                color: const Color(0xff797979),
                              ),
                            ),
                          if (hedgingStrategy.enterUsingCode != null)
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          hedgingStrategy.enterStgId != '-1'
                                              ? (enterStrategy?.enterStgName ??
                                                  '')
                                              : '标的进场',
                                          style: TextStyle(
                                              color:
                                                  hedgingStrategy.enterStgId !=
                                                          '-1'
                                                      ? Colors.blue
                                                      : Colors.green,
                                              fontSize: 15),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          hedgingStrategy.enterUsingCode ?? '',
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              color: Colors.greenAccent,
                                              child: Text(
                                                '${order.completedFutQty.toStringAsFixed(1)}',
                                              ),
                                            ),
                                            Container(
                                              color: Colors.greenAccent,
                                              child: Text(
                                                '/${order.hedgeQty.toStringAsFixed(1)}',
                                              ),
                                            ),
                                            const Text('吨'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              '成交均价',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Color(0xff797979),
                                              ),
                                            ),
                                            Text(
                                              filledPrice.toStringAsFixed(0),
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                  itemCount: orders.length,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  List<int> get listenerTypes => [2, 3, 4, 5, 6, 7];

  @override
  int get msgType => 3;
}