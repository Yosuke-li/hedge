import 'package:json_annotation/json_annotation.dart';

part 'enter_strategy.g.dart';


@JsonSerializable()
class EnterStrategy extends Object {

  @JsonKey(name: 'enter_stg_id')
  String enterStgId;

  @JsonKey(name: 'enter_stg_name')
  String enterStgName;

  EnterStrategy(this.enterStgId,this.enterStgName,);

  factory EnterStrategy.fromJson(Map<String, dynamic> srcJson) => _$EnterStrategyFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EnterStrategyToJson(this);

  static List<EnterStrategy> listFromJson(List<dynamic>? json) {
    return json == null
        ? <EnterStrategy>[]
        : json.map((e) => EnterStrategy.fromJson(e)).toList();
  }
}


