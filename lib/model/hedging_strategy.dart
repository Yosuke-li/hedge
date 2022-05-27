import 'package:json_annotation/json_annotation.dart';

part 'hedging_strategy.g.dart';


@JsonSerializable()
class HedgingStrategy extends Object {

  @JsonKey(name: 'strategy_id')
  String strategyId;

  @JsonKey(name: 'owner_sch_id')
  String ownerSchId;

  @JsonKey(name: 'priority_no')
  int priorityNo;

  @JsonKey(name: 'spot_qty')
  num spotQty;

  @JsonKey(name: 'used_spot_qty')
  num usedSpotQty;

  @JsonKey(name: 'completed_spot_qty')
  num completedSpotQty;

  @JsonKey(name: 'used_fut_qty')
  num? usedFutQty;

  @JsonKey(name: 'completed_fut_qty')
  num? completedFutQty;

  @JsonKey(name: 'enter_stg_id')
  String enterStgId;

  @JsonKey(name: 'stg_status')
  int stgStatus;

  @JsonKey(name: 'fut_qty')
  num? futQty;

  @JsonKey(name: 'enter_using_code')
  String? enterUsingCode;

  HedgingStrategy(this.strategyId,this.ownerSchId,this.enterUsingCode,this.priorityNo,this.spotQty,this.usedSpotQty,this.completedSpotQty,this.usedFutQty,this.completedFutQty,this.enterStgId,this.stgStatus,this.futQty);

  factory HedgingStrategy.fromJson(Map<String, dynamic> srcJson) => _$HedgingStrategyFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HedgingStrategyToJson(this);

  static List<HedgingStrategy> listFromJson(List<dynamic>? json) {
    return json == null
        ? <HedgingStrategy>[]
        : json.map((e) => HedgingStrategy.fromJson(e)).toList();
  }
}


