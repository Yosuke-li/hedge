// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsgContent _$MsgContentFromJson(Map<String, dynamic> json) => MsgContent(
      json['type'] as int,
      json['init'] as bool,
      json['msg_no'] as int,
      json['content'] as dynamic,
      json['chg_type'] as String?,
    );

Map<String, dynamic> _$MsgContentToJson(MsgContent instance) =>
    <String, dynamic>{
      'type': instance.type,
      'init': instance.init,
      'msg_no': instance.msgNo,
      'content': instance.content,
      'chg_type': instance.chgType,
    };
