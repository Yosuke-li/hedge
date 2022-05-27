import 'package:json_annotation/json_annotation.dart';

part 'filled_order.g.dart';


@JsonSerializable()
  class FilledOrder extends Object {

  @JsonKey(name: 'filled_order_id')
  String filledOrderId;

  @JsonKey(name: 'owner_hed_ord_id')
  String ownerHedOrdId;

  @JsonKey(name: 'side')
  num side;

  @JsonKey(name: 'price')
  num price;

  @JsonKey(name: 'quantity')
  num quantity;

  @JsonKey(name: 'using_code')
  String usingCode;

  FilledOrder(this.filledOrderId,this.ownerHedOrdId,this.side,this.price,this.quantity,this.usingCode,);

  factory FilledOrder.fromJson(Map<String, dynamic> srcJson) => _$FilledOrderFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FilledOrderToJson(this);

  static List<FilledOrder> listFromJson(List<dynamic>? json) {
    return json == null
        ? <FilledOrder>[]
        : json.map((e) => FilledOrder.fromJson(e)).toList();
  }
}


