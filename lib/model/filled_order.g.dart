// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filled_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilledOrder _$FilledOrderFromJson(Map<String, dynamic> json) => FilledOrder(
  json['filled_order_id'] as String,
  json['owner_hed_ord_id'] as String,
  json['side'] as num,
  json['price'] as num,
  json['quantity'] as num,
  json['using_code'] as String,
);

Map<String, dynamic> _$FilledOrderToJson(FilledOrder instance) =>
    <String, dynamic>{
      'filled_order_id': instance.filledOrderId,
      'owner_hed_ord_id': instance.ownerHedOrdId,
      'side': instance.side,
      'price': instance.price,
      'quantity': instance.quantity,
      'using_code': instance.usingCode,
    };
