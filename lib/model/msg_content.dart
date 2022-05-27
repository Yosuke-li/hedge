import 'package:json_annotation/json_annotation.dart';

part 'msg_content.g.dart';


@JsonSerializable()
class MsgContent extends Object {

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'init')
  bool init;

  @JsonKey(name: 'msg_no')
  int msgNo;

  @JsonKey(name: 'chg_type')
  String? chgType;

  @JsonKey(name: 'content')
  dynamic content;

  MsgContent(this.type,this.init,this.msgNo,this.content,this.chgType);

  factory MsgContent.fromJson(Map<String, dynamic> srcJson) => _$MsgContentFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MsgContentToJson(this);

}


