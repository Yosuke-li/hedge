import 'dart:convert';

import 'package:hedge_manager/helper/array_helper.dart';
import 'package:hedge_manager/helper/log_utils.dart';
import 'package:hedge_manager/model/filled_order.dart';
import 'package:hedge_manager/model/hedging_order.dart';
import 'package:hedge_manager/model/hedging_strategy.dart';
import 'package:hedge_manager/model/pricing_apply.dart';
import 'package:hedge_manager/widget/message_center/massage/socket_msg.dart';

class HedgeSumHelper {
  static List<HedgingStrategy> _getStrategies(String schemeId) {
    List<HedgingStrategy> strategies = SocketMsgConduit.getHedgingStrategies;
    strategies =
        strategies.where((element) => element.ownerSchId == schemeId).toList();
    return strategies;
  }

  static List<HedgingOrder> getOrders(String stgId) {
    List<HedgingOrder> orders = SocketMsgConduit.getHedgingOrders;
    orders = orders.where((element) => element.ownerStgId == stgId).toList();
    return orders;
  }

  static PricingApply? getPrice(String priceId) {
    List<PricingApply> prices = SocketMsgConduit.getPricingApplies;
    if (prices.isNotEmpty == true) {
      PricingApply? price;
      for (PricingApply e in prices) {
        if (e.pricingId == priceId) price = e;
      }
      if (price != null) {
        return price;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static List<PricingApply> _getPrices(String priceId) {
    List<PricingApply> prices = SocketMsgConduit.getPricingApplies;
    prices = prices.where((element) => element.pricingId == priceId).toList();
    return prices;
  }

  static List<FilledOrder> _getFillOrder(String orderId) {
    List<FilledOrder> orders = SocketMsgConduit.getFilledOrders;
    orders =
        orders.where((element) => element.ownerHedOrdId == orderId).toList();
    return orders;
  }

  //id 不做特殊说明都是指方案id -- scheme_id
  //套保方案已占用现货数量=sum方案下所有策略.已占现货数量
  static double strategiesSumUsedSpotQty(String id) {
    double sum = 0;
    final List<HedgingStrategy> _strategies = _getStrategies(id);
    _strategies.map((e) => sum += e.usedSpotQty).toList();
    return sum;
  }

  //套保方案已成交现货数量= sum方案下所有套保策略.已用现货数量
  static double strategiesSumCompletedSpotQty(String id) {
    double sum = 0;
    final List<HedgingStrategy> _strategies = _getStrategies(id);
    _strategies.map((e) => sum += e.completedSpotQty).toList();
    return sum;
  }

  //套保方案剩余可点价现货数量=套保方案现货容量-套保方案已占用数量-套保方案已完成数量
  static double strategiesAtLessSpotQty(String id) {
    double sum = 0;
    final List<HedgingStrategy> _strategies = _getStrategies(id);
    _strategies.map((e) => sum += e.spotQty).toList();
    sum =
        sum - strategiesSumUsedSpotQty(id) - strategiesSumCompletedSpotQty(id);
    return sum;
  }

  //期货已套保数量=sum方案下所有套保策略.已用期货数量
  static double strategiesSumCompletedFutQty(String id) {
    double sum = 0;
    final List<HedgingStrategy> _strategies = _getStrategies(id);
    _strategies.map((e) => sum += orderSumCompletedQty(e.strategyId)).toList();
    return sum;
  }

  //套保率 套保方案.期货容量/套保方案.现货容量
  static double hedgeRate(String id) {
    double rate = 0.0;
    double futSum = 0;
    double spotSum = 0;
    final List<HedgingStrategy> _strategies = _getStrategies(id);
    for (var e in _strategies) {
      futSum += e.futQty ?? 0;
      spotSum += e.spotQty;
    }

    if (spotSum != 0) {
      rate = futSum / spotSum;
    }
    return rate;
  }

  //当前套保比例=期货已套保数量/套保方案已成交数量
  static double hedgeNowRate(String id) {
    double rate = 0.0;
    if (strategiesSumCompletedSpotQty(id) != 0) {
      rate =
          strategiesSumCompletedFutQty(id) / strategiesSumCompletedSpotQty(id);
    }
    return rate;
  }

  //追单失败数量=sum所有相关指令单.失败数量
  static double failOrders(String id) {
    double sum = 0;
    final List<HedgingStrategy> _strategies = _getStrategies(id);
    _strategies.map((e) => sum += orderSumFail(e.strategyId)).toList();
    return sum;
  }

  // stgId 是指策略id
  // 已占期货数量=sum相关指令单(套保期货数量-已完成期货数量-失败数量)
  static double orderSumQty(String stgId) {
    double sum = 0;
    List<HedgingOrder> _orders = getOrders(stgId);
    _orders = _orders.where((e) => e.hedgingStatus == 0).toList();
    _orders
        .map((e) => sum += (e.hedgeQty - e.completedFutQty - e.failedQty))
        .toList();
    return sum;
  }

  // 失败期货数量=sum相关指令单.失败数量
  static double orderSumFail(String stgId) {
    double sum = 0;
    final List<HedgingOrder> _orders = getOrders(stgId);
    _orders.map((e) => sum += e.failedQty).toList();
    return sum;
  }

  // 已用期货数量=sum相关指令单(已完成期货数量+失败数量)
  static double orderSumCompletedQty(String stgId) {
    double sum = 0;
    final List<HedgingOrder> _orders = getOrders(stgId);
    _orders.map((e) => sum += (e.completedFutQty + e.failedQty)).toList();
    return sum;
  }

  // 可用期货数量=套保策略.期货数量-已占期货数量-已用期货数量
  static double orderSumUsedQty(double? futQty, String stgId) {
    double sum = 0;
    sum = (futQty ?? 0) - orderSumQty(stgId) - orderSumCompletedQty(stgId);
    return sum;
  }

  // 已占现货数量=sum相关点价申请(点价现货数量-已点价现货数量)
  static double pricingSumSpotQty(String stgId) {
    double sum = 0;
    List<HedgingOrder> _orders = getOrders(stgId);
    _orders = _orders.where((e) => e.hedgingStatus == 0).toList();
    for (var e in _orders) {
      sum += (e.spotQty - e.completedSpotQty);
    }
    return sum;
  }

  // 已用现货数量=sum相关点价申请.已点价现货数量
  static double pricingSumUsedSpotQty(String stgId) {
    double sum = 0;
    final List<HedgingOrder> _orders = getOrders(stgId);
    final List<PricingApply> _applies = <PricingApply>[];
    _orders.map((e) => _applies.addAll(_getPrices(e.ownerPricingId))).toList();
    _applies.map((e) => sum += e.pricedSpotQty).toList();
    return sum;
  }

  // 可用现货数量=套保策略.现货数量-已占现货数量-已用现货数量
  static double orderSumCanUsingSpotQty(double spotQTy, String stgId) {
    double sum = 0;
    sum = spotQTy - pricingSumSpotQty(stgId) - pricingSumUsedSpotQty(stgId);
    return sum;
  }

  // 当前套保比例=已用期货数量/已用现货数量
  static double orderRate(String stgId) {
    double rate = 0.0;
    if (pricingSumUsedSpotQty(stgId) != 0) {
      rate = orderSumCompletedQty(stgId) / pricingSumUsedSpotQty(stgId);
    }
    return rate;
  }

  // 预期套保比例=套保策略.期货数量/套保策略.现货数量
  static double orderNowRate(double spotQty, double? futQty) {
    double rate = 0.0;
    if (spotQty != 0) {
      rate = (futQty ?? 0) / spotQty;
    }
    return rate;
  }

  //成交均价
  static double filledOrderSumPrice(String orderId) {
    double sum = 0;
    double quaSum = 0;
    final List<FilledOrder> _orders = _getFillOrder(orderId);
    if (_orders.isNotEmpty) {
      for (var e in _orders) {
        sum += (e.price * e.quantity);
      }
      for (var e in _orders) {
        quaSum += e.quantity;
      }
      sum = sum / quaSum;
    }
    return sum;
  }
}
