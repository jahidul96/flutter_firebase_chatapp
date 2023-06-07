import 'dart:convert';

import 'package:knockme/models/user_model.dart';

class GroupModel {
  String groupName;
  String lastMsg;
  List members;
  List<UserModel> memberDetails;
  UserModel adminDetails;
  DateTime createdAt;
  String adminId;
  String groupImg;
  bool seen;
  String senderId;
  bool justCreated;
  GroupModel({
    required this.groupName,
    required this.lastMsg,
    required this.members,
    required this.memberDetails,
    required this.adminDetails,
    required this.createdAt,
    required this.adminId,
    required this.groupImg,
    required this.seen,
    required this.senderId,
    required this.justCreated,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupName': groupName,
      'lastMsg': lastMsg,
      'members': members,
      'memberDetails': memberDetails.map((x) => x.toMap()).toList(),
      'adminDetails': adminDetails.toMap(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'adminId': adminId,
      'groupImg': groupImg,
      'seen': seen,
      'senderId': senderId,
      'justCreated': justCreated,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupName: map['groupName'] ?? '',
      lastMsg: map['lastMsg'] ?? '',
      members: List.from(map['members']),
      memberDetails: List<UserModel>.from(
          map['memberDetails']?.map((x) => UserModel.fromMap(x))),
      adminDetails: UserModel.fromMap(map['adminDetails']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      adminId: map['adminId'] ?? '',
      groupImg: map['groupImg'] ?? '',
      seen: map['seen'] ?? false,
      senderId: map['senderId'] ?? '',
      justCreated: map['justCreated'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source));
}
