import 'dart:convert';

import 'package:hedge_manager/helper/event_bus_helper.dart';
import 'package:hedge_manager/helper/global/setting.dart';
import 'package:hedge_manager/helper/log_utils.dart';
import 'package:hedge_manager/model/enter_strategy.dart';
import 'package:hedge_manager/model/filled_order.dart';
import 'package:hedge_manager/model/hedging_order.dart';
import 'package:hedge_manager/model/hedging_scheme.dart';
import 'package:hedge_manager/model/hedging_strategy.dart';
import 'package:hedge_manager/model/msg_content.dart';
import 'package:hedge_manager/model/pricing_apply.dart';

import 'socket_msg_control.dart';

class SocketMsgConduit {
  static List<MsgContent> _msgContents = <MsgContent>[];

  //type = 2
  static List<HedgingScheme> _hedgingSchemes = <HedgingScheme>[];

  //type = 3
  static List<HedgingStrategy> _hedgingStrategies = <HedgingStrategy>[];

  //type = 4
  static List<EnterStrategy> _enterStrategies = <EnterStrategy>[];

  //type = 5
  static List<PricingApply> _pricingApply = <PricingApply>[];

  //type = 6
  static List<HedgingOrder> _hedgingOrders = <HedgingOrder>[];

  //type = 7
  static List<FilledOrder> _filledOrders = <FilledOrder>[];


  static void listener(event) async  {
    final MsgContent msg = MsgContent.fromJson(json.decode(event));
    _msgContents.add(msg);
    if (msg.chgType != 'DELETED') {
      await _helper(msg);
    } else {
      await _delete(msg);
    }
    SocketMsgControl.sendMsg(Event()..msg = msg);
  }

  static void onTapReconnect() {
    EventBusHelper.asyncStreamController
        ?.add(Event()..isReconnect = true);
  }

  //获取对应类型的记录
  static List<HedgingStrategy> getHedgingStrategies = _hedgingStrategies;
  static List<HedgingOrder> getHedgingOrders = _hedgingOrders;
  static List<HedgingScheme> getHedgingSchemes = _hedgingSchemes;
  static List<EnterStrategy> getEnterStrategies = _enterStrategies;
  static List<PricingApply> getPricingApplies = _pricingApply;
  static List<FilledOrder> getFilledOrders = _filledOrders;
  static List<MsgContent> getAll = _msgContents;

  static void clean() {
    _msgContents.clear();
    _hedgingOrders.clear();
    _hedgingSchemes.clear();
    _hedgingStrategies.clear();
    _enterStrategies.clear();
    _pricingApply.clear();
    _filledOrders.clear();
    SocketMsgControl.clean();
  }

  static Future<void> _helper(MsgContent msg) async {
    switch (msg.type) {
      case 2:
        List<HedgingScheme> _new = HedgingScheme.listFromJson(msg.content as List<dynamic>);
        if (_hedgingSchemes.any((element) =>
            _new.map((e) => e.schemeId).toList().contains(element.schemeId))) {
          _new
              .map((e) => _hedgingSchemes
                  .removeWhere((element) => element.schemeId == e.schemeId))
              .toList();
        }
        _hedgingSchemes.addAll(_new);
        break;
      case 3:
        List<HedgingStrategy> _new = HedgingStrategy.listFromJson(msg.content as List<dynamic>);
        if (_hedgingStrategies.any((element) => _new
            .map((e) => e.strategyId)
            .toList()
            .contains(element.strategyId))) {
          _new
              .map((e) => _hedgingStrategies
                  .removeWhere((element) => element.strategyId == e.strategyId))
              .toList();
        }
        _hedgingStrategies.addAll(_new);
        break;
      case 4:
        List<EnterStrategy> _new = EnterStrategy.listFromJson(msg.content as List<dynamic>);
        if (_enterStrategies.any((element) => _new
            .map((e) => e.enterStgId)
            .toList()
            .contains(element.enterStgId))) {
          _new
              .map((e) => _enterStrategies
                  .removeWhere((element) => element.enterStgId == e.enterStgId))
              .toList();
        }
        _enterStrategies.addAll(_new);
        break;
      case 5:
        List<PricingApply> _new = PricingApply.listFromJson(msg.content as List<dynamic>);
        if (_pricingApply.any((element) => _new
            .map((e) => e.pricingId)
            .toList()
            .contains(element.pricingId))) {
          _new
              .map((e) => _pricingApply
                  .removeWhere((element) => element.pricingId == e.pricingId))
              .toList();
        }
        _pricingApply.addAll(_new);
        break;
      case 6:
        List<HedgingOrder> _new = HedgingOrder.listFromJson(msg.content as List<dynamic>);
        if (_hedgingOrders.any((element) =>
            _new.map((e) => e.orderId).toList().contains(element.orderId))) {
          _new
              .map((e) => _hedgingOrders
                  .removeWhere((element) => element.orderId == e.orderId))
              .toList();
        }
        _hedgingOrders.addAll(_new);
        break;
      case 7:
        List<FilledOrder> _new = FilledOrder.listFromJson(msg.content as List<dynamic>);
        if (_filledOrders.any((element) =>
            _new.map((e) => e.filledOrderId).toList().contains(element.filledOrderId))) {
          _new
              .map((e) => _filledOrders
                  .removeWhere((element) => element.filledOrderId == e.filledOrderId))
              .toList();
        }
        _filledOrders.addAll(_new);
        break;
    }
  }

  static Future<void> _delete(MsgContent msg) async {
    switch (msg.type) {
      case 2:
        _hedgingSchemes.removeWhere((element) => element.schemeId == (msg.content as String));
        break;
      case 3:
        _hedgingStrategies.removeWhere((element) => element.strategyId == (msg.content as String));
        break;
      case 4:
        _enterStrategies.removeWhere((element) => element.enterStgId == (msg.content as String));
        break;
      case 5:
        _pricingApply.removeWhere((element) => element.pricingId == (msg.content as String));
        break;
      case 6:
        _hedgingOrders.removeWhere((element) => element.orderId == (msg.content as String));
        break;
      case 7:
        _filledOrders.removeWhere((element) => element.filledOrderId == (msg.content as String));
        break;
    }
  }
}
