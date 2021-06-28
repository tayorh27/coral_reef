class GChat {
  String id, user_uid, username, title, body, created_date, link, visibility;
  int number_of_likes,
      number_of_comments,
      number_of_reports,
      number_of_impressions;
  dynamic user_avatar, images, recent_comments, timestamp, topics;
  String time_zone;
  bool rewarded_token;

  GChat(
      this.id,
      this.user_uid,
      this.username,
      this.user_avatar,
      this.title,
      this.body,
      this.images,
      this.number_of_likes,
      this.number_of_comments,
      this.number_of_reports,
      this.number_of_impressions,
      this.recent_comments,
      this.created_date,
      this.timestamp,
      this.topics,
      this.rewarded_token,
      this.link,
      this.visibility,
      this.time_zone);

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'user_uid': user_uid,
      'username': username,
      'user_avatar': user_avatar,
      'title': title,
      'body': body,
      'images': images,
      'number_of_likes': number_of_likes,
      'number_of_comments': number_of_comments,
      'number_of_reports': number_of_reports,
      'number_of_impressions': number_of_impressions,
      'recent_comments': recent_comments,
      'created_date': created_date,
      'timestamp': timestamp,
      'topics': topics,
      'rewarded_token': rewarded_token,
      'link': link,
      'visibility': visibility,
      'time_zone': time_zone
    };
  }

  GChat.fromSnapshot(dynamic data) {
    id = data['id'];
    user_uid = data['user_uid'];
    username = data['username'];
    user_avatar = data['user_avatar'];
    title = data['title'];
    body = data['body'];
    images = data['images'];
    number_of_likes = data['number_of_likes'];
    number_of_comments = data['number_of_comments'];
    number_of_reports = data['number_of_reports'];
    number_of_impressions = data['number_of_impressions'];
    recent_comments = data['recent_comments'];
    created_date = data['created_date'];
    timestamp = data['timestamp'];
    topics = data['topics'];
    rewarded_token = data['rewarded_token'];
    link = data['link'];
    visibility = data['visibility'];
    time_zone = data['time_zone'];
  }
}
