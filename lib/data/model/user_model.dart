import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  String? username;
  String? phone;
  String? email;
  String? id;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? password;

  User({
    this.username,
    this.phone,
    this.email,
    this.id,
    this.password,
  });
  User.fromJson(Map<dynamic, dynamic> map)
      : id = map['id'] ?? "",
        phone = map['phone'] ?? "",
        username = map['username'] ?? "",
        email = map['email'] ?? "";

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'username': username,
        'email': email,
      };
}
