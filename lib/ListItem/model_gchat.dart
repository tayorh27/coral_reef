
class GChat {
  String id, user_uid, username, title, body, created_date;
  int number_of_likes, number_of_comment;
  dynamic user_avatar, images, recent_comments, timestamp;

  GChat(this.id, this.user_uid, this.username, this.user_avatar, this.title, this.body, this.images, this.number_of_likes, this.number_of_comment, this.recent_comments, this.created_date, this.timestamp);
}