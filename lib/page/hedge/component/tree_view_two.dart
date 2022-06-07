import 'dart:convert';

import 'package:flutter/gestures.dart';
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
              key: Key(widget.hedgingStrategy.strategyId.toString()),
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
    hedgingStrategy = getHedgingStrategy(hedgingStrategy.strategyId) ??
        widget.hedgingStrategy;
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

  static HedgingStrategy? getHedgingStrategy(String id) {
    List<HedgingStrategy> hedges = SocketMsgConduit.getHedgingStrategies;
    hedges = hedges.where((element) => element.strategyId == id).toList();
    if (hedges.isNotEmpty == true) {
      return hedges.first;
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
          child: Container(
            height: 183,
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
                    final HedgingOrder order = ArrayHelper.get(orders, index)!;
                    final PricingApply? price =
                        HedgeSumHelper.getPrice(order.ownerPricingId);
                    return _OrderPriceItem(
                      key: Key(price?.pricingId ?? ''),
                      order: order,
                      hedgingStrategy: hedgingStrategy,
                      price: price,
                      enterStrategy: enterStrategy,
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

class _OrderPriceItem extends StatefulWidget {
  final HedgingOrder order;
  final PricingApply? price;
  final HedgingStrategy hedgingStrategy;
  final EnterStrategy? enterStrategy;

  const _OrderPriceItem(
      {Key? key,
      this.price,
      this.enterStrategy,
      required this.order,
      required this.hedgingStrategy})
      : super(key: key);

  @override
  State<_OrderPriceItem> createState() => _OrderPriceItemState();
}

class _OrderPriceItemState extends State<_OrderPriceItem> {
  bool isHover = false;
  late double filledPrice;
  late HedgingOrder order;
  late PricingApply? price;
  late HedgingStrategy hedgingStrategy = widget.hedgingStrategy;

  @override
  void initState() {
    super.initState();
    order = widget.order;
    price = widget.price;
    filledPrice = HedgeSumHelper.filledOrderSumPrice(order.orderId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        isHover = true;
        setState(() {});
      },
      onExit: (_) {
        isHover = false;
        setState(() {});
      },
      child: Stack(
        children: [
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xff797979),
                width: 1.0,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.only(top: 5, right: 10, left: 10),
            margin: const EdgeInsets.only(right: 10, left: 10),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Text('ID: ${price?.pricingId}'),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  height: 43,
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
                          const SizedBox(
                            height: 1.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${price?.pricingPrice.toStringAsFixed(0) ?? 0}',
                                style: const TextStyle(color: Colors.blue),
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
                          Container(
                            width: 110,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '成交数量 / 点价数量 ',
                              style: TextStyle(
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                                color: Color(0xff797979),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 95,
                                    height: 18,
                                    child: LinearProgressIndicator(
                                      value: price?.pricingSpotQty == null ? 0 : ((price?.pricedSpotQty??0) / (price?.pricingSpotQty??1)),
                                      backgroundColor: Color(0xffFFF2CC),
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFFE18E)),
                                    ),
                                  ),
                                  Container(
                                    width: 95,
                                    height: 18,
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          ' ${HedgeSumHelper.checkNumFixedIsAllZero(price?.pricedSpotQty ?? 0) ? price?.pricedSpotQty.toStringAsFixed(0) : price?.pricedSpotQty.toStringAsFixed(1) ?? 0} ',
                                          style: TextStyle(
                                            fontSize:
                                            (price?.pricedSpotQty ?? 0) < 10000
                                                ? 14
                                                : 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          width: 5,
                                          height: 18,
                                          child: Text('/'),
                                        ),
                                        Text(
                                          ' ${HedgeSumHelper.checkNumFixedIsAllZero(price?.pricingSpotQty ?? 0) ? price?.pricingSpotQty.toStringAsFixed(0) : price?.pricingSpotQty.toStringAsFixed(1) ?? 0} ',
                                          style: TextStyle(
                                            fontSize:
                                            (price?.pricingSpotQty ?? 0) < 10000
                                                ? 14
                                                : 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 15,
                                alignment: Alignment.centerRight,
                                child: const Text('吨'),
                              ),
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
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text(
                                hedgingStrategy.enterStgId != '-1'
                                    ? (widget.enterStrategy?.enterStgName ?? '')
                                    : '标的进场',
                                style: TextStyle(
                                    color: hedgingStrategy.enterStgId != '-1'
                                        ? Colors.blue
                                        : Colors.green,
                                    fontSize: 15),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                hedgingStrategy.enterUsingCode ?? '',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: 95,
                                        height: 18,
                                        child: LinearProgressIndicator(
                                          value: order.hedgeQty != 0 ? (order.completedFutQty / order.hedgeQty) : 0,
                                          backgroundColor: Color(0xffEFF6EC),
                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xffC6FFBD)),
                                        ),
                                      ),
                                      Container(
                                        width: 95,
                                        height: 18,
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              ' ${HedgeSumHelper.checkNumFixedIsAllZero(order.completedFutQty) ? order.completedFutQty.toStringAsFixed(0) : order.completedFutQty.toStringAsFixed(1)} ',
                                              style: TextStyle(
                                                fontSize:
                                                order.completedFutQty < 10000
                                                    ? 14
                                                    : 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Container(
                                              width: 5,
                                              height: 18,
                                              child: Text('/'),
                                            ),
                                            Text(
                                              ' ${HedgeSumHelper.checkNumFixedIsAllZero(order.hedgeQty) ? order.hedgeQty.toStringAsFixed(0) : order.hedgeQty.toStringAsFixed(1)} ',
                                              style: TextStyle(
                                                fontSize:
                                                order.hedgeQty < 10000
                                                    ? 14
                                                    : 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 15,
                                    alignment: Alignment.centerRight,
                                    child: const Text('吨'),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2.0,
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
          ),
          isHover
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 300,
                    height: 65,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    color: Color(0x80ffffff),
                    child: Transform.rotate(
                      angle: 50,
                      child: Container(
                        child: Text(
                          '${HedgeSumHelper.numStatusToString(order.hedgingStatus)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
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
