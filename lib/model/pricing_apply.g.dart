// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricing_apply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PricingApply _$PricingApplyFromJson(Map<String, dynamic> json) => PricingApply(
      json['pricing_id'] as String,
      json['pricing_using_code'] as String,
      json['pricing_spot_qty'] as num,
      json['priced_spot_qty'] as num,
      json['pricing_price'] as num,
      json['pricing_status'] as int,
    );

Map<String, dynamic> _$PricingApplyToJson(PricingApply instance) =>
    <String, dynamic>{
      'pricing_id': instance.pricingId,
      'pricing_using_code': instance.pricingUsingCode,
      'pricing_spot_qty': instance.pricingSpotQty,
      'priced_spot_qty': instance.pricedSpotQty,
      'pricing_price': instance.pricingPrice,
      'pricing_status': instance.pricingStatus,
    };
