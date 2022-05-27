// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hedging_scheme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HedgingScheme _$HedgingSchemeFromJson(Map<String, dynamic> json) =>
    HedgingScheme(
      json['scheme_id'] as String,
      json['scheme_name'] as String,
      json['using_code'] as String,
    );

Map<String, dynamic> _$HedgingSchemeToJson(HedgingScheme instance) =>
    <String, dynamic>{
      'scheme_id': instance.schemeId,
      'scheme_name': instance.schemeName,
      'using_code': instance.usingCode,
    };
