// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hedging_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HedgingOrder _$HedgingOrderFromJson(Map<String, dynamic> json) => HedgingOrder(
      json['order_id'] as String,
      json['owner_pricing_id'] as String,
      json['owner_stg_id'] as String,
      json['hedge_qty'] as num,
      json['completed_fut_qty'] as num,
      json['trans_avg_price'] as num,
      json['failed_qty'] as num,
      json['hedging_status'] as int,
      json['spot_qty'] as num,
      json['completed_spot_qty'] as num,
    );

Map<String, dynamic> _$HedgingOrderToJson(HedgingOrder instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'owner_pricing_id': instance.ownerPricingId,
      'owner_stg_id': instance.ownerStgId,
      'hedge_qty': instance.hedgeQty,
      'completed_fut_qty': instance.completedFutQty,
      'trans_avg_price': instance.transAvgPrice,
      'failed_qty': instance.failedQty,
      'hedging_status': instance.hedgingStatus,
      'spot_qty': instance.failedQty,
      'completed_spot_qty': instance.hedgingStatus,
    };
