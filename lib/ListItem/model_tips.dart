
class PregnancyTips {
  String id, image, title, body, created_date;
  dynamic timestamp;

  PregnancyTips.fromSnapshot(dynamic data) {
    id = data['id'];
    image = data['image'];
    created_date = data['created_date'];
    timestamp = data['timestamp'];
    title = data['title'];
    body = data['body'];
  }
}