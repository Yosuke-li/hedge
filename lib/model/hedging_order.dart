import 'package:json_annotation/json_annotation.dart';

part 'hedging_order.g.dart';

@JsonSerializable()
class HedgingOrder extends Object {
  @JsonKey(name: 'order_id')
  String orderId;

  @JsonKey(name: 'owner_pricing_id')
  String ownerPricingId;

  @JsonKey(name: 'owner_stg_id')
  String ownerStgId;

  @JsonKey(name: 'hedge_qty')
  num hedgeQty;

  @JsonKey(name: 'completed_fut_qty')
  num completedFutQty;

  @JsonKey(name: 'trans_avg_price')
  num transAvgPrice;

  @JsonKey(name: 'failed_qty')
  num failedQty;

  @JsonKey(name: 'hedging_status')
  int hedgingStatus;

  @JsonKey(name: 'spot_qty')
  num spotQty;

  @JsonKey(name: 'completed_spot_qty')
  num completedSpotQty;

  HedgingOrder(
    this.orderId,
    this.ownerPricingId,
    this.ownerStgId,
    this.hedgeQty,
    this.completedFutQty,
    this.transAvgPrice,
    this.failedQty,
    this.hedgingStatus,
    this.spotQty,
    this.completedSpotQty,
  );

  factory HedgingOrder.fromJson(Map<String, dynamic> srcJson) =>
      _$HedgingOrderFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HedgingOrderToJson(this);

  //todo 手动添加
  static List<HedgingOrder> listFromJson(List<dynamic>? json) {
    return json == null
        ? <HedgingOrder>[]
        : json.map((e) => HedgingOrder.fromJson(e)).toList();
  }
}
