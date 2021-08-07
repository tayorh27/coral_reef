
class ChallengeRewards {
  String id, challenge_id, month_year, created_date;
  dynamic position;
  dynamic timestamp;

  ChallengeRewards.fromSnapshot(dynamic data) {
    id = data['id'];
    challenge_id = data['challenge_id'];
    position = data['position'];
    created_date = data['created_date'];
    timestamp = data['timestamp'];
    month_year = data['month_year'];
  }
}