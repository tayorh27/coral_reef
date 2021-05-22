class VirtualChallenge {
  String id,
      user_uid, challenge_type,
      title, activity_type, distance, start_date, end_date, description, reward_type, reward_value, created_date, link, status, join_code;
  int max_user = 0, winner_amount;
  dynamic msgId, timestamp, km_covered, time_taken;



  VirtualChallenge(this.id, this.user_uid, this.challenge_type,
      this.title, this.activity_type, this.distance, this.start_date, this.end_date, this.description, this.reward_type, this.reward_value, this.created_date, this.link, this.msgId, this.timestamp, this.max_user, this.status, this.winner_amount, this.join_code, this.time_taken, this.km_covered);

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
      'reward_type':reward_type,
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
    reward_type = data['reward_type'];
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
  }
}

class VirtualChallengeActivities {

  String id, user_uid, type, text, image, created_date;

  dynamic challenge_msgId, timestamp;

  VirtualChallengeActivities(this.id, this.user_uid, this.type, this.text, this.image, this.created_date, this.timestamp, this.challenge_msgId);

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
  }
}

class VirtualChallengeMembers {

  String id, user_uid, username, image, created_date;

  dynamic msgId, timestamp, km_covered, time_taken, least_seconds_time_completion, least_meters_distance_completion;

  //rank, km counter, time taken in seconds

  VirtualChallengeMembers(this.id, this.user_uid, this.username, this.image, this.created_date, this.timestamp, this.msgId, this.km_covered, this.time_taken, this.least_seconds_time_completion, this.least_meters_distance_completion);

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "user_uid": user_uid,
      "username": username,
      "image": image,
      "created_date": created_date,
      "timestamp": timestamp,
      "msgId": msgId,
      "km_covered": km_covered,
      "time_taken": time_taken,
      "least_seconds_time_completion": least_seconds_time_completion,
      "least_meters_distance_completion": least_meters_distance_completion,
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
    km_covered = data["km_covered"];
    time_taken = data["time_taken"];
    least_seconds_time_completion = data["least_seconds_time_completion"];
    least_meters_distance_completion = data["least_meters_distance_completion"];
  }
}


