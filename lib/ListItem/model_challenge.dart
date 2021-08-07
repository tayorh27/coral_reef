class VirtualChallenge {
  String id,
      user_uid, challenge_type,
      title, activity_type, distance, start_date, end_date, description, funding_type, reward_value, created_date, link, status, join_code;
  dynamic max_user = 0, winner_amount;
  dynamic msgId, timestamp, km_covered, time_taken;
  dynamic winners;

  String winner_reward_type;
  dynamic share_amount;
  bool winner_rewarded, first_rewarded, second_rewarded, third_rewarded;
  dynamic paid_user;
  String time_zone;
  dynamic friends_list;


  VirtualChallenge(this.id, this.user_uid, this.challenge_type,
      this.title, this.activity_type, this.distance, this.start_date, this.end_date, this.description,
      this.funding_type, this.reward_value, this.created_date, this.link, this.msgId, this.timestamp,
      this.max_user, this.status, this.winner_amount, this.join_code, this.time_taken, this.km_covered,
      this.winner_reward_type, this.share_amount, this.winner_rewarded, this.first_rewarded,
      this.second_rewarded, this.third_rewarded, this.paid_user, this.time_zone, this.winners, this.friends_list);

  Map<String, dynamic> toJSON() {
    return {
      'id':id,
      'user_uid':user_uid,
      'challenge_type':challenge_type,
      'title':title,
      'activity_type':activity_type,
      'distance':distance,
      'start_date':start_date,
      'end_date':end_date,
      'description':description,
      'funding_type':funding_type,
      'reward_value':reward_value,
      'created_date':created_date,
      'link':link,
      'msgId':msgId,
      'timestamp':timestamp,
      'max_user':max_user,
      'winner_amount':winner_amount,
      'status':status,
      'join_code':join_code,
      "km_covered": km_covered,
      "time_taken": time_taken,

      "winner_reward_type": winner_reward_type,
      "share_amount": share_amount,
      "winner_rewarded": winner_rewarded,
      "first_rewarded": first_rewarded,
      "second_rewarded": second_rewarded,
      "third_rewarded": third_rewarded,
      "paid_user": paid_user,
      "time_zone": time_zone,
      "winners": winners,
      "friends_list": friends_list,
    };
  }

  VirtualChallenge.fromSnapshot(dynamic data) {
    id = data['id'];
    user_uid = data['user_uid'];
    challenge_type = data['challenge_type'];
    title = data['title'];
    activity_type = data['activity_type'];
    distance = data['distance'];
    start_date = data['start_date'];
    end_date = data['end_date'];
    description = data['description'];
    funding_type = data['funding_type'];
    reward_value = data['reward_value'];
    created_date = data['created_date'];
    link = data['link'];
    msgId = data['msgId'];
    timestamp = data['timestamp'];
    max_user = data['max_user'];
    winner_amount = data['winner_amount'];
    status = data['status'];
    join_code = data['join_code'];
    km_covered = data["km_covered"];
    time_taken = data["time_taken"];

    winner_reward_type = data["winner_reward_type"];
    share_amount = data["share_amount"];
    winner_rewarded = data["winner_rewarded"];
    first_rewarded = data["first_rewarded"];
    second_rewarded = data["second_rewarded"];
    third_rewarded = data["third_rewarded"];
    paid_user = data["paid_user"];
    time_zone = data["time_zone"];
    winners = data["winners"];
    friends_list = data["friends_list"];
  }
}

class VirtualChallengeActivities {

  String id, user_uid, type, text, image, created_date, time_zone;

  dynamic challenge_msgId, timestamp;

  VirtualChallengeActivities(this.id, this.user_uid, this.type, this.text, this.image, this.created_date, this.timestamp, this.challenge_msgId, this.time_zone);

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "user_uid": user_uid,
      "type": type,
      "text": text,
      "image": image,
      "created_date": created_date,
      "timestamp": timestamp,
      "challenge_msgId": challenge_msgId,
      "time_zone": time_zone,
    };
  }

  VirtualChallengeActivities.fromSnapshot(dynamic data) {
    id = data["id"];
    user_uid = data["user_uid"];
    type = data["type"];
    text = data["text"];
    image = data["image"];
    created_date = data["created_date"];
    timestamp = data["timestamp"];
    challenge_msgId = data["challenge_msgId"];
    time_zone = data["time_zone"];
  }
}

class VirtualChallengeMembers {

  String id, user_uid, username, image, created_date;
  bool rewarded;
  dynamic msgId, timestamp, km_covered, time_taken, least_seconds_time_completion, least_meters_distance_completion;
  dynamic steps_taken;
  //rank, km counter, time taken in seconds

  VirtualChallengeMembers(this.id, this.user_uid, this.username, this.image, this.created_date, this.timestamp, this.msgId, this.steps_taken, this.km_covered, this.time_taken, this.least_seconds_time_completion, this.least_meters_distance_completion, this.rewarded);

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "user_uid": user_uid,
      "username": username,
      "image": image,
      "created_date": created_date,
      "timestamp": timestamp,
      "msgId": msgId,
      "steps_taken": steps_taken,
      "km_covered": km_covered,
      "time_taken": time_taken,
      "least_seconds_time_completion": least_seconds_time_completion,
      "least_meters_distance_completion": least_meters_distance_completion,
      "rewarded": rewarded,
    };
  }

  VirtualChallengeMembers.fromSnapshot(dynamic data) {
    id = data["id"];
    user_uid = data["user_uid"];
    username = data["username"];
    image = data["image"];
    created_date = data["created_date"];
    timestamp = data["timestamp"];
    msgId = data["msgId"];
    steps_taken = data["steps_taken"];
    km_covered = data["km_covered"];
    time_taken = data["time_taken"];
    least_seconds_time_completion = data["least_seconds_time_completion"];
    least_meters_distance_completion = data["least_meters_distance_completion"];
    rewarded = data["rewarded"];
  }
}


