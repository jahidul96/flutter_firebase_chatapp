import 'dart:convert';

class UserModel {
  String id;
  String username;
  String email;
  String profilePic;
  String bio;
  String pushToken;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.profilePic,
    required this.bio,
    required this.pushToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profilePic': profilePic,
      'bio': bio,
      'pushToken': pushToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profilePic: map['profilePic'] ?? '',
      bio: map['bio'] ?? '',
      pushToken: map['pushToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
