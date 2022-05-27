import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hedge_manager/helper/array_helper.dart';
import 'package:hedge_manager/helper/log_utils.dart';
import 'package:hedge_manager/model/hedging_scheme.dart';
import 'package:hedge_manager/model/hedging_strategy.dart';
import 'package:hedge_manager/page/hedge/hedge_helper.dart';
import 'package:hedge_manager/widget/message_center/massage/socket_msg.dart';
import 'package:hedge_manager/widget/message_center/socket_listener.dart';

import 'controller.dart';

class PageViewPage extends StatefulWidget {
  final HedgeController controller;

  const PageViewPage({required this.controller, Key? key}) : super(key: key);

  @override
  State<PageViewPage> createState() => _PageViewPageState();
}

class _PageViewPageState extends State<PageViewPage>
    with SocketListener<PageViewPage> {
  final ScrollController _controller = ScrollController();
  int selectIndex = 0;
  double nowPosition = 0;

  @override
  int get msgType => 2;

  @override
  List<int> get listenerTypes => [2, 3, 4, 5, 6];

  List<HedgingStrategy> strategies = <HedgingStrategy>[];
  List<HedgingScheme> schemes = <HedgingScheme>[];

  @override
  void initState() {
    super.initState();
    init();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      schemes.clear();
      schemes.addAll(SocketMsgConduit.getHedgingSchemes);
      widget.controller
          .changeId(ArrayHelper.get(schemes, selectIndex)?.schemeId ?? '');
      setState(() {});
    });
  }

  void init() {
    _controller.addListener(() {});
    onListener((msg) {
      if (msg.type == msgType) {
        Log.info('${msg.chgType}');
        schemes.clear();
        schemes.addAll(SocketMsgConduit.getHedgingSchemes);
        widget.controller
            .changeId(ArrayHelper.get(schemes, selectIndex)?.schemeId ?? '');
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: InkWell(
              onTap: () {
                nowPosition -= 380;
                if (nowPosition < 0) {
                  nowPosition = 0;
                }
                _controller.animateTo(nowPosition,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease);
                selectIndex -= 1;
                if (selectIndex < 0) {
                  selectIndex = 0;
                }
                widget.controller
                    .changeId(ArrayHelper.get(schemes, selectIndex)!.schemeId);
                setState(() {});
              },
              child: const Icon(
                IconData(0xe660, fontFamily: 'AliIcons'),
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 200,
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Scrollbar(
                controller: _controller,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: schemes.length,
                  controller: _controller,
                  itemBuilder: (BuildContext context, int index) {
                    final HedgingScheme e = ArrayHelper.get(schemes, index)!;
                    return Container(
                      width: 370,
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                        color: selectIndex == index
                            ? const Color(0xffFFFBFE)
                            : const Color(0xffE1E0FF),
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: const Color(0xff797979),
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          selectIndex = index;
                          widget.controller.changeId(
                              ArrayHelper.get(schemes, selectIndex)!.schemeId);
                          setState(() {});
                        },
                        child: _PageItemView(
                          hedgingScheme: e,
                          key: Key(e.hashCode.toString()),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            width: 30,
            child: InkWell(
              onTap: () {
                nowPosition += 380;
                if (nowPosition > _controller.position.maxScrollExtent) {
                  nowPosition = _controller.position.maxScrollExtent;
                }
                _controller.animateTo(nowPosition,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease);
                selectIndex += 1;
                if (selectIndex > schemes.length - 1) {
                  selectIndex = schemes.length - 1;
                }
                widget.controller
                    .changeId(ArrayHelper.get(schemes, selectIndex)!.schemeId);
                setState(() {});
              },
              child: const Icon(
                IconData(0xe65f, fontFamily: 'AliIcons'),
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageItemView extends StatefulWidget {
  final HedgingScheme hedgingScheme;

  const _PageItemView({required this.hedgingScheme, Key? key})
      : super(key: key);

  @override
  State<_PageItemView> createState() => _PageItemViewState();
}

class _PageItemViewState extends State<_PageItemView>
    with SocketListener<_PageItemView> {
  late HedgingScheme e;

  @override
  void initState() {
    super.initState();
    e = widget.hedgingScheme;
    setState(() {});
    _onListener();
  }

  void _onListener() {
    onListener((msgContent) {
      if (msgContent.type == msgType) {
        List<HedgingScheme> _schemes =
            HedgingScheme.listFromJson(msgContent.content);
        if (_schemes.any((element) => element.schemeId == e.schemeId)) {
          e = _schemes.firstWhere((element) => element.schemeId == e.schemeId);
        }
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(covariant _PageItemView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                e.schemeName,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      e.usingCode,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          margin: const EdgeInsets.only(left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    '${HedgeSumHelper.strategiesSumUsedSpotQty(e.schemeId)} ',
                    maxLines: 1,
                    style: const TextStyle(fontSize: 26),
                  ),
                  const Text(
                    '已占用数量（吨）',
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xff797979),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  '/',
                  style: TextStyle(fontSize: 26),
                ),
              ),
              Column(
                children: [
                  Text(
                    '${HedgeSumHelper.strategiesSumCompletedSpotQty(e.schemeId)}',
                    maxLines: 1,
                    style: const TextStyle(fontSize: 26),
                  ),
                  const Text(
                    '已成交数量（吨）',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xff797979),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  '/',
                  style: TextStyle(fontSize: 26),
                ),
              ),
              Column(
                children: [
                  Text(
                    ' ${HedgeSumHelper.strategiesAtLessSpotQty(e.schemeId)}',
                    maxLines: 1,
                    style: const TextStyle(fontSize: 26),
                  ),
                  const Text(
                    '剩余可点价数量(吨)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xff797979),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      '${HedgeSumHelper.strategiesSumCompletedFutQty(e.schemeId)}',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      '已套保数量',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xff797979),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      '${(HedgeSumHelper.hedgeNowRate(e.schemeId) * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '套保率${(HedgeSumHelper.hedgeRate(e.schemeId) * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xff797979),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      '${HedgeSumHelper.failOrders(e.schemeId)}',
                      style: const TextStyle(fontSize: 20, color: Colors.red),
                    ),
                    const Text(
                      '追单失败数量',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xff797979),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  List<int> get listenerTypes => [2, 3, 4, 5, 6, 7];

  @override
  int get msgType => 2;
}
