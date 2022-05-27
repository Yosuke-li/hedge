import 'package:json_annotation/json_annotation.dart';

part 'hedging_scheme.g.dart';


@JsonSerializable()
class HedgingScheme extends Object {

  @JsonKey(name: 'scheme_id')
  String schemeId;

  @JsonKey(name: 'scheme_name')
  String schemeName;

  @JsonKey(name: 'using_code')
  String usingCode;

  HedgingScheme(this.schemeId,this.schemeName,this.usingCode,);

  factory HedgingScheme.fromJson(Map<String, dynamic> srcJson) => _$HedgingSchemeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HedgingSchemeToJson(this);

  static List<HedgingScheme> listFromJson(List<dynamic>? json) {
    return json == null
        ? <HedgingScheme>[]
        : json.map((e) => HedgingScheme.fromJson(e)).toList();
  }

}


