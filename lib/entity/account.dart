import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class KiteUser {
  int uid = 0;
  String account = '';

  KiteUser();
  factory KiteUser.fromJson(Map<String, dynamic> json) => _$KiteUserFromJson(json);
  Map<String, dynamic> toJson() => _$KiteUserToJson(this);
  @override
  String toString() {
    return 'KiteUser{uid: $uid, account: $account}';
  }
}
