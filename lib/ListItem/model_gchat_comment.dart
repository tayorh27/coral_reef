class GChatComment {
  String id, main_comment_id,
      gchat_id,
      user_uid,
      message, created_date, username;
  int number_of_likes;
  dynamic avatar, msgId;
  dynamic timestamp;//link**
  String time_zone;

  GChatComment(this.id, this.main_comment_id, this.gchat_id, this.user_uid, this.username, this.avatar, this.message, this.created_date, this.msgId, this.timestamp, this.time_zone, this.number_of_likes);

  Map<String, dynamic> toJSON() {
    return {
      'id':id,
      'main_comment_id':main_comment_id,
      'gchat_id':gchat_id,
      'user_uid':user_uid,
      'username':username,
      'avatar':avatar,
      'message':message,
      'created_date':created_date,
      'msgId':msgId,
      'timestamp':timestamp,
      'time_zone':time_zone,
      'number_of_likes':number_of_likes
    };
  }

  GChatComment.fromSnapshot(dynamic data) {
    id = data['id'];
    main_comment_id = data['main_comment_id'];
    gchat_id = data['gchat_id'];
    user_uid = data['user_uid'];
    username = data['username'];
    avatar = data['avatar'];
    message = data['message'];
    created_date = data['created_date'];
    msgId = data['msgId'];
    timestamp = data['timestamp'];
    time_zone = data['time_zone'];
    number_of_likes = data['number_of_likes'];
  }
}


