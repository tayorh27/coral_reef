class GChatReport {
  String id,
      gchat_id,
      user_uid, created_date, reason, type,username;
  dynamic avatar;
  dynamic timestamp;

  GChatReport(this.id, this.gchat_id, this.user_uid, this.username, this.avatar, this.reason, this.type, this.created_date, this.timestamp);

  Map<String, dynamic> toJSON() {
    return {
      'id':id,
      'gchat_id':gchat_id,
      'user_uid':user_uid,
      'username':username,
      'avatar':avatar,
      'reason':reason,
      'type':type,
      'created_date':created_date,
      'timestamp':timestamp,
    };
  }

  GChatReport.fromSnapshot(dynamic data) {
    id = data['id'];
    gchat_id = data['gchat_id'];
    user_uid = data['user_uid'];
    username = data['username'];
    avatar = data['avatar'];
    reason = data['reason'];
    type = data['type'];
    created_date = data['created_date'];
    timestamp = data['timestamp'];
  }
}


