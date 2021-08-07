class NotificationsModel {
  String id, title, message, header, created_date;
  dynamic timestamp;

  NotificationsModel(this.id, this.title, this.message, this.header, this.created_date, this.timestamp);

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'header': header,
      'created_date': created_date,
      'timestamp': timestamp,
    };
  }

  NotificationsModel.fromSnapshot(dynamic data) {
    id = data['id'];
    title = data['title'];
    message = data['message'];
    header = data['header'];
    created_date = data['created_date'];
    timestamp = data['timestamp'];
  }
}