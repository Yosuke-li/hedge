import 'package:json_annotation/json_annotation.dart';

part 'pricing_apply.g.dart';


@JsonSerializable()
class PricingApply extends Object {

  @JsonKey(name: 'pricing_id')
  String pricingId;

  @JsonKey(name: 'pricing_using_code')
  String pricingUsingCode;

  @JsonKey(name: 'pricing_spot_qty')
  num pricingSpotQty;

  @JsonKey(name: 'priced_spot_qty')
  num pricedSpotQty;

  @JsonKey(name: 'pricing_price')
  num pricingPrice;

  @JsonKey(name: 'pricing_status')
  int pricingStatus;

  PricingApply(this.pricingId,this.pricingUsingCode,this.pricingSpotQty,this.pricedSpotQty,this.pricingPrice,this.pricingStatus,);

  factory PricingApply.fromJson(Map<String, dynamic> srcJson) => _$PricingApplyFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PricingApplyToJson(this);

  //todo 手动添加
  static List<PricingApply> listFromJson(List<dynamic>? json) {
    return json == null
        ? <PricingApply>[]
        : json.map((e) => PricingApply.fromJson(e)).toList();
  }
}


