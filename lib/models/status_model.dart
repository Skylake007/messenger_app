// ignore_for_file: public_member_api_docs, sort_constructors_first
class Status {
  final String uid;
  final String username;
  final String phoneNumber;
  final List<String> photoUrl;
  final DateTime createAt;
  final String profilePic;
  final String statusId;
  final List<String> whoCanSee;
  Status({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.photoUrl,
    required this.createAt,
    required this.profilePic,
    required this.statusId,
    required this.whoCanSee,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'createAt': createAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
      'whoCanSee': whoCanSee,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrl: List<String>.from((map['photoUrl'])),
      createAt: DateTime.fromMillisecondsSinceEpoch(map['createAt'] as int),
      profilePic: map['profilePic'] ?? '',
      statusId: map['statusId'] ?? '',
      whoCanSee:
          map['whoCanSee'] != null ? List<String>.from(map['whoCanSee']) : [],
    );
  }
}
