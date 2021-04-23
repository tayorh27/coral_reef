class GChatLike {
  String id,
      gchat_id,
      user_uid, created_date,username;
  dynamic avatar;
  dynamic timestamp;

  GChatLike(this.id, this.gchat_id, this.user_uid, this.username, this.avatar, this.created_date, this.timestamp);

  Map<String, dynamic> toJSON() {
    return {
      'id':id,
      'gchat_id':gchat_id,
      'user_uid':user_uid,
      'username':username,
      'avatar':avatar,
      'created_date':created_date,
      'timestamp':timestamp,
    };
  }

  GChatLike.fromSnapshot(dynamic data) {
    id = data['id'];
    gchat_id = data['gchat_id'];
    user_uid = data['user_uid'];
    username = data['username'];
    avatar = data['avatar'];
    created_date = data['created_date'];
    timestamp = data['timestamp'];
  }
}


