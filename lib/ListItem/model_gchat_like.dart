class GChatLike {
  String id,
      gchat_id,
      user_uid, created_date,username, comment_id, like_type;
  dynamic avatar;
  dynamic timestamp;

  GChatLike(this.id, this.gchat_id, this.comment_id, this.like_type, this.user_uid, this.username, this.avatar, this.created_date, this.timestamp);

  Map<String, dynamic> toJSON() {
    return {
      'id':id,
      'gchat_id':gchat_id,
      'comment_id':comment_id,
      'like_type':like_type, //gchat or comment
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
    comment_id = data['comment_id'];
    like_type = data['like_type'];
    user_uid = data['user_uid'];
    username = data['username'];
    avatar = data['avatar'];
    created_date = data['created_date'];
    timestamp = data['timestamp'];
  }
}


