class GChatComment {
  String id,
      gchat_id,
      user_uid,
      message, created_date, username;
  dynamic avatar, msgId;
  dynamic timestamp;//link**

  GChatComment(this.id, this.gchat_id, this.user_uid, this.username, this.avatar, this.message, this.created_date, this.msgId, this.timestamp);

  Map<String, dynamic> toJSON() {
    return {
      'id':id,
      'gchat_id':gchat_id,
      'user_uid':user_uid,
      'username':username,
      'avatar':avatar,
      'message':message,
      'created_date':created_date,
      'msgId':msgId,
      'timestamp':timestamp,
    };
  }

  GChatComment.fromSnapshot(dynamic data) {
    id = data['id'];
    gchat_id = data['gchat_id'];
    user_uid = data['user_uid'];
    username = data['username'];
    avatar = data['avatar'];
    message = data['message'];
    created_date = data['created_date'];
    msgId = data['msgId'];
    timestamp = data['timestamp'];
  }
}


