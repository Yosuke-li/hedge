// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hedging_strategy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HedgingStrategy _$HedgingStrategyFromJson(Map<String, dynamic> json) =>
    HedgingStrategy(
      json['strategy_id'] as String,
      json['owner_sch_id'] as String,
      json['enter_using_code'] as String?,
      json['priority_no'] as int,
      json['spot_qty'] as num,
      json['used_spot_qty'] as num,
      json['completed_spot_qty'] as num,
      json['used_fut_qty'] as num?,
      json['completed_fut_qty'] as num?,
      json['enter_stg_id'] as String,
      json['stg_status'] as int,
      json['fut_qty'] as num?,
    );

Map<String, dynamic> _$HedgingStrategyToJson(HedgingStrategy instance) =>
    <String, dynamic>{
      'strategy_id': instance.strategyId,
      'owner_sch_id': instance.ownerSchId,
      'priority_no': instance.priorityNo,
      'spot_qty': instance.spotQty,
      'used_spot_qty': instance.usedSpotQty,
      'completed_spot_qty': instance.completedSpotQty,
      'used_fut_qty': instance.usedFutQty,
      'completed_fut_qty': instance.completedFutQty,
      'enter_stg_id': instance.enterStgId,
      'stg_status': instance.stgStatus,
      'fut_qty': instance.futQty ?? 0,
      'enter_using_code': instance.enterUsingCode ?? '',
    };
