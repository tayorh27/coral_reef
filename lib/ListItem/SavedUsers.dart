class SavedUsers {
  String id, uid, email, name, created_date;
  dynamic msgId;
  dynamic timestamp;

  SavedUsers(this.id, this.uid, this.email, this.name, this.msgId, this.created_date, this.timestamp);

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'uid': uid,
      'email': email,
      'name': name,
      'msgId': msgId,
      'created_date': created_date,
      'timestamp': timestamp,
    };
  }

  SavedUsers.fromSnapshot(dynamic data) {
    id = data['id'];
    uid = data['uid'];
    email = data['email'];
    name = data['name'];
    msgId = data['msgId'];
    created_date = data['created_date'];
    timestamp = data['timestamp'];
  }
}